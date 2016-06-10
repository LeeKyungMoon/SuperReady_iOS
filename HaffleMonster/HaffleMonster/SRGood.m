//
//  SRGood.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRGood.h"

@implementation SRGood

@synthesize labels = _labels;

#pragma mark - SuperReady Data Model

SR_JSON

SR_Map "id"
    _To SRGood
    _As this.goodId
    _Raw

SR_Map "name"
    _To SRGood
    _As this.name
    _Raw

SR_Map "normalPrice"
    _To SRGood
    _As this.normalPrice
    _Raw

SR_Map "retailPrice"
    _To SRGood
    _As this.retailPrice
    _Raw

SR_Map "description"
    _To SRGood
    _As this.goodDescription
    _Raw

SR_Map "eventDescription"
    _To SRGood
    _As this.priceDescription
    _Raw

SR_Map "discountRate"
    _To SRGood
    _As this.discountRate
    _Raw

SR_Map "labels"
    _To SRGood
    _As this.labelNativeValue
    _Raw

SR_Map "image"
    _To SRGood
    _As this.imageURL
    _Raw

SR_End

#pragma mark - Data Model Methods

+ (SRGood*)goodWithCampaign:(SRCampaign*)campaign{
    return [[SRGood alloc] initWithCampaign:campaign];
}

- (id)initWithCampaign:(SRCampaign*)campaign{
    self = [self init];
    if(self != nil){
        self.parentCampaign = campaign;
    }
    return self;
}

- (NSArray*)labels{
    if(self.labelNativeValue != nil){
        return [self.labelNativeValue componentsSeparatedByString:@","];
    }
    return @[];
}

@end
