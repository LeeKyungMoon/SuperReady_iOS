//
//  HMHomeTableViewController.h
//  HaffleMonster
//
//  Created by LKM on 2015. 3. 16..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

// iOS Libraries
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// CocoaPods Libraries
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <UIAlertView+BlockExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>

// External Libraries
#import <GoogleMaps/GoogleMaps.h>

// Gloabal Imports
#import "SRLoads.h"

// Other Classes
#import "AppDelegate.h"
#import "HMDropdownBalloon.h"
#import "HMMartRequestViewController.h"
#import "HMTutorialMainViewController.h"
#import "HMUserCartBarButtonItem.h"
#import "HMFavoriteTableViewCell.h"
#import "HMCreateUserStepOneViewController.h"
#import "HMSupportWebViewController.h"
#import "HMMapPositionPickerViewController.h"

// Subviews
#import "HMHomeGPSHeaderTableViewCell.h"
#import "HMHomeHeaderTableViewCell.h"
#import "HMHomeNoMartTableViewCell.h"
#import "HMHomeTableViewCell.h"
#import "HMHomeGPSTableViewCell.h"

@interface HMHomeTableViewController : UITableViewController <CLLocationManagerDelegate, HMMapPositionPickerDelegate, HMDropdownBallonDelegate> {
    int kakaoCallCount;
    HMDropdownBalloon *menuBalloon;
    CLLocationManager *mainLocationManager;
    CLLocationCoordinate2D locationCoordinate;
    NSArray *favoriteMarkets;
    NSArray *loadedMarkets
}

@property (nonatomic, strong) UIImage *mapImage;
@property (nonatomic, strong) NSString *locationAddress;
@property (nonatomic) CLLocationCoordinate2D locationCoordinate;

@end
