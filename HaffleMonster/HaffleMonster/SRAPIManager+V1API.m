//
//  SRAPIManager+V1API.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 11..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRAPIManager+V1API.h"

@implementation SRAPIManager (SRAPIV1)

#pragma mark - API Request Methods

- (void)marketsAtGeoLocation:(CLLocationCoordinate2D)coordinate action:(void(^)(NSArray *markets))action{
    NSString *requestString = [NSString stringWithFormat:@"/markets?lat=%f&lng=%f", coordinate.latitude, coordinate.longitude];
    [AFManager GET:[requestString SRURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        switch([SRAPIManager statusWithString:responseObject[@"status"]]){
            case SRAPIStatusSuccess:{
                NSArray *marketsJSONList = responseObject[@"data"];
                NSMutableArray *results = [@[] mutableCopy];
                for(NSDictionary *marketJSON in marketsJSONList){
                    SRMarket *market = [SRMarket map:marketJSON];
                    [results addObject:market];
                }
                action(results);
                break;
            }
            default:{
                action(nil);
                break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        action(nil);
    }];
}

- (void)campaignsForMarket:(SRMarket*)market action:(void(^)(NSArray *campaigns))action{
    NSString *requestString = [NSString stringWithFormat:@"/markets/%@/campaigns/now", market.marketId];
    [AFManager GET:[requestString SRURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        switch([SRAPIManager statusWithString:responseObject[@"status"]]){
            case SRAPIStatusSuccess:{
                NSArray *campaignsJSONList = responseObject[@"data"];
                NSMutableArray *results = [@[] mutableCopy];
                for(NSDictionary *campaignJSON in campaignsJSONList){
                    SRCampaign *campaign = [SRCampaign map:campaignJSON];
                    campaign.parentMarket = market;
                    [results addObject:campaign];
                }
                action(results);
                break;
            }
            default:{
                action(nil);
                break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        action(nil);
    }];
}

- (void)goodsForCampaign:(SRCampaign*)campaign action:(void(^)(NSArray *goods))action{
    NSString *requestString = [NSString stringWithFormat:@"/campaigns/%@/goods", campaign.campaignId];
    [AFManager GET:[requestString SRURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        switch([SRAPIManager statusWithString:responseObject[@"status"]]){
            case SRAPIStatusSuccess:{
                NSArray *goodsJSONList = responseObject[@"data"];
                NSMutableArray *results = [@[] mutableCopy];
                for(NSDictionary *goodJSON in goodsJSONList){
                    SRGood *good = [SRGood map:goodJSON];
                    good.parentCampaign = campaign;
                    [results addObject:good];
                }
                action(results);
                break;
            }
            default:{
                action(nil);
                break;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        action(nil);
    }];
}

- (void)marketWithMarketId:(NSUInteger)marketId action:(void(^)(SRMarket *market))action{
    NSString *requestURL = [NSString stringWithFormat:@"/markets/%ld", marketId];
    [AFManager GET:[requestURL SRURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        switch([SRAPIManager statusWithString:responseObject[@"status"]]){
        case SRAPIStatusSuccess:{
            SRMarket *market = [SRMarket map:responseObject[@"data"]];
            action(market);
            break;
        }
        default:{
            action(nil);
            break;
        }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        action(nil);
    }];
}

- (void)campaignWithCampaignId:(NSUInteger)campaignId action:(void(^)(SRCampaign *campaign))action{
    NSString *requestURL = [NSString stringWithFormat:@"/campaigns/%ld", campaignId];
    [AFManager GET:[requestURL SRURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        switch([SRAPIManager statusWithString:responseObject[@"status"]]){
            case SRAPIStatusSuccess:{
                SRCampaign *campaign = [SRCampaign map:responseObject[@"data"]];
                action(campaign);
                break;
            }
            default:{
                action(nil);
                break;
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        action(nil);
    }];
}

- (void)goodWithGoodId:(NSUInteger)goodId action:(void(^)(SRGood *good))action{
    NSString *requestURL = [NSString stringWithFormat:@"/goods/%ld", goodId];
    [AFManager GET:[requestURL SRURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        switch([SRAPIManager statusWithString:responseObject[@"status"]]){
            case SRAPIStatusSuccess:{
                SRGood *good = [SRGood map:responseObject[@"data"]];
                action(good);
                break;
            }
            default:{
                action(nil);
                break;
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        action(nil);
    }];
}

- (void)submitUserInformationWithBirthYear:(NSUInteger)birthYear gender:(HMUserGender)gender completion:(void(^)(BOOL success))completion{
    NSString *genderString = @"";
    if(gender == HMUserGenderFemale) genderString = @"F";
    if(gender == HMUserGenderMale) genderString = @"M";
    NSNumber *birthYearNumber = [NSNumber numberWithUnsignedInteger:birthYear];
    NSDictionary *params = @{@"gender":genderString, @"birth":birthYearNumber};
    
    [AFManager PUT:[@"/users/my" SRURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"status"] isEqualToString:@"success"]){
            SRUserDefaults.didSubmitUserInformation = YES;
            SRUserDefaults.userGender = gender;
            SRUserDefaults.userBirthYear = birthYear;
            completion(YES);
        }else{
            completion(NO);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];
}

- (void)enterApp{
    NSString *requestString = [@"/users/my/enter" SRURL];
    NSDictionary *json = [self synchronousRequest:SRRequestMethodPOST url:requestString header:@{@"X-Auth-Token":SRUserDefaults.userToken}];
    if(!json){
        [self blockGlobalAppAccess:@"서버와 통신할 수 없습니다. 인터넷 접속상태를 확인하세요."];
        return;
    }
    if([SRAPIManager statusWithString:json[@"status"]] != SRAPIStatusSuccess){
        [self blockGlobalAppAccess:@"서버와 통신할 수 없습니다. 잠시후 다시 시도해주세요."];
        return;
    }
    NSDictionary *notice = json[@"data"][@"notice"];
    if ([notice[@"supportVersion"][@"ios"] compare:kBuildVersion options:NSNumericSearch] == NSOrderedDescending) {
        [self blockGlobalAppAccess:@"앱 버전이 너무 낮습니다. 앱스토어에서 업데이트 해주세요."];
        return;
    }
    NSDate *serverUpdated = [notice[@"start"] DateFromISODate];
    NSDate *lastUpdate = SRUserDefaults.noticeLastUpdate;
    if(lastUpdate == nil){
        lastUpdate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    BOOL forceDisplay = SRUserDefaults.noticeHide;
    BOOL displayMessage = NO;
    if([lastUpdate compare:serverUpdated] == NSOrderedAscending){
        SRUserDefaults.noticeLastUpdate = serverUpdated;
        SRUserDefaults.noticeHide = NO;
        displayMessage = YES;
    }else if(forceDisplay){
        displayMessage = YES;
    }
    if(displayMessage){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"공지사항" message:notice[@"message"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"다시 확인하지 않음", nil];
            alert.tag = 4255;
            [alert show];
        });
    }
    SRUserDefaults.appLaunches++;
}

- (void)registerUser{
    NSString *requestString = [@"/users" SRURL];
    NSDictionary *json = [self synchronousRequest:SRRequestMethodPOST url:requestString header:nil];
    if(json != nil){
        NSString *userToken = json[@"data"][@"token"];
        SRUserDefaults.userToken = userToken;
        [self prepareForAPIRequest];
    }else{
        HMLog(HMLogImportant, @"사용자 등록 실패!");
    }
}

- (void)blockGlobalAppAccess:(NSString*)message{
    HMServiceUnderConstructionViewController *constructionView = [[HMServiceUnderConstructionViewController alloc] init];
    [[[UIApplication sharedApplication] delegate].window setRootViewController:constructionView];
    dispatch_async(dispatch_get_main_queue(), ^{
        constructionView.messageLabel.text = message;
    });
}

#pragma mark - UI Delegates

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 4255){
        if(buttonIndex == 1){
            SRUserDefaults.noticeHide = YES;
        }
    }
}

@end
