//
//  HMItem.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 1..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMItem.h"

@implementation HMItem

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self != nil){
        self.itemId = [[dictionary objectForKey:@"id"] unsignedIntegerValue];
        self.itemName = [dictionary objectForKey:@"name"];
        //id 와 name은 필수값
        
        if ([dictionary objectForKey:@"description"]==(id)[NSNull null]) {
            self.itemDescription=@"해당 없음";
        }else{
            self.itemDescription = [dictionary objectForKey:@"description"];
            if (!self.itemDescription) {
                self.itemDescription = @"";
            }
        }
        if ([dictionary objectForKey:@"campaignId"] == (id)[NSNull null]) {
            self.parentCampaignId = 0;
        }else{
            self.parentCampaignId = [[dictionary objectForKey:@"campaignId"] unsignedIntegerValue];
            NSNumber *checkNumber = [NSNumber numberWithUnsignedInteger:self.parentCampaignId];
            if (checkNumber == nil) {
                self.parentCampaignId = 0;
            }
        }
        if ([dictionary objectForKey:@"marketId"] == (id)[NSNull null]) {
            self.parentMarketId = 0;
        }else{
            self.parentMarketId = [[dictionary objectForKey:@"marketId"] unsignedIntegerValue];
            NSNumber *checkNumber = [NSNumber numberWithUnsignedInteger:self.parentMarketId];
            if (checkNumber == nil) {
                self.parentMarketId = 0;
            }
        }
        if ([dictionary objectForKey:@"detail"]==(id)[NSNull null]) {
            self.itemDetail=@"해당 없음";
        }else{
            self.itemDetail = [dictionary objectForKey:@"description"];
            if (self.itemDetail == nil) {
                self.itemDetail = @"해당 없음";
            }
        }//@property (nonatomic) NSString *itemDetail;
        if ([dictionary objectForKey:@"eventDescription"]==(id)[NSNull null]) {
            self.eventDescription=@"해당 없음";
        }else{
            self.eventDescription = [dictionary objectForKey:@"eventDescription"];
            if (self.eventDescription == nil) {
                self.eventDescription = @"해당 없음";
            }
        }
        if ([dictionary objectForKey:@"discountRate"] == (id)[NSNull null]) {
            self.discountRate = 0;
        }else{
            self.discountRate = [[dictionary objectForKey:@"discountRate"] integerValue];
            NSNumber *checkNumber = [NSNumber numberWithInteger:self.parentMarketId];
            if (checkNumber == nil) {
                self.discountRate = 0;
            }
        }
        
        if ([dictionary objectForKey:@"retailPrice"]==(id)[NSNull null]) {
            self.price = 0;
        }else{
            self.price = [[dictionary objectForKey:@"retailPrice"] unsignedIntegerValue];
        }
        
        if ([dictionary objectForKey:@"normalPrice"]==(id)[NSNull null]) {
            self.prePrice = 0;
        }else{
            self.prePrice = [[dictionary objectForKey:@"prePrice"] unsignedIntegerValue];
        }
        if ([dictionary objectForKey:@"image"]==(id)[NSNull null]) {
            self.imageURLString = @"";
        }else{
            self.imageURLString = [dictionary objectForKey:@"image"];
            if (self.imageURLString == nil) {
                self.imageURLString = @"";
            }
        }
        if ([dictionary objectForKey:@"created"] == (id)[NSNull null]) {
            self.createdDate = [NSDate date];
        }else{
            self.createdDate = [[dictionary objectForKey:@"created"] DateFromISODate];
            if (self.createdDate == nil) {
                self.createdDate = [NSDate date];
            }
        }
        self.parentCampaign = nil;
    }
    return self;
}
- (id)initWithCartItem:(HMUserCartItem*)cartItem{
    self = [super init];
    if (self != nil) {
        self.itemId = cartItem.itemId;
        self.itemName = cartItem.itemName;
        self.itemDescription = cartItem.itemDescription;
        self.price = cartItem.itemPrice;
        self.imageURLString = cartItem.imageURL;
        self.parentCampaign = nil;
    }
    return self;
}

@end
