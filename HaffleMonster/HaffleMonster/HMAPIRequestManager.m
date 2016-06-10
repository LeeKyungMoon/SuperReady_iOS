//
//  HMAPIRequestManager.m
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 23..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMAPIRequestManager.h"

@implementation UIImageView (AFNetworkingAddtions)

- (void)setImageWithURLCached:(NSString *)urlString placeholderImage:(UIImage*)placeholderImage{
    NSURL *url;
    url = [NSURL URLWithString:urlString];
    [self sd_setImageWithURL:url placeholderImage:placeholderImage];
}

- (void)setImageWithURLCached:(NSString *)urlString completed:(void(^)(UIImage *image))completed{
    NSURL *url;
    url = [NSURL URLWithString:urlString];
    [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image;
        completed(image);
    }];
}
@end

@implementation NSString (NSStringHMAPIAdditions)
- (NSString*)HMURL{
    return [NSString stringWithFormat:@"%@%@", kHMAPIDefaultURL, self];
}
- (NSDate*)DateFromISODate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZZ";
    return [dateFormatter dateFromString:self];
}
@end

@implementation NSDate (NSDateHMAPIAdditions)
- (NSString*)ISODateRepresentation{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZZ"];
    return [dateFormat stringFromDate:self];
}
@end

@implementation HMAPIRequestManager

bool downloadFinished;

+ (HMAPIRequestManager*)manager{
    static HMAPIRequestManager *manager = nil;
    @synchronized(self) {
        if(manager == nil){
            manager = [[self alloc] init];
        }
    }
    return manager;
}
+ (HMAPIRequestManager*)managerWithURLString:(NSString *)urlString{
    static HMAPIRequestManager *manager = nil;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
    @synchronized(self) {
        if(manager == nil){
            manager = [[self alloc] initWithBaseURL:url];
        }
    }
    return manager;
}

- (id)init{
    self = [super init];
    if(self != nil){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.launchCount = @([defaults integerForKey:@"AppRunCounts"]);
    }
    return self;
}
+ (BOOL)isConnected{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
+ (BOOL)isConnectedWithURLString:(NSString*)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPRequestOperationManager *manaer = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    return manaer.reachabilityManager.reachable;
}
- (void)loadLocationMartsWithLocationCoorindate:(CLLocationCoordinate2D)locationCoordinate action:(void(^)(HMLocationMarts *marts, NSError *error))action{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *longitudeString = [NSString stringWithFormat:@"%f", locationCoordinate.longitude];
    NSString *latitudeString = [NSString stringWithFormat:@"%f", locationCoordinate.latitude];
    [manager.requestSerializer setTimeoutInterval:3.0];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager.requestSerializer setValue:[HMAPIRequestManager userToken] forHTTPHeaderField:@"X-Auth-Token"];
    HMLog(HMLogImportant, [NSString stringWithFormat:@"%@",[HMAPIRequestManager userToken]]);
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[@"/markets" HMURL] parameters:@{@"lng":longitudeString, @"lat":latitudeString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HMAPIState state = [self stateWithString:[responseObject objectForKey:@"status"]];
        switch (state) {
            case HMAPIStateSuccess:{
                HMLocationMarts *locationMarts = [[HMLocationMarts alloc] initWithArray:[responseObject objectForKey:@"data"]];
                action(locationMarts, nil);
                NSLog(@"UpdateState Success");
                break;
            }
            case HMAPIStateEmpty:{
                HMLocationMarts *locationMarts = [[HMLocationMarts alloc] init];
                action(locationMarts, nil);
                NSLog(@"UpdateState Empty");
                break;
            }
            case HMAPIStateUnknown:{
                action(nil, [NSError errorWithDomain:@"HMAPIErrorUnknown" code:999 userInfo:nil]);
                NSLog(@"UpdateState Unknown");
                break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        action(nil, error);
        NSLog(@"UpdateState failure : %@",error);
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"마트 정보를 받아오지 못했습니다"
                                                        message:@"왼쪽 상단의 지역변경버튼을 통해 위치를 다시 설정해주시거나 앱을 다시 실행시켜주세요"
                                                       delegate:nil
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"] && !([[NSUserDefaults standardUserDefaults] boolForKey:@"DidUpdateMart"])){
            [alert show];
        }
    }];
}

