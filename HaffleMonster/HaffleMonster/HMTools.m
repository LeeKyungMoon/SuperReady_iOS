//
//  HMTools.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 6. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMTools.h"

NSString * const LogType_toString[] = {
    [HMLogNone] = @"NONE",
    [HMLogError] = @"💩ERROR",
    [HMLogImportant] = @"⭐️IMPORTANT",
    [HMLogIgnorable] = @"😶IGNORABLE"
};

void HMLog(HMLogType logtype, NSString *format, ...) {
    if(kUseHMLogging){
        if((kUseHMLoggingOption) & logtype){
            va_list argumentList;
            va_start(argumentList, format);
            NSMutableString * message = [[NSMutableString alloc] initWithFormat:format
                                                                      arguments:argumentList];
            NSLogv([NSString stringWithFormat:@"%@: %@", LogType_toString[logtype] ,message], argumentList);
            va_end(argumentList);
        }
    }
}