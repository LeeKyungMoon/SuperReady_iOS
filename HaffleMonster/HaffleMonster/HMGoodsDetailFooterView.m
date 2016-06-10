//
//  HMGoodsDetailFooterView.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 20..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMGoodsDetailFooterView.h"

@implementation HMGoodsDetailFooterView
@synthesize item = _item;

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HMGoodsDetailFooterView" owner:nil options:nil] firstObject];
    return self;
}

- (id)initWithItem:(SRGood*)initialItem{
    self = [self init];
    if(self != nil){
        _item = initialItem;
    }
    return self;
}

- (void)setItem:(SRGood *)item{
    _item = item;
}
- (NSString *)updateLabel:(id)sender :(NSDate*)endDate :(SRCampaignType)campaignType{
    NSDate *nowDate = [NSDate date];
    if ([nowDate compare:endDate] == NSOrderedDescending) {
        return [NSString stringWithFormat:@"행사가 만료되었습니다"];
    }else{
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *difference = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:nowDate toDate:endDate options:0];
        HMTimeLeft timeLeft;
        timeLeft.days = (int)difference.day;
        timeLeft.hours = (int)difference.hour;
        timeLeft.minutes = (int)difference.minute;
        timeLeft.seconds = (int)difference.second;
        // LOGGING HMLog(HMLogIgnorable, @"상세뷰 day hour minute second : %d %d %d %d",timeLeft.days,timeLeft.hours,timeLeft.minutes,timeLeft.seconds);
        if (timeLeft.days>0) {
            timeLeft.timeLeftType = HMTimeLeftWithDays;
        }else if(timeLeft.hours>0){
            timeLeft.timeLeftType = HMTimeLeftWithHours;
        }else if(timeLeft.minutes>0){
            timeLeft.timeLeftType = HMTimeLeftWithMinutes;
        }else if(timeLeft.seconds>0){
            timeLeft.timeLeftType = HMTimeLeftWithSeconds;
        }
        NSString *timeLeftString;
        switch (timeLeft.timeLeftType) {
            case HMTimeLeftWithDays:
                timeLeftString = [NSString stringWithFormat:@"%d일 %d시간 %d분 %d초 남음",timeLeft.days,timeLeft.hours,timeLeft.minutes,timeLeft.seconds];
                break;
            case HMTimeLeftWithHours:
                timeLeftString = [NSString stringWithFormat:@"%d시간 %d분 %d초 남음",timeLeft.hours,timeLeft.minutes,timeLeft.seconds];
                break;
            case HMTimeLeftWithMinutes:
                timeLeftString =  [NSString stringWithFormat:@"%d분 %d초 남음",timeLeft.minutes,timeLeft.seconds];
                break;
            case HMTimeLeftWithSeconds:
                timeLeftString = [NSString stringWithFormat:@"%d초 남음",timeLeft.seconds];
                break;
        }
        if (campaignType == SRCampaignTypeTimeSale) {
            timeLeftString = [NSString stringWithFormat:@"특가 %@",timeLeftString];
        }
        return timeLeftString;
    }
}
- (void)reloadViewData{
    [self reloadViewData];
}

@end
