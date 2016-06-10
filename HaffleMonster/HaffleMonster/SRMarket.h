//
//  SRMarket.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SRDataModel.h"

@interface SRMarket : SRDataModel

SR_Decimal marketId;
SR_String name;
SR_String marketDescription;
SR_String phoneNumber;
SR_Float coordinateLongitude;
SR_Float coordinateLatitude;
SR_String panoramaURL;
SR_String businessHours;
SR_String logoURL;
SR_Date dataCreatedDate;

@property (nonatomic) NSArray *campaigns;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
