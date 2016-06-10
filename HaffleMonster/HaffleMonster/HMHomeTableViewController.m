
//
//  HMHomeTableViewController.m
//  HaffleMonster
//
//  Created by LKM on 2015. 3. 16..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMHomeTableViewController.h"

#define STATICMAP_URL @"http://maps.googleapis.com/maps/api/staticmap?"
#define VIEW_RELOAD [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadHomeView" object:nil];
#define VIEW_UPDATE [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateHomeView" object:nil];

@implementation UIImageView (StaticImageMap)

- (void)loadStaticMapWithCoordinate:(CLLocationCoordinate2D)coordinate size:(CGSize)mapImageSize{
    [self setImage:[UIImage imageNamed:@"defaultMap"]];
    if(!CLLocationCoordinate2DIsValid(coordinate)) return;
    if(coordinate.longitude == 0 || coordinate.latitude == 0) return;
    CGFloat scale = [[UIScreen mainScreen] scale];
    if(scale >= 3) scale = 2;
    NSString *imageMapURL = [NSString stringWithFormat:@"%@center=%f,%f&zoom=15&size=%dx%d&scale=%d", STATICMAP_URL, coordinate.latitude, coordinate.longitude, (int)mapImageSize.width, (int)mapImageSize.height, (int)scale];
    [self setImageWithURLCached:imageMapURL placeholderImage:[UIImage imageNamed:@"defaultMap"]];
}

@end

@implementation HMHomeTableViewController

@synthesize locationAddress = _locationAddress;
@synthesize locationCoordinate = _locationCoordinate;

- (void)viewDidLoad {
    [super viewDidLoad];

    kakaoCallCount = 0;
    favoriteMarkets = [[SRDatabase db] favoriteMarkets];
    if(kUseCurrentLocation){
        [self startUpdatingLocation];
    }else{
        if(SRUserDefaults.isFirstLaunch){
            SRUserDefaults.lastLatitude = 37.5206868;
            SRUserDefaults.lastLongitude = 127.1214941;
        }
        self.locationCoordinate = CLLocationCoordinate2DMake(SRUserDefaults.lastLatitude, SRUserDefaults.lastLongitude);
        [self setHeaderLocationAddress:self.locationCoordinate];
        [self updateMartsFromServer];
    }
    [self decorateView];
    [self balloonButtonMake];
    [self registerNotificationHandlers];
}

-(void)setHeaderLocationAddress :(CLLocationCoordinate2D)locationCoordinate{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:locationCoordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if(error){
            _locationAddress = @"주소 조회 실패";
            VIEW_RELOAD;
            return;
        }
        GMSAddress *geoLocationAddress = [response firstResult];
        NSString *geoAdministrativeLocality, *geoSplittedDong;
        geoSplittedDong = [[[geoLocationAddress thoroughfare] componentsSeparatedByString:@", "] objectAtIndex:0];
        geoAdministrativeLocality = [NSString stringWithFormat:@"%@ %@", [geoLocationAddress locality], geoSplittedDong];
        if (!([geoLocationAddress locality].length>0)||!(geoSplittedDong.length>0)) {
            _locationAddress = @"주소 조회 실패";
        }else{
            _locationAddress = geoAdministrativeLocality;
            SRUserDefaults.lastAddress = _locationAddress;
        }
        VIEW_RELOAD;
    }];
}

- (void)decorateView{
    UIImage *titleImage = [UIImage imageNamed:@"superreadynavigationlogonocart"];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:titleImage];
    self.navigationItem.titleView = titleView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self balloonHide];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self balloonHide];
}

- (IBAction)addFavorite:(UIButton*)sender {
    HMHomeTableViewCell *cell = (HMHomeTableViewCell*)sender.superview.superview.superview;
    [[SRDatabase db] addMarketToFavoriteMarket:cell.mart];
    favoriteMarkets = [[SRDatabase db] favoriteMarkets];
    
    for (int current_cnt=0; [self.loadedMarts.marts count]>current_cnt; current_cnt++) {
        SRMarket *loadedMart = (SRMarket*)[self.loadedMarts.marts objectAtIndex:current_cnt];
        if (loadedMart.martId == cell.mart.marketId) {
            [self.processedMarts removeObject:loadedMart];
        }
    }
    [self.tableView reloadData];
    
    SET_KADATA = @{
                   @"앱 실행 횟수":[KA appLaunchCount],
                   @"현위치와 마켓사이 거리":[KA distanceOfMarket:cell.mart],
                   @"사용자 나이":[KA userBirthYear],
                   @"사용자 성별":[KA userGenderString]
                   };
    SEND_KA_ @"관심마켓 등록" _EVENT;
}

