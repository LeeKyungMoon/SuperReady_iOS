//
//  SRDataModel.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 2..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRDataModelSyntax.h"
#import "SRTypeDefs.h"

#import "SRDatabaseLoads.h"

@interface NSString (SRNSStringAdditions)
- (NSDate*)DateFromISODate;
@end

@interface NSDate (SRNSDateAdditions)
- (NSString*)ISODateRepresentation;
@end

/* - 해찬
 * SRDataModel은 JSON -> OBJC 객체의 변환을 간편하게 도와줍니다.
 * 자동으로 initWithJSON 메소드를 생성합니다.
 * -(id)inject:(id)data를 제외한 메소드는 절대로 임의로 오버라이딩해서는 안됩니다. 반드시 SR_JSON을 이용해주세요!
 * 자세한 사용법은 우선 현재 implementation을 확인해주세요.
 * 데이터모델객체 = [데이터모델클래스 map:JSON(NSDictionary)]로 사용 가능합니다.
 */
@interface SRDataModel : NSObject

/**
 * 주어진 JSON NSDictionary로 객체를 생성하고 초기화합니다.
 */
+ (id)map:(NSDictionary*)dictionary;

/**
 * [직접 사용하지 마세요]
 */
+ (NSDictionary*)dataModel;

/**
 * [직접 사용하지 마세요]
 */
+ (void)dataModelTarget:(id)dataModel dictionary:(NSDictionary*)data;

/**
 * [직접 구현하지 마세요] 데이터베이스으ㅢ
 */
- (id)initWithJSON:(NSDictionary*)dictionary;

/**
 * initWithJSON: 으로 객체를 초기화하는 경우 서브 데이터객체 활성화 방식을 정의합니다.
 */
- (id)inject:(id)data;

/**
 * [직접 구현하지 마세요] 데이터모델의 JOIN을 위한 관계링크를 반환합니다.
 */
- (NSArray*)relations;

/**
 * [직접 구현하지 마세요] 데이터베이스에 저장시 유니크한 값으로 사용되는 필드의 키를 반환합니다.
 */
+ (NSString*)databaseUniqueKey;

/**
 * [직접 구현하지 마세요] 데이터베이스에 저장시 사용할 테이블의 이름을 반환합니다.
 */
+ (NSString*)databaseName;

/**
 * [직접 구현하지 마세요] 데이터베이스 쿼리에 사용가능한 형태로 데이터모델의 IO타깃의 키 목록을 반환합니다. (컴마로 구분)
 */
+ (NSString*)databaseKeysSQL;

/**
 * [직접 구현하지 마세요] 데이터베이스 쿼리에 사용가능한 형태로 데이터모델의 IO타깃의 값 목록을 반환합니다. (컴마로 구분)
 */
+ (NSString*)databaseKeysParameterSQL;

/**
 * [직접 구현하지 마세요] 데이터베이스에 저장시 유니크한 값으로 사용되는 필드의 값을 반환합니다.
 */
- (NSValue*)databaseUnique;

/**
 * [직접 구현하지 마세요] 데이터베이스에 저장되는 타깃이 되는 Property를 규정합니다.
 */
+ (NSArray*)ioTargets;

/**
 * [직접 구현하지 마세요] 데이터베이스 컬럼명으로 사용할 키값 목록
 */
+ (NSArray*)databaseKeys;

/**
 * [직접 구현하지 마세요] 데이터 모델이 저장될 수 있는 테이블 생성 SQL 쿼리문을 반환합니다.
 */
+ (NSString*)createSQL;

/**
 * [직접 구현하지 마세요] 데이터베이스 입출력에 사용할 수 있는 데이터 Key Value 쌍을 반환합니다.
 */
- (NSDictionary*)databaseDictionary;

/**
 * [직접 구현하지 마세요] JSON키 값이 아닌 KVC방식으로 초기화합니다.
 */
- (id)initWithDictionary:(NSDictionary*)dictionary;

@end

NSString* SRQueryDataTypeFromNSValue(NSValue *value){
    return (@{
        @"NSDecimalNumber" : @"integer",
        @"NSNumber" : @"real",
        @"NSDate" : @"date",
        @"NSString" : @"text"
    })[NSStringFromClass([value class])];
}