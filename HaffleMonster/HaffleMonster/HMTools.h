//
//  HMTools.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 6. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum HMLogType{
    HMLogNone = 0,
    HMLogError = 1 << 0,
    HMLogImportant = 1 << 1,
    HMLogIgnorable = 1 << 2
}HMLogType;

void HMLog(HMLogType logtype, NSString *format, ...);
