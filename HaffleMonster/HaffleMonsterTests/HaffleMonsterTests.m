//
//  HaffleMonsterTests.m
//  HaffleMonsterTests
//
//  Created by Fermata on 2015. 3. 13..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HMDataModel.h"
#import "HMDatabase.h"

@interface HaffleMonsterTests : XCTestCase

@end

@implementation HaffleMonsterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - HMDatabase Tests

- (void)testUserCartCreation{
    HMDatabase *db = [HMDatabase db];
    [db createDatabaseStructure];
    //XCTAssert([db checkUserCartTableExistance]);
}

- (void)testUserCartInsert{
    /*HMDatabase *db = [HMDatabase db];
    NSUInteger rowCountBefore = [db countOfUserCart];
    HMUserCartItem *testCartItem = [[HMUserCartItem alloc] init];
    testCartItem.itemId = 360289;
    testCartItem.itemName = @"테스트 상품";
    testCartItem.itemDescription = @"테스트 상품 설명";
    testCartItem.itemPrice = 32000;
    testCartItem.campaignId = 352;
    testCartItem.campaignStartDate = [NSDate date];
    testCartItem.campaignEndDate = [NSDate date];
    testCartItem.martId = 3251;
    testCartItem.martName = @"하나로마트";
    testCartItem.lastUpdate = [NSDate date];
    [db insertUserCartItem:testCartItem];
    XCTAssert(rowCountBefore + 1 == [db countOfUserCart]);
     */
}

@end
