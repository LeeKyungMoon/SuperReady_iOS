//
//  Common.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 6. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#ifndef HaffleMonster_Common_h
#define HaffleMonster_Common_h

#import "HMTools.h"
#import "KinsightSession.h"
#import "HMKakaoAnalytics.h"
#import "HCUI.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define kBuildNumber [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define kBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif
