//
//  SRDataRelation.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 6..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRDataRelation : NSObject

@property (nonatomic) NSString *target;
@property (nonatomic) NSString *targetKey;
@property (nonatomic) NSString *destinationKey;
@property (nonatomic) NSString *keyString;

- (id)initWithKey:(NSString*)keyString;

@end
