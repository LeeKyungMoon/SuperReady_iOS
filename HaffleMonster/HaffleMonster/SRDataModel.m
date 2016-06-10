//
//  SRDataModel.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRDataModel.h"
#import "objc/runtime.h"

@implementation NSString (SRNSStringAdditions)
- (NSDate*)DateFromISODate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZZ";
    return [dateFormatter dateFromString:self];
}
@end

@implementation NSDate (SRNSDateAdditions)
- (NSString*)ISODateRepresentation{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZZ"];
    return [dateFormat stringFromDate:self];
}
@end

#pragma mark - SRDataModel

@implementation SRDataModel

+ (id)map:(NSDictionary*)dictionary{
    return [[self alloc] initWithJSON:dictionary];
}

+ (NSDictionary*)dataModel{
    HMLog(HMLogImportant, @"SRDataModel은 사용전 반드시 SR_JSON으로 Map이 정의되어야합니다.");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (void)dataModelTarget:(id)dataModel dictionary:(NSDictionary *)data{
    NSDictionary *dataModelGenerators = [self dataModel];
    if(dataModelGenerators){
        NSEnumerator *enumerator = [data keyEnumerator];
        id key;
        while((key = [enumerator nextObject])){
            if([dataModelGenerators objectForKey:key] != nil){
                ((void(^)(id this, id value))([dataModelGenerators objectForKey:key]))(dataModel, [data objectForKey:key]);
            }
        }
    }
}

- (id)initWithJSON:(NSDictionary*)dictionary{
    self = [self init];
    if(self != nil){
        [self loadDictionary:dictionary];
    }
    return self;
}

- (void)loadDictionary:(NSDictionary*)dictionary{
    [self.class dataModelTarget:self dictionary:dictionary];
}

- (id)inject:(id)data{
    NSString *className = NSStringFromClass([self class]);
    HMLog(HMLogImportant, @"%@의 Inject가 정의되지 않았습니다.", className);
    [self doesNotRecognizeSelector:_cmd];
    return self;
}

- (NSArray*)relations{
    NSMutableArray *propertyList = [@[] mutableCopy];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *keyString = [NSString stringWithUTF8String:propName];
            if([keyString hasPrefix:@"relation_"]){
                SRDataRelation *dataRelation = [[SRDataRelation alloc] initWithKey:keyString];
                [propertyList addObject:dataRelation];
            }
        }
    }
    free(properties);
    return propertyList;
}

+ (NSString*)databaseUniqueKey{
    NSString *className = NSStringFromClass([self class]);
    HMLog(HMLogImportant, @"%@의 데이터베이스 입출력 전 반드시 SR_Unique로 Unique한 키의 변수명이 정의되어야합니다.", className);
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (NSString*)databaseName{
    NSString *className = NSStringFromClass([self class]);
    HMLog(HMLogImportant, @"%@의 데이터베이스 입출력 전 반드시 SR_Name으로 데이터베이스 테이블 이름이 정의되어야합니다.", className);
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (NSString*)databaseKeysSQL{
    NSArray *keys = [self databaseKeys];
    NSString *result = [keys componentsJoinedByString:@", "];
    return result;
}

+ (NSString*)databaseKeysParameterSQL{
    NSArray *keys = [self databaseKeys];
    NSString *result = [keys componentsJoinedByString:@", :"];
    return [NSString stringWithFormat:@":%@", result];
}

- (NSValue*)databaseUnique{
    return [self valueForKey:[[self class] databaseUniqueKey]];
}

+ (NSArray*)ioTargets{
    HMLog(HMLogImportant, @"SRDataModel은 데이터베이스 입출력에 사용전 반드시 SR_IOTargets로 데이터베이스에 저장할 값을 명시해야합니다.");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (NSArray*)databaseKeys{
    SRDataModel *dataModel = [[self alloc] init];
    NSArray *dataKeys = [[self class] ioTargets];
    NSArray *relations = [dataModel relations];
    NSMutableArray *values = [@[] mutableCopy];
    for(NSString *dataKey in dataKeys){
        [values addObject:dataKey];
    }
    for(SRDataRelation *relation in relations){
        NSString *key = [relation keyString];
        [values addObject:key];
    }
    return values;
}

+ (NSString*)createSQL{
    SRDataModel *dataModel = [[self alloc] init];
    NSArray *dataKeys = [[dataModel class] ioTargets];
    NSArray *relations = [dataModel relations];
    NSMutableString *query = [@"CREATE TABLE IF NOT EXISTS " mutableCopy];
    [query appendString:[[dataModel class] databaseName]];
    [query appendString:@" ("];
    NSInteger counts = 0;
    NSInteger target = dataKeys.count + relations.count;
    for(NSInteger index = 0; index < dataKeys.count; index++){
        counts++;
        NSString *queryDataType = SRQueryDataTypeFromNSValue([dataModel valueForKey:dataKeys[index]]);
        NSString *syntax = [NSString stringWithFormat:@"'%@' %@", dataKeys[index], queryDataType];
        [query appendString:syntax];
        if(counts != target){
            [query appendString:@", "];
        }
    }
    for(NSInteger index = 0; index < relations.count; index++){
        counts++;
        SRDataRelation *relation = relations[index];
        NSString *syntax = [NSString stringWithFormat:@"'%@' integer", relation.keyString];
        [query appendString:syntax];
        if(counts != target){
            [query appendString:@", "];
        }
    }
    [query appendString:@")"];
    return query;
}

- (NSDictionary*)databaseDictionary{
    NSArray *dataKeys = [[self class] ioTargets];
    NSArray *relations = [self relations];
    NSMutableDictionary *values = [@{} mutableCopy];
    for(NSString *dataKey in dataKeys){
        [values setObject:[self valueForKey:dataKey] forKey:dataKey];
    }
    for(SRDataRelation *relation in relations){
        NSString *key = [relation keyString];
        [values setObject:[self valueForKey:key] forKey:key];
    }
    return values;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [self init];
    if(self != nil){
        NSEnumerator *enumerator = [dictionary keyEnumerator];
        id key;
        while((key = [enumerator nextObject])){
            [self setValue:[dictionary valueForKey:key] forKey:key];
        }
    }
    return self;
}

@end