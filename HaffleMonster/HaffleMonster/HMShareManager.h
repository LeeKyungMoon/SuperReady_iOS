//
//  HMShareManager.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 8..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "SRLoads.h"

@interface HMShareManager : NSObject {
    NSMutableDictionary *taskBox;
}
@property (nonatomic, strong) NSMutableDictionary *values;
+ (HMShareManager*)manager;
- (void)clear;
- (void)sharedAction:(void(^)(NSUInteger itemId, NSUInteger martId))action;
- (void)oneDayLeftAction:(void(^)(NSUInteger userCartItemId))action;
- (void)martPushNotificationAction:(void(^)(NSUInteger martId))action;
+ (void)sendKakaoTalkShareWithGood:(SRGood*)good;

@end
