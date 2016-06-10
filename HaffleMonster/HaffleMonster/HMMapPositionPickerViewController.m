//
//  HMMapPositionPickerViewController.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 13..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMMapPositionPickerViewController.h"

@interface HMMapPositionPickerViewController ()

@end

@implementation HMMapPositionPickerViewController
@synthesize initialCoordinate;
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    doubleTitleView = [[HMDoubleNavigationTitleView alloc] init];
    if(self.navigationController){
        self.navigationItem.titleView = doubleTitleView;
        UIImage *completeImage = [UIImage imageNamed:@"MappickerNaviBtnOk"];
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [spacer setWidth:-8.0];
        UIBarButtonItem *completeItem = [[UIBarButtonItem alloc] initWithImage:completeImage style:UIBarButtonItemStylePlain target:self action:@selector((finishSelecting))];
        [completeItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItems = @[spacer,completeItem];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        doneButton = completeItem;
        UIImage *itemImage = [UIImage imageNamed:@"MappickerNaviBtnPrevious"];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector((cancelSelecting))];
        if(self.blockCancelButton == NO){
            self.navigationItem.leftBarButtonItems = @[spacer,item];
        }
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    
    self.isCurrentLocated = NO;
    mainLocationManager = [[CLLocationManager alloc] init];
    mainLocationManager.delegate = self;
    mainLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    mainLocationManager.distanceFilter = 100.0;
    
    if ([mainLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [mainLocationManager requestWhenInUseAuthorization];
    }
    
    GMSCameraPosition *camera;
    if(initialCoordinate.latitude && initialCoordinate.longitude){
        camera = [GMSCameraPosition cameraWithLatitude:initialCoordinate.latitude longitude:initialCoordinate.longitude zoom:16];
    }else{
        camera = [GMSCameraPosition cameraWithLatitude:37.5206868 longitude:127.1214941 zoom:6.191];
        [mainLocationManager startUpdatingLocation];
    }

    mapView = [GMSMapView mapWithFrame:[[UIScreen mainScreen] bounds] camera:camera];
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    
    [self.view insertSubview:mapView atIndex:0];
    
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:(222/255.0) green:(20/255.0) blue:(30/255.0) alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[HMKinsightSession shared] tagScreen:@"위치변경"];
}
- (IBAction)refreshCurrentLocation:(id)sender {
    HMLog(HMLogImportant, @"현재위치버튼클릭");
    [mainLocationManager startUpdatingLocation];
    [SVProgressHUD show];
}

- (IBAction)refreshPlaceMarker:(id)sender{
    [mainLocationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UINavigationController*)pickerNavigationController{
    return [[UINavigationController alloc] initWithRootViewController:self];
}

#pragma mark - Programmatically Triggered UI Actions

- (void)finishSelecting{
    SET_KADATA = @{
                   @"앱 실행 횟수":[KA appLaunchCount],
                   @"현위치와 설정한 위치 사이 거리":[KA distanceOfLocation:selectedCoordinate],
                   };
    SEND_KA_ @"위치 변경 완료" _EVENT;
    if (self.blockCancelButton) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsFirstLocated"];
    }
    [[NSUserDefaults standardUserDefaults] setFloat:selectedCoordinate.latitude forKey:@"LastLatitude"];
    [[NSUserDefaults standardUserDefaults] setFloat:selectedCoordinate.longitude forKey:@"LastLongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(self.delegate){
         [self.delegate positionPicker:self didFinishPickingWithLatitude:selectedCoordinate.latitude longitude:selectedCoordinate.longitude];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelSelecting{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(positionPicker:didCancelWithAnimation:)]){
            [self.delegate positionPicker:self didCancelWithAnimation:YES];
        }
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Core Location Manager Delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.isCurrentLocated = YES;
    [SVProgressHUD dismiss];
    [manager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:14];
    [mapView animateToCameraPosition:camera];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    //if ([mainLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [mainLocationManager requestWhenInUseAuthorization];
    //}
    switch (error.code) {
        case kCLErrorDenied:{
            HMLog(HMLogIgnorable, @"isLocationValid");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"현재 위치 설정이 되어있지 않습니다"
                                                                message:@"1) 아이폰 > 설정 > 위치서비스를 켜주세요. \r 2) 또는 지도를 통해 위치를 잡아주세요"
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"위치를 받아오지 못했습니다"
                                                            message:@"왼쪽 상단의 지역변경버튼을 통해 위치를 설정해주시거나 앱을 다시 실행시켜주세요"
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            if (!self.isCurrentLocated) {
                [mainLocationManager startUpdatingLocation];
                [alert show];
            }
            break;
        }
    }
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    HMLog(HMLogIgnorable, @"locationManager : didChangeAuthorizationStatus");
    [manager stopUpdatingLocation];
}

#pragma mark - Google Maps SDK Map View Delegates

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    [doneButton setEnabled:NO];
    
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    selectedCoordinate = position.target;
    [doubleTitleView setSubtitleText:@"선택 후 체크버튼을 눌러주세요"];
    [doneButton setEnabled:YES];
}

@end