- (IBAction)deleteFavorite:(UIButton*)sender {
    UIAlertView *deleteAlertView = [UIAlertView alertViewWithTitle:@"관심마트를 삭제하시겠습니까?" message:nil];
    [deleteAlertView addButtonWithTitle:@"취소"];
    [deleteAlertView addCancelButtonWithTitle:@"확인" actionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        HMHomeTableViewCell *cell = (HMHomeTableViewCell*)sender.superview.superview.superview;
        [[SRDatabase db] deleteFavoriteItem:cell.mart];
        self.favoriteMarts = [[SRDatabase db] fetchFavoriteMart].marts;
        for (int current_cnt=0; [self.loadedMarts.marts count]>current_cnt; current_cnt++) {
            SRMarket *loadedMart = (SRMarket*)[self.loadedMarts.marts objectAtIndex:current_cnt];
            if (loadedMart.martId == cell.mart.martId) {
                [self.processedMarts addObject:loadedMart];
            }
        }
        SET_KADATA = @{
                       @"앱 실행 횟수":[KA appLaunchCount],
                       @"현위치와 마켓사이 거리":[KA distanceOfMart:cell.mart],
                       @"사용자 나이":[KA userBirthYear],
                       @"사용자 성별":[KA userGenderString]
                       };
        SEND_KA_ @"관심마켓 삭제" _EVENT;
        [self.tableView reloadData];
    }];
    [deleteAlertView show];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[HMKinsightSession shared] tagScreen:@"전단목록-메인"];
    
    [self requestUserInformation];
    [kMainNavigation updateCartButton];
    
    [self readyForShareActions];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 8, 0)];
}

- (void)startUpdatingLocation{
    mainLocationManager = [[CLLocationManager alloc] init];
    mainLocationManager.delegate=self;
    mainLocationManager.distanceFilter = 100.0;
    mainLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([mainLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [mainLocationManager requestWhenInUseAuthorization];
    }
    [SVProgressHUD show];
    [mainLocationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#if kUseInHouseMenu == true

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < -250.0f){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"어플리케이션 정보"
                              message:[NSString stringWithFormat:
                                       @"%@\n버전 %@(%@%@)\n\n%@\n\nKakao Analytics: %@\nCrashlytics: %@\n\nAPNS Device Token:\n%@\n\nAPI UserToken:%@\n%@ %@",
                                       kHMBuildName,
                                       kBuildVersion,
                                       kHMBuildVersionPrefix,
                                       kBuildNumber,
                                       kHMAPIDefaultURL,
                                       kUseKakaoAnalytics ? @"YES" : @"NO",
                                       kUseCrashlytics ? @"YES" : @"NO",
                                       [[NSUserDefaults standardUserDefaults] stringForKey:@"APNSDeviceToken"],
                                       [HMAPIRequestManager userToken],
                                       [KA userBirthYear],
                                       [KA userGenderString]
                                       ]
                              delegate:nil
                              cancelButtonTitle:@"닫기"
                              otherButtonTitles:nil];
        HMLog(HMLogImportant, @"사용자 토큰 - %@", [HMAPIRequestManager userToken]);
        [alert show];
        
    }
}

#endif

#pragma mark - Data Loaders

