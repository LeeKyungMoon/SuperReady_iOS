//
//  SRCampaign.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRCampaign.h"

@implementation SRCampaign

@synthesize timeLeft = _timeLeft;
@synthesize items;
@synthesize type;
@synthesize timeLeftDescriptiveMessage = _timeLeftDescriptiveMessage;
@synthesize timeLeftMessage = _timeLeftMessage;

#pragma mark - SuperReady Data Model

SR_JSON

SR_Map "id"
    _To SRCampaign
    _As this.campaignId
    _Raw

SR_Map "name"
    _To SRCampaign
    _As this.name
    _Raw

SR_Map "description"
    _To SRCampaign
    _As this.campaignDescription
    _Raw

SR_Map "startDate"
    _To SRCampaign
    _As this.startDate
    _Date

SR_Map "endDate"
    _To SRCampaign
    _As this.endDate
    _Date
    
SR_Map "type"
    _To SRCampaign
    _As this.typeNativeValue
    _Raw

SR_Map "created"
    _To SRCampaign
    _As this.dataCreatedDate
    _Date

SR_End

#pragma mark - Data Model Methods

- (SRCampaignType)type{
    NSString *typeString = self.typeNativeValue;
    if([typeString isEqualToString:@"big"]){
        return SRCampaignTypeBig;
    }else if([typeString isEqualToString:@"small"]){
        return SRCampaignTypeSmall;
    }else if([typeString isEqualToString:@"image"]){
        return SRCampaignTypeImage;
    }else{
        return SRCampaignTypeUnknown;
    }
}

#pragma mark - Campaign Time Methods

- (SRCampaignTimeLeft)timeLeft{
    int now = [[NSDate date] timeIntervalSince1970];
    int end = [self.endDate timeIntervalSince1970];
    int difference = end - now;
    _timeLeft.native = difference;
    _timeLeft.days = difference / (24 * 60 * 60);
    difference -= _timeLeft.days * (24 * 60 * 60);
    _timeLeft.hours = difference / (60 * 60);
    difference -= _timeLeft.hours * (60 * 60);
    _timeLeft.minutes = difference / 60;
    difference -= _timeLeft.minutes * 60;
    _timeLeft.seconds = difference;
    return _timeLeft;
}

- (NSString*)timeLeftDescriptiveMessage{
    SRCampaignTimeLeft timeLeft = self.timeLeft;
    if(timeLeft.native > 0) {
        if(timeLeft.days > 1){
            return [NSString stringWithFormat:@"%d일 남음", timeLeft.days];
        }else if(timeLeft.days == 1){
            return @"내일 마감";
        }
        return [self timeLeftMessage];
    }else{
        return @"행사 마감";
    }
}

- (NSString*)timeLeftMessage{
    SRCampaignTimeLeft timeLeft = self.timeLeft;
    if(timeLeft.native > 0) {
        NSString *result = @"";
        if(timeLeft.days > 0){
            NSString *text = [NSString stringWithFormat:@"%d일 ",  timeLeft.days];
            result = [result stringByAppendingString:text];
        }
        if(timeLeft.days > 0 || timeLeft.hours > 0){
            NSString *text = [NSString stringWithFormat:@"%d시간 ",  timeLeft.hours];
            result = [result stringByAppendingString:text];
        }
        if(timeLeft.days > 0 || timeLeft.hours > 0 || timeLeft.minutes > 0){
            NSString *text = [NSString stringWithFormat:@"%d분 ",  timeLeft.minutes];
            result = [result stringByAppendingString:text];
        }
        if(timeLeft.days > 0 || timeLeft.hours > 0 || timeLeft.minutes > 0 || timeLeft.seconds > 0){
            NSString *text = [NSString stringWithFormat:@"%d초 ",  timeLeft.minutes];
            result = [result stringByAppendingString:text];
        }
        return [result stringByAppendingString:@"남음"];
    }else{
        return @"행사 마감";
    }
}

@end