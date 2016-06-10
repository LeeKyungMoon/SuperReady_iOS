//
//  HMYakdoViewController.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 25..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMYakdoViewController.h"

@interface HMYakdoViewController ()

@end

@implementation HMYakdoViewController
@synthesize mart;
-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.mart){
        [self.navigationItem setTitle:@"약도"];
        HMLog(HMLogIgnorable, @"마트 위경도 %f %f",self.mart.coordinate.latitude,self.mart.coordinate.longitude);
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(self.mart.coordinate.latitude, self.mart.coordinate.longitude) zoom:14];
        
        mainMapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        [mainMapView setMyLocationEnabled:YES];
        
        GMSMarker *selfMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(self.selfLatitude, self.selfLongitude)];
        UIImage *selfMarkerImage = [UIImage imageNamed:@"mappicker_image_mylocation"];
        selfMarkerImage = [self imageWithImage:selfMarkerImage scaledToSize:CGSizeMake(36, 36)];
        [selfMarker setIcon:selfMarkerImage];
        [selfMarker setMap:mainMapView];
        mainMapView.myLocationEnabled = NO;

        GMSMarker *marker = [GMSMarker markerWithPosition:[self.mart coordinate]];
        UIImage *markerImage = [UIImage imageNamed:@"martLocation"];
        
        markerImage = [self imageWithImage:markerImage scaledToSize:CGSizeMake(36, 36)];

        [marker setIcon:markerImage];
        [marker setTitle:[self.mart name]];
        [marker setSnippet:[self.mart phone]];
        [marker setMap:mainMapView];

        self.view = mainMapView;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[HMKinsightSession shared] tagScreen:@"슈퍼마켓약도"];
}

- (id)initWithMart:(SRMarket *)_mart{
    self = [super init];
    if(self != nil){
        self.mart = _mart;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