- (void)updateMartsFromServer:(NSNotification*)notification{
    HMLog(HMLogImportant,@"updateMartsFromServer : %f %f",self.locationCoordinate.latitude,self.locationCoordinate.longitude);
        [[HMAPIRequestManager manager] loadLocationMartsWithLocationCoorindate:self.locationCoordinate action:^(HMLocationMarts *marts, NSError *error) {
            if (error) {
                NSLog(@"update ERROR : %@",error.description);
            }else{
                self.loadedMarts = [[HMLocationMarts alloc] init];
                self.loadedMarts = marts;
                self.processedMarts = [self NowLocationMarts];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DidUpdateMart"];
                VIEW_RELOAD;
            }
        }];
}
- (void)updateMartsFromServer{
    HMLog(HMLogImportant,@"updateMartsFromServer : %f %f",self.locationCoordinate.latitude,self.locationCoordinate.longitude);
    [[HMAPIRequestManager manager] loadLocationMartsWithLocationCoorindate:self.locationCoordinate action:^(HMLocationMarts *marts, NSError *error) {
        if (error) {
            NSLog(@"update ERROR : %@",error.description);
        }else{
            self.loadedMarts = [[HMLocationMarts alloc] init];
            self.loadedMarts = marts;
            self.processedMarts = [self NowLocationMarts];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DidUpdateMart"];
            VIEW_RELOAD;
        }
    }];
}
- (void)reloadMartsFromLocal:(NSNotification*)notification{
    [self.tableView reloadData];
}

#pragma mark - CLLocationManager Delegates

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    HMLog(HMLogImportant, @"didUpdateLocations");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DidUpdateLocation"];
    CLLocation *newLocation = locations.lastObject;
    self.locationCoordinate = newLocation.coordinate;
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    HMLog(HMLogImportant, @"didFailWithError %d",error.code);
    [manager stopUpdatingLocation];
    [SVProgressHUD dismiss];
    switch (error.code) {
        case kCLErrorLocationUnknown:{
            if(![self isLocationValid]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"위치를 받아오지 못했습니다"
                                                                message:@"왼쪽 상단의 지역변경버튼을 통해 위치를 설정해주시거나 앱을 다시 실행시켜주세요"
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DidUpdateLocation"]) {
                    [alert show];
                }
            }
            break;
        }
        case kCLErrorDenied:{
            if(![self isLocationValid]){
                HMLog(HMLogIgnorable, @"isLocationValid");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"현재 위치를 찾지 못했습니다"
                                                                message:@"1) 아이폰 > 설정 > 위치서비스를 켜주세요. \r 2) 또는 지도를 통해 위치를 잡아주세요"
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                [alert show];
                [self showChangeLocation:YES];
            }else{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DidUpdateLocation"];
                VIEW_UPDATE;
            }
            break;
        }
        default:{
            if(![self isLocationValid]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"위치를 받아오지 못했습니다"
                                                                message:@"왼쪽 상단의 지역변경버튼을 통해 위치를 설정해주시거나 앱을 다시 실행시켜주세요"
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            break;
        }
    }
}



- (void)sendPageViewKA:(SRMarket*)mart{
    SRDatabase *db = [SRDatabase db];
    [KA setIsMartFavorite:[db isMartInFavoriteMart:mart.martId]];
    BOOL isMartNear = NO;
    for(SRMarket *martItem in self.loadedMarts.marts){
        if(martItem.martId == mart.martId){
            isMartNear = YES;
            break;
        }
    }
    [KA setIsMartNear:isMartNear];
    SET_KADATA = @{
                   @"사용자 나이":[KA userBirthYear],
                   @"사용자 성별":[KA userGenderString],
                   @"현위치와 마켓사이 거리":[KA distanceOfMart:mart],
                   @"마켓 조회패턴":[KA patternStringForNear:[KA isMartNear] favorite:[KA isMartFavorite]]
                   };
    SEND_KA_ @"전단상품목록 조회" _EVENT;
}

#pragma mark - Table view data source

