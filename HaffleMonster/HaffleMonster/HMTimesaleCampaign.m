//
//  HMTimesaleCampaign.m
//  HaffleMonster
//
//  Created by 이경문 on 2015. 4. 13..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMTimesaleCampaign.h"

@implementation NSString (NSStringHMAPIAdditions)
- (NSDate*)DateFromISODate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZZ";
    return [dateFormatter dateFromString:self];
}
@end

@implementation HMTimesaleCampaign



@end
