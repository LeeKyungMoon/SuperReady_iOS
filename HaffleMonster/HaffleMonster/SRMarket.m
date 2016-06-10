//
//  SRMarket.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRMarket.h"

@implementation SRMarket

@synthesize campaigns;
@synthesize coordinate = _coordinate;

#pragma mark - SuperReady Data Model

SR_JSON

SR_Map "id"
    _To SRMarket
    _As this.marketId
    _Raw

SR_Map "name"
    _To SRMarket
    _As this.name
    _Raw

SR_Map "description"
    _To SRMarket
    _As this.marketDescription
    _Raw

SR_Map "phone"
    _To SRMarket
    _As this.phoneNumber
    _Raw

SR_Map "latitude"
    _To SRMarket
    _As this.coordinateLatitude
    _Raw

SR_Map "longitude"
    _To SRMarket
    _As this.coordinateLongitude
    _Raw

SR_Map "panorama"
    _To SRMarket
    _As this.panoramaURL
    _Raw

SR_Map "created"
    _To SRMarket
    _As this.dataCreatedDate
    _Date

SR_End

#pragma mark - Data Model Methods

- (CLLocationCoordinate2D)coordinate{
    _coordinate.latitude = [self.coordinateLatitude floatValue];
    _coordinate.longitude = [self.coordinateLongitude floatValue];
    return _coordinate;
}

@end