- (BOOL)isMartMemberOf:(NSMutableArray*)array mart:(SRMarket*)mart{
    for(SRMarket *indexedMart in array){
        if(mart.martId == indexedMart.martId){
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray*)NowLocationMarts{
    self.processedMarts = [[NSMutableArray alloc] init];
    for(SRMarket *martInLoaded in self.loadedMarts.marts){
        if(![self isMartMemberOf:self.favoriteMarts mart:martInLoaded]){
            [self.processedMarts addObject:martInLoaded];
        }
    }
    return self.processedMarts;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section){
        case 0:{
            return 2;
            break;
        }
        case 2:{
            NSUInteger rowCount = [self.loadedMarts.marts count];
            if (rowCount == 0) {
                return  2;
            }else{
                if ([self.favoriteMarts count] == rowCount) {
                    return 0;
                }else{
                    return [[self NowLocationMarts] count]+1;
                }
            }
            break;
        }
        case 1:{
            if([self.favoriteMarts count] == 0){
                return 0;
            }else{
                return [self.favoriteMarts count]+1;
            }
            break;
        }
        default:{
            return 0;
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            return 24;
        }else{
            return 204;
        }
    }else{
        if (indexPath.row == 0) {
            return 28;
        }else{
            return 104;
        }
    }
}

- (CGSize)tableViewMapImageSize{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            HMHomeGPSHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOCATION_HEADER" forIndexPath:indexPath];
            cell.locationLabel.text = self.locationAddress;
            return cell;
        }else{
            HMHomeGPSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeGPS" forIndexPath:indexPath];
            [cell.image_gps loadStaticMapWithCoordinate:self.locationCoordinate size:[self tableViewMapImageSize]];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DidUpdateLocation"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"DidUpdateMart"]) {
                [SVProgressHUD dismiss];
            }
            return cell;
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            HMHomeHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTitleCell" forIndexPath:indexPath];
            cell.headerLabel.text = @"나의 관심마트";
            return cell;
        }else{
            HMHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteMart" forIndexPath:indexPath];
            SRMarket *mart = [self.favoriteMarts objectAtIndex:indexPath.row- 1];
            cell.businessHour.text=mart.businessHours;
            if (mart.panorama.length == 0) {
                [cell.image_mart setImage:[UIImage imageNamed:@"DefaultMartImage"]];
                cell.image_mart.contentMode = UIViewContentModeScaleAspectFill;
            }else{
                [cell.image_mart  setImageWithURLCached:mart.panorama placeholderImage:nil];
                cell.image_mart.contentMode = UIViewContentModeScaleAspectFill;
            }            cell.name_mart.text=mart.name;
            cell.marketdeal_mart.text=mart.description;
            cell.mart = mart;
            return cell;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            HMHomeHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTitleCell" forIndexPath:indexPath];
            cell.headerLabel.text = @"이 지역 슈퍼레디 마트";
            return cell;
        }else{
            if([self.loadedMarts count] == 0){
                HMHomeNoMartTableViewCell *noMartCell = [tableView dequeueReusableCellWithIdentifier:@"NOMARTCELL" forIndexPath:indexPath];
                return noMartCell;
            }
            NSUInteger rowNumber = indexPath.row - 1;
            HMHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMart" forIndexPath:indexPath];
            SRMarket *mart = [[self NowLocationMarts] objectAtIndex:rowNumber];
            cell.mart = mart;
            cell.businessHour.text =mart.businessHours;
            if (mart.panorama.length == 0) {
                [cell.image_mart setImage:[UIImage imageNamed:@"DefaultMartImage"]];
                cell.image_mart.contentMode = UIViewContentModeScaleAspectFill;
            }else{
                [cell.image_mart  setImageWithURLCached:mart.panorama placeholderImage:nil];
                cell.image_mart.contentMode = UIViewContentModeScaleAspectFill;
            }
            cell.name_mart.text=mart.name;
            cell.marketdeal_mart.text=mart.description;
            [cell.marketdeal_mart sizeToFit];
            if([cell.event_mart.text isEqualToString:@"자체 행사"]){
                cell.event_mart.alpha=0;
            }
            cell.clipsToBounds=YES;
            
            return cell;
        }
        
    }else{
        return nil;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    
    if([identifier isEqualToString:@"GoodsTableView"]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSUInteger rowNumber = indexPath.row - 1;
        
        HMGoodsTableViewController *goods = segue.destinationViewController;
        
        if([sender isKindOfClass:[SRMarket class]]){
            goods.selectedMart = sender;
        }else{
            goods.selectedMart = [self.processedMarts objectAtIndex:rowNumber];
        }
        goods.martNameState = [goods.selectedMart stateWithMartName];
        
        goods.selfLatitude = self.locationCoordinate.latitude;
        goods.selfLongitude = self.locationCoordinate.longitude;
        
        [self sendPageViewKA:goods.selectedMart];
    }else if ([identifier isEqual:@"GoodsTableViewForFavorite"]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSUInteger rowNumber = indexPath.row-1;
        
        HMGoodsTableViewController *goods=segue.destinationViewController;
        
        goods.selectedMart = [self.favoriteMarts objectAtIndex:rowNumber];
        goods.martNameState = [goods.selectedMart stateWithMartName];
        goods.selfLatitude = self.locationCoordinate.latitude;
        goods.selfLongitude = self.locationCoordinate.longitude;
        [self sendPageViewKA:goods.selectedMart];
    }
}