- (void)loadCampaignsForMart:(HMMart*)mart action:(void(^)(NSError *error))action{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager.requestSerializer setValue:[HMAPIRequestManager userToken] forHTTPHeaderField:@"X-Auth-Token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *requestURL = [NSString stringWithFormat:@"/markets/%ld/campaigns/now", mart.martId];
    [manager GET:[requestURL HMURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HMAPIState state = [self stateWithString:[responseObject objectForKey:@"status"]];
        switch (state) {
            case HMAPIStateSuccess:{
                HMLog(HMLogImportant, @"RESPONSE %@",responseObject);
                NSDictionary *data = [responseObject objectForKey:@"data"];
                [mart loadCampaignsWithRawDataDictionary:data];
                mart.APIstate = HMAPIStateSuccess;
                action(nil);
                break;
            }
            case HMAPIStateEmpty:{
                action(nil);
                HMLog(HMLogImportant, @"RESPONSE EMPTY %@",responseObject);
                mart.APIstate = HMAPIStateEmpty;
                break;
            }
            case HMAPIStateUnknown:{
                action([NSError errorWithDomain:@"HMAPIErrorUnknown" code:999 userInfo:nil]);
                mart.APIstate = HMAPIStateUnknown;
                break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        action(error);
    }];
}

- (void)martWithMartId:(NSUInteger)martId action:(void(^)(HMMart *mart))action{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[HMAPIRequestManager userToken] forHTTPHeaderField:@"X-Auth-Token"];
    __block HMMart *mart = [[HMMart alloc] init];
    
    NSString *requestURL = [NSString stringWithFormat:@"/markets/%ld/campaigns/now", martId];
    
    __block int finalCount = 0;
    void (^finishAction)() = ^{
        finalCount++;
        if(finalCount == 2){
            action(mart);
        }
    };
    
    [manager GET:[requestURL HMURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HMAPIState state = [self stateWithString:[responseObject objectForKey:@"status"]];
        if(state == HMAPIStateSuccess){
            NSDictionary *data = [responseObject objectForKey:@"data"];
            [mart loadCampaignsWithRawDataDictionary:data];
        }
        finishAction();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       finishAction();
    }];
    
    requestURL = [NSString stringWithFormat:@"/markets/%ld", martId];
    [manager GET:[requestURL HMURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HMAPIState state = [self stateWithString:[responseObject objectForKey:@"status"]];
        if(state == HMAPIStateSuccess){
            NSDictionary *data = [responseObject objectForKey:@"data"];
            [mart fillWithDictionary:data];
        }
        finishAction();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        finishAction();
    }];
}

- (void)goodsForCampaign:(HMCampaign*)campaign action:(void(^)(void))action{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[HMAPIRequestManager userToken] forHTTPHeaderField:@"X-Auth-Token"];
    NSString *requestURL = [NSString stringWithFormat:@"/campaigns/%ld/goods", campaign.campaignId];
    
    [manager GET:[requestURL HMURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HMAPIState state = [self stateWithString:[responseObject objectForKey:@"status"]];
        switch (state) {
            case HMAPIStateSuccess:{
                HMLog(HMLogImportant, @"캠페인 응답 %@",responseObject);
                NSArray *data = [responseObject objectForKey:@"data"];
                [campaign loadItemsWithPrimitiveArray:data];
                action();
                break;
            }
            case HMAPIStateEmpty:{
                action();
                HMLog(HMLogImportant, @"RESPONSE EMPTY %@",responseObject);
                break;
            }
            case HMAPIStateUnknown:{
                action();
                break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        action();
    }];
}

- (void)submitUserInformationWithBirthYear:(NSUInteger)birth gender:(HMUserGender)gender completion:(void(^)(BOOL success))completion{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[HMAPIRequestManager userToken] forHTTPHeaderField:@"X-Auth-Token"];
    NSString *requestURL = [NSString stringWithFormat:@"/users/my"];
    NSString *genderString = @"";
    if(gender == HMUserGenderFemale) genderString = @"F";
    if(gender == HMUserGenderMale) genderString = @"M";
    NSNumber *birthYearNumber = [NSNumber numberWithUnsignedInteger:birth];
    NSDictionary *params = @{@"gender":genderString, @"birth":birthYearNumber};
    
    [manager PUT:[requestURL HMURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"]){
            [defaults setBool:YES forKey:@"DidSubmitUserInformation"];
            completion(YES);
            [defaults synchronize];
        }else{
            completion(NO);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];
}

- (HMAPIState)stateWithString:(NSString*)state{
    if([state isEqualToString:@"success"]){
        return HMAPIStateSuccess;
    }else if([state isEqualToString:@"empty"]){
        return HMAPIStateEmpty;
    }else{
        return HMAPIStateUnknown;
    }
}

+ (NSString*)deviceId{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
}

+ (NSString*)userId{
    return [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"]];
}

+ (NSString*)userToken{
    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"UserToken"]];
}

+ (void)generateAndRegisterDeviceId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    [manager POST:[@"/users" HMURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:uuid forKey:@"DeviceID"];
            NSString *userToken = responseObject[@"data"][@"token"];
            [defaults setValue:userToken forKey:@"UserToken"];
            [defaults setBool:YES forKey:@"DidSubmitDeviceID"];
            [defaults synchronize];
        }else{
            // EXCEPTION HERE!!
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // EXCEPTION HERE!!
    }];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    downloadFinished = YES;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HMLog(HMLogImportant, returnString);
    ;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    NSLog(@"An error occurred: %@", error);
    //self.receivedData = nil;
    downloadFinished = YES;
}
+ (void)generateUserTokenAndRegisterDeviceId{
    NSString *requestString = [@"/users" HMURL];
    NSURL *requestURL = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
    if (err)
    {
        HMLog(HMLogImportant, @"초기 토큰 받기 error : %@",err);
        //handle error
    }
    else
    {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:uuid forKey:@"DeviceID"];
        NSString *userToken = json[@"data"][@"token"];
        HMLog(HMLogImportant, userToken);
        [defaults setValue:userToken forKey:@"UserToken"];
        [defaults setBool:YES forKey:@"DidSubmitDeviceID"];
        [defaults synchronize];
        
    }
}

