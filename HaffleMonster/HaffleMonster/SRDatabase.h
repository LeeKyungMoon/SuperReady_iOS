//
//  SRDatabase.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 5..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "SRDataModel.h"
#import "SRDataRelation.h"

@interface SRDatabase : NSObject {
    FMDatabase *db;
}

- (void)createTables

+ (SRDatabase*)db;

- (NSArray*)getAllDataModelsForDataModel:(Class)dataModel;
- (BOOL)insertDataModel:(SRDataModel*)dataModel;
- (BOOL)deleteDataModel:(SRDataModel*)dataModel;
- (BOOL)clearDataModel:(Class)dataModel;
- (BOOL)checkDuplicateDataModel:(SRDataModel*)dataModel;
- (NSUInteger)countForDataModel:(Class)dataModel;

@end

@interface FMResultSet (SRDBFMResultSetAddition)

- (NSArray*)dataModelsValueForClass:(Class)dataModelClass;
- (SRDataModel*)nextDataModelValueForClass:(Class)dataModelClass;
- (NSDictionary*)dictionaryValueForClass:(Class)dataModelClass

@end
