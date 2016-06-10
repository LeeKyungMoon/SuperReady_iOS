//
//  SRCampaign.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRDataModel.h"

typedef enum SRCampaignType {
    SRCampaignTypeUnknown,
    SRCampaignTypeBig,
    SRCampaignTypeSmall,
    SRCampaignTypeImage
} SRCampaignType;

typedef struct SRCampaignTimeLeft {
    int native;
    int days;
    int hours;
    int minutes;
    int seconds;
} SRCampaignTimeLeft;

@interface SRCampaign : SRDataModel

SR_Decimal campaignId;
SR_String name;
SR_String campaignDescription;
SR_Date startDate;
SR_Date endDate;
SR_String typeNativeValue;
SR_Date dataCreatedDate;

@property (nonatomic, strong) SRMarket *parentMarket;

@property (nonatomic) NSArray *items;
@property (nonatomic) SRCampaignType type;
@property (nonatomic) SRCampaignTimeLeft timeLeft;
@property (nonatomic) NSString *timeLeftDescriptiveMessage;
@property (nonatomic) NSString *timeLeftMessage;

@end
