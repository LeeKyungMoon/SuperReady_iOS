//
//  HMHomeViewController.m
//  HaffleMonster
//
//  Created by LKM on 2015. 6. 8..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMHomeViewController.h"

@interface HMHomeViewController ()

@end

@implementation HMHomeViewController

- (void)setHomeCondition{
    // 구글맵뷰
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:36.400 longitude:127.595 zoom:6.191];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 204) camera:camera];
    mapView.delegate = self;
    
    //테이블뷰
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setHomeCondition];
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
