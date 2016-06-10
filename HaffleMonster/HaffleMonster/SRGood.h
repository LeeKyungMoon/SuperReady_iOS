//
//  SRItem.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRDataModel.h"

@interface SRGood : SRDataModel

SR_Decimal goodId;
SR_Decimal normalPrice;
SR_Decimal retailPrice;
SR_Decimal discountRate;
SR_String name;
SR_String goodDescription;
SR_String priceDescription;
SR_String imageURL;
SR_String labelNativeValue;
SR_String tags;

@property (nonatomic, strong) SRCampaign *parentCampaign;
@property (nonatomic, strong) NSArray *labels;

@end
