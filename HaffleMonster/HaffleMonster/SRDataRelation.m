//
//  SRDataRelation.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 6..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRDataRelation.h"

@implementation SRDataRelation
@synthesize keyString;

- (id)initWithKey:(NSString *)keyString{
    self = [self init];
    if(self != nil){
        NSArray *relationParts = [keyString componentsSeparatedByString:@"_"];
        self.target = relationParts[1];
        self.targetKey = relationParts[2];
        self.destinationKey = relationParts[3];
    }
    return self;
}

- (NSString*)keyString{
    return [NSString stringWithFormat:@"relation_%@_%@_%@", self.target, self.targetKey, self.destinationKey];
}

@end
