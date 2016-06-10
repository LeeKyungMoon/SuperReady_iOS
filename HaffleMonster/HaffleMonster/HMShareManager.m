//
//  HMShareManager.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 8..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMShareManager.h"

@implementation HMShareManager

+ (HMShareManager*)manager{
    static HMShareManager *manager = nil;
    @synchronized(self) {
        if(manager == nil){
            manager = [[self alloc] init];
        }
    }
    return manager;
}

- (id)init{
    self = [super init];
    if(self != nil){
        [self clear];
    }
    return self;
}


- (void)sharedAction:(void(^)(NSUInteger goodId, NSUInteger marketId))action{
    if(self.values[@"marketId"] != nil && self.values[@"goodsId"] != nil){
        action([self.values[@"goodsId"] integerValue], [self.values[@"marketId"] integerValue]);
    }
}

- (void)oneDayLeftAction:(void(^)(NSUInteger userCartItemId))action{
    if(self.values[@"UserCartItemID"] != nil){
        action([self.values[@"UserCartItemID"] integerValue]);
    }
}

- (void)martPushNotificationAction:(void(^)(NSUInteger martId))action{
    if(self.values[@"MartPushID"] != nil){
        action([self.values[@"MartPushID"] integerValue]);
    }
}

- (void)clear{
    self.values = [@{} mutableCopy];
}

+ (void)sendKakaoTalkShareWithGood:(SRGood*)good{
    SET_KADATA = @{
                   @"앱 실행 횟수":[KA appLaunchCount],
                   @"현위치와 마켓사이 거리":[KA distanceOfMarket:good.parentCampaign.parentMarket],
                   @"사용자 나이":[KA userBirthYear],
                   @"사용자 성별":[KA userGenderString],
                   @"가격":good.retailPrice,
                   @"캠페인 남은 시간":@((int)([good.parentCampaign.endDate timeIntervalSinceNow]) / 60 / 60)
                   };
    SEND_KA_ @"카카오톡 공유" _EVENT;
    KakaoTalkLinkAction *androidAppAction
    = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformAndroid
                                devicetype:KakaoTalkLinkActionDeviceTypePhone
                                 execparam:@{@"marketId":good.parentCampaign.parentMarket.marketId,@"goodsId":good.goodId}];
    
    KakaoTalkLinkAction *iphoneAppAction
    = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS
                                devicetype:KakaoTalkLinkActionDeviceTypePhone
                                 execparam:@{@"marketId":good.parentCampaign.parentMarket.marketId,@"goodsId":good.goodId}];
    
    NSString *kakaoMessageString = [NSString stringWithFormat:@"%@\n%@원(%@)\n\n%@", good.name, good.retailPrice, good.goodDescription, good.parentCampaign.parentMarket.name];
    
    
    KakaoTalkLinkObject *text = [KakaoTalkLinkObject createLabel:kakaoMessageString];
    KakaoTalkLinkObject *image = [KakaoTalkLinkObject createImage:[NSString stringWithFormat:@"%@@kakao",good.imageURL] width:300 height:200];
    KakaoTalkLinkObject *appLink
    = [KakaoTalkLinkObject createAppButton:@"슈퍼레디에서 확인"
                                   actions:@[androidAppAction, iphoneAppAction]];
    [KOAppCall openKakaoTalkAppLink:@[text, image, appLink]];
}     

@end
