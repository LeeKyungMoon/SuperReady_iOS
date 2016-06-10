//
//  HMMart.m
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 23..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMMart.h"

@implementation HMMart
@synthesize description;
- (id)initWithCartItem:(HMUserCartItem*)cartItem{
    if (!cartItem) {
        return nil;
    }
    self = [super init];
    
    if (self != nil) {
        self.martId = cartItem.martId;
        self.name = cartItem.martName;
    }
    
    return self;
}

- (void)fillWithDictionary:(NSDictionary*)dictionary{
    self.martId=[(NSNumber*)[dictionary objectForKey:@"id"] unsignedIntegerValue];
    // 마트 id는 꼭 필요하지 않나? 무조건 던져준다고 일단 생각했음 -경문
    self.name=[dictionary objectForKey:@"name"];
    // 마트 id랑 이름은 필수 값 - 경문
    if ([dictionary objectForKey:@"phone"]==(id)[NSNull null]) {
        self.phone=@"알 수 없음";
    }else{
        self.phone=[dictionary objectForKey:@"phone"];
        if (self.phone == nil) {
            self.phone = @"";
        }
    }
    if (([dictionary objectForKey:@"latitude"]==(id)[NSNull null])&&([dictionary objectForKey:@"longitude"]==(id)[NSNull null])){
        // 아무처리도 안하면 self.coordinate에 접근하면서 오류가 생기는 듯
        // 그래서 일단 상수값 넣었으나 현재 위치를 넣어주거나와 같은 기획적 접근이 필요함 - 경문
        self.coordinate = CLLocationCoordinate2DMake(0,0);
    }else{
        self.latitude = [(NSNumber*)[dictionary objectForKey:@"latitude"] floatValue];
        self.longitude = [(NSNumber*)[dictionary objectForKey:@"longitude"] floatValue];
        self.coordinate = CLLocationCoordinate2DMake([(NSNumber*)[dictionary objectForKey:@"latitude"] floatValue], [(NSNumber*)[dictionary objectForKey:@"longitude"] floatValue]);
    }
    
    if ([dictionary objectForKey:@"description"]==(id)[NSNull null]) {
        self.description=@"";
    }else{
        self.description=[dictionary objectForKey:@"description"];
        if (self.description == nil) {
            self.description = @"";
        }
    }
    
    if ([dictionary objectForKey:@"panorama"]==(id)[NSNull null]) {
        //아무처리 안하면 역시 panorama에 접근하면서 오류 -경문
        self.panorama =@"";
    }else{
        self.panorama=[dictionary objectForKey:@"panorama"];
        if (self.panorama == nil) {
            self.panorama = @"";
        }
    }
    
    if ([dictionary objectForKey:@"businessHours"]==(id)[NSNull null]) {
        self.businessHours=@"해당없음";
    }else{
        self.businessHours=[dictionary objectForKey:@"businessHours"];
        if (self.businessHours == nil) {
            self.businessHours = @"";
        }
    }
    
    if ([dictionary objectForKey:@"logo"] == (id)[NSNull null]) {
        self.logo = @"";
    }else{
        self.logo = [dictionary objectForKey:@"logo"];
        if (self.logo == nil) {
            self.logo = @"";
        }
    }
    if ([dictionary objectForKey:@"created"]==(id)[NSNull null]) {
        //상품리스트 뷰에서 네비게이션 타이틀로만 쓰임, 없으면 브랜드명이나 자체가게명으로 대체되기 때문에 버려도됨 - 경문
        self.logo = @"";
    }else{
        self.createdDate = [[dictionary objectForKey:@"created"] DateFromISODate];
        if (self.createdDate == nil) {
            self.createdDate = [NSDate date];
        }
    }
    if ([dictionary objectForKey:@"brandId"] == (id)[NSNull null]) {
        self.brandId = 0;
    }else{
        self.brandId = [[dictionary objectForKey:@"brandId"] integerValue];
        NSNumber *checkBrandId = [NSNumber numberWithInteger:self.brandId];
        if (checkBrandId == nil) {
            self.brandId = 0;
        }
    }
    //self.campaigns = [@[] mutableCopy]; 캠페인은 처리 안해도 되는 것 같은데 괜찮을까? -경문
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self != nil){
        [self fillWithDictionary:dictionary];
    }
    return self;
}

- (void)loadCampaignsWithRawDataDictionary:(NSArray*)array{
    //딕셔너리를 키밸류 전환하는 코드 - 경문
    self.normalCampaigns = [[NSMutableArray alloc] init];
    self.timesaleCampaigns = [[NSMutableArray alloc] init];
    self.rawFlyerCampaigns = [[NSMutableArray alloc] init];
    
    for(NSDictionary *campaignDictionary in array){
        HMCampaign *campaign = [[HMCampaign alloc] initWithDictionary:campaignDictionary];
        if([campaignDictionary[@"type"] isEqualToString:@"big"]){
            [self.timesaleCampaigns addObject:campaign];
        }else if([campaignDictionary[@"type"] isEqualToString:@"small"]){
            [self.normalCampaigns addObject:campaign];
        }else{
            [self.rawFlyerCampaigns addObject:campaign];
        }
    }
}

- (HMMartNameState)stateWithMartName{
    if(!(self.logo.length==0)){
        return HMMartNameWithLogo;
    }else{
        return HMMartNameWithName;
    }
}
@end