#pragma mark - Balloon Menu Delegates

- (void)balloonButtonMake{
    UIBarButtonItem *dropdownItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HomeNavBarMenuButton"] style:UIBarButtonItemStylePlain target:self action:@selector(balloonShow:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spacer setWidth:-8.0];
    self.navigationItem.leftBarButtonItems = @[spacer, dropdownItem];
}

- (void)balloonShow:(id)sender{
    if(!menuBalloon){
        CGFloat top = [[UIApplication sharedApplication] statusBarFrame].size.height + (44 / 2) + (22 / 2) + 3;
        CGFloat left = 12 + (24 / 2);
        menuBalloon = [[HMDropdownBalloon alloc] initWithPoint:CGPointMake(left, top)];
        menuBalloon.delegate = self;
        menuBalloon.hidden = YES;
        [[[UIApplication sharedApplication] keyWindow] addSubview:menuBalloon];
        [menuBalloon prepareForAnimation];
        menuBalloon.hidden = NO;
        [menuBalloon showWithAnimation];
    }else{
        [menuBalloon dismissWithAnimation];
    }
}

- (void)balloonHide{
    if(menuBalloon){
        [menuBalloon dismissWithAnimation];
    }
}

- (void)balloon:(HMDropdownBalloon *)balloon didDismiss:(BOOL)animated{
    [menuBalloon removeFromSuperview];
    menuBalloon = nil;
}

- (void)balloon:(HMDropdownBalloon *)balloon didTouchDropdownButtonWithAction:(HMDropdownBalloonAction)actionType{
    switch (actionType) {
        case HMDropdownBalloonActionChangeLocation:
            [self showChangeLocation:NO];
            break;
        case HMDropdownBalloonActionSupport:
            [self showSupport];
            break;
        case HMDropdownBalloonActionMartRequest:
            [self showMartRequest];
            break;
    }
}

#pragma mark - Location Controller

- (void)setLocationAddress:(NSString *)locationAddress{
    _locationAddress = locationAddress;
    VIEW_RELOAD;
}

- (void)setLocationAddressWithCoordinate:(CLLocationCoordinate2D)locationCoordinate update:(BOOL)update{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DidUpdateLocation"]) {
        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:locationCoordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if(error){
                _locationAddress = @"주소 조회 실패";
                VIEW_RELOAD;
                return;
            }
            GMSAddress *geoLocationAddress = [response firstResult];
            NSString *geoAdministrativeLocality, *geoSplittedDong;
            geoSplittedDong = [[[geoLocationAddress thoroughfare] componentsSeparatedByString:@", "] objectAtIndex:0];
            geoAdministrativeLocality = [NSString stringWithFormat:@"%@ %@", [geoLocationAddress locality], geoSplittedDong];
            if (!([geoLocationAddress locality].length>0)||!(geoSplittedDong.length>0)) {
                _locationAddress = @"주소 조회 실패";
            }else{
                _locationAddress = geoAdministrativeLocality;
                [[NSUserDefaults standardUserDefaults] setValue:_locationAddress forKey:@"LastAddress"];
            }
            VIEW_RELOAD;
        }];
    }

    if(update){
        VIEW_UPDATE;
    }
}

- (NSString*)locationAddress{
    if(_locationAddress == nil){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _locationAddress = [userDefaults stringForKey:@"LastAddress"];
        if(_locationAddress == nil){
            [self setLocationAddressWithCoordinate:self.locationCoordinate update:[[NSUserDefaults standardUserDefaults] boolForKey:@"DidUpdateLocation"]];
            return @"위치 조회 중";
        }
    }
    return _locationAddress;
}

- (void)setLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate{
    _locationCoordinate = locationCoordinate;
    [[NSUserDefaults standardUserDefaults] setFloat:locationCoordinate.latitude forKey:@"LastLatitude"];
    [[NSUserDefaults standardUserDefaults] setFloat:locationCoordinate.longitude forKey:@"LastLongitude"];
    [self setLocationAddressWithCoordinate:locationCoordinate update:YES];
}

