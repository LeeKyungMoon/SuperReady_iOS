//
//  AppDelegate.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 13..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SRLoads.h"
#import "HMShareManager.h"
#import "HMCreateUserStepOneViewController.h"
#import "HMGoodsViewController.h"

#ifdef kUseCrashlytics

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL isFirst;
}

@property (nonatomic, assign) BOOL isFirst;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HMCreateUserStepOneViewController *userInfoViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end

