//
//  SRDataModelSyntax.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 6..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#define SR_JSON +(NSDictionary*)dataModel{return @{@"":@""
#define SR_Map , @
#define _To : ^void(
#define _As *this, id value){
#define _Be *this,
#define _Do )
#define _Date = [(NSString*)value DateFromISODate];}
#define _DataModel = [[
#define _InjectAs = [[[
#define _Raw = value;}
#define _Init  alloc] initWithDictionary:value];}
#define _Inject  alloc] init] inject:value];}
#define SR_End };}

#define SR_Unique + (NSString*)databaseUniqueKey{ return
#define SR_Name + (NSString*)databaseName{ return
#define SR_IOTargets + (NSArray*)ioTargets{ return
#define SR_RelationMap - (NSDecimalNumber*)
#define _ValueOf { return
#define SR_Set ;}

#define SR_Decimal @property (nonatomic, strong) NSDecimalNumber *
#define SR_Float @property (nonatomic, strong) NSNumber *
#define SR_String @property (nonatomic, strong) NSString *
#define SR_Date @property (nonatomic, strong) NSDate *
#define SR_Relation @property (nonatomic, strong) NSDecimalNumber *
#define SR_DataModel @property (nonatomic, strong) SRDataModel *
#define SR_Link @property (nonatomic, strong) 