+ (void)notifyEnterance{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[HMAPIRequestManager userToken] forHTTPHeaderField:@"X-Auth-Token"];
    NSString *requestURL = [NSString stringWithFormat:@"/users/my/enter"];
    [manager POST:[requestURL HMURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *notice = responseObject[@"data"][@"notice"];
        if([notice[@"block"] integerValue]){
            // LOGGING NSLog(@"%@",responseObject);
            [HMAPIRequestManager blockGlobalAppAccess:notice[@"message"]];
            return;
        }else{
            NSDate *serverUpdated = [notice[@"start"] DateFromISODate];
            /*
            float appMinVersion = [notice[@"iOSVersion"] floatValue];
            float appNowVersion = [kBuildVersion floatValue];
            if (appMinVersion > appNowVersion) {
                
            }
             */
            //NSDate *serverUpdated = [notice[@"start"] DateFromISODate];
            NSDate *lastUpdate = [defaults objectForKey:@"NoticeLastUpdate"];
            if(lastUpdate == nil){
                lastUpdate = [NSDate dateWithTimeIntervalSince1970:0];
            }
            BOOL forceDisplay = ![defaults boolForKey:@"NoticeHide"];
            BOOL displayMessage = NO;
            if([lastUpdate compare:serverUpdated] == NSOrderedAscending){
                [defaults setObject:serverUpdated forKey:@"NoticeLastUpdate"];
                [defaults setBool:NO forKey:@"NoticeHide"];
                displayMessage = YES;
            }else if(forceDisplay){
                displayMessage = YES;
            }
            if(displayMessage){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"공지사항" message:notice[@"message"] delegate:[self manager] cancelButtonTitle:@"확인" otherButtonTitles:@"다시 확인하지 않음", nil];
                    alert.tag = 4255;
                    [alert show];
                });
            }
            NSInteger appRunCounts = [defaults integerForKey:@"AppRunCounts"];
            if(appRunCounts > 0){
                appRunCounts++;
            }else{
                appRunCounts = 2;
            }
            [defaults setInteger:appRunCounts forKey:@"AppRunCounts"];
            [defaults synchronize];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 4255){
        if(buttonIndex == 1){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"NoticeHide"];
            [defaults synchronize];
        }
    }
}

+ (void)blockGlobalAppAccess:(NSString*)message{
    HMServiceUnderConstructionViewController *constructionView = [[HMServiceUnderConstructionViewController alloc] init];
    [[[UIApplication sharedApplication] delegate].window setRootViewController:constructionView];
    dispatch_async(dispatch_get_main_queue(), ^{
        constructionView.messageLabel.text = message;
    });
}

+ (BOOL)shouldRequestUserInformation{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"DidSubmitUserInformation"]){
        return NO;
    }else{
        NSInteger appRunCounts = [defaults integerForKey:@"AppRunCounts"];
        if(appRunCounts){
            if(appRunCounts >= 3){
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }
}

+ (BOOL)shouldAllowAppAccess{

    // 동기식으로 요청 처리 - 해찬
    NSString *requestString = [@"/users/my/enter" HMURL];
    NSURL *requestURL = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[HMAPIRequestManager userToken] forHTTPHeaderField:@"X-Auth-Token"];
    NSError *err = nil;
    NSHTTPURLResponse *response = nil;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (err) {
        HMLog(HMLogImportant, @"유저 입장 post error : %@",err);
        return NO;
    }else{
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (error){
            HMLog(HMLogImportant, @"유저입장 json처리 에러 : %@",error);
            return NO;
        }
        if (![json[@"status"] isEqualToString:@"success"]) {
            return NO;
        }
        if ([json[@"data"][@"notice"][@"supportVersion"][@"ios"] compare:kBuildVersion options:NSNumericSearch] == NSOrderedDescending) {
            return NO;
        }
        return YES;
    }
}

@end