- (CLLocationCoordinate2D)locationCoordinate{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        _locationCoordinate = CLLocationCoordinate2DMake([[NSUserDefaults standardUserDefaults] floatForKey:@"LastLatitude"], [[NSUserDefaults standardUserDefaults] floatForKey:@"LastLongitude"]);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsFirstLocated"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DidUpdateLocation"];
        }
    }
    return _locationCoordinate;
}

- (BOOL)isLocationValid{
    if(CLLocationCoordinate2DIsValid(self.locationCoordinate)){
        if(self.locationCoordinate.longitude != 0 && self.locationCoordinate.latitude != 0){
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

#pragma mark - Share Controls

- (void)readyForShareActions{
    [self readyForKakaoAction:nil];
    [self readyForMartPushNotification];
    [self readyForOneDayLeftNotification];
}

- (void)readyForKakaoAction:(NSNotification*)notification{
    kakaoCallCount++;
    if(kakaoCallCount == 1){
        [[HMShareManager manager] sharedAction:^(NSUInteger itemId, NSUInteger martId) {
            [SVProgressHUD show];
            [[HMAPIRequestManager manager] martWithMartId:martId action:^(SRMarket *mart) {
                [SVProgressHUD dismiss];
                [self performSegueWithIdentifier:@"GoodsTableView" sender:mart];
            }];
        }];
        if(notification){
            kakaoCallCount = 0;
        }
    }
    if(kakaoCallCount == 2){
        kakaoCallCount = 0;
    }
}

- (void)readyForOneDayLeftNotification{
    [[HMShareManager manager] oneDayLeftAction:^(NSUInteger userCartItemId) {
        [(HMMainNavigationController*)(self.navigationController) touchedUserCartButton];
    }];
}

- (void)readyForMartPushNotification{
    [[HMShareManager manager] martPushNotificationAction:^(NSUInteger martId) {
        [SVProgressHUD show];
        [[HMAPIRequestManager manager] martWithMartId:martId action:^(SRMarket *mart) {
            [SVProgressHUD dismiss];
            [self performSegueWithIdentifier:@"GoodsTableView" sender:mart];
            [[HMShareManager manager] clear];
        }];
    }];
}

#pragma mark - Position Picker Delegate

- (void)positionPicker:(HMMapPositionPickerViewController *)picker didFinishPickingWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DidUpdateLocation"];
    self.locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
}

#pragma mark - Others

- (void)requestUserInformation{
    if([HMAPIRequestManager shouldRequestUserInformation]){
        HMCreateUserStepOneViewController *so = [[HMCreateUserStepOneViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:so];
        nc.navigationBar.topItem.title = @"더욱 정확한 정보를 제공해 드립니다";
        nc.navigationBar.translucent = NO;
        nc.navigationBar.barStyle = UIBarStyleBlack;
        nc.navigationBar.barTintColor = [UIColor colorWithRed:(222/255.0) green:(20/255.0) blue:(30/255.0) alpha:1.0];
        [self presentViewController:nc animated:YES completion:nil];
    }
}
- (void)showMartRequest{
    [SVProgressHUD dismiss];
    HMMartRequestViewController *requestView = [[HMMartRequestViewController alloc] init];
    [requestView presentOnViewController:self];
}
- (void)showSupport{
    [SVProgressHUD dismiss];
    HMSupportWebViewController *supportView = [[HMSupportWebViewController alloc] init];
    [supportView presentOnViewController:self];
}

- (void)showChangeLocation:(BOOL)hideCancelButton{
    [SVProgressHUD dismiss];
    HMMapPositionPickerViewController *pp = [[HMMapPositionPickerViewController alloc] init];
    pp.delegate = self;
    pp.initialCoordinate = self.locationCoordinate;
    pp.blockCancelButton = hideCancelButton;
    [self presentViewController:[pp pickerNavigationController] animated:YES completion:nil];
}

#pragma mark - Notification Center Controls

- (void)registerNotificationHandlers{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(readyForKakaoAction:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [center addObserver:self selector:@selector(updateMartsFromServer:) name:@"UpdateHomeView" object:nil];
    [center addObserver:self selector:@selector(reloadMartsFromLocal:) name:@"ReloadHomeView" object:nil];
}

@end