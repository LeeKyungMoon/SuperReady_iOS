//
//  SRDatabase.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 5..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRDatabase.h"

@implementation SRDatabase

#pragma mark - Database Setup Code

- (NSArray*)targetDataModels{
    NSString *dataModelPath = [[NSBundle mainBundle] pathForResource:@"SRDatabaseDataModels" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:dataModelPath];
}

- (void)createTables{
    if([db open]){
        NSArray *dataModels = [self targetDataModels];
        for(NSString *dataModelName in dataModels){
            Class dataModelClass = NSClassFromString(dataModelName);
            SRDataModel *dataModel = [[dataModelClass alloc] init];
            NSString *query = [[dataModel class] createSQL];
            if(![db executeQuery:query]){
                HMLog(HMLogImportant, @"CreateTables Error: %@", db.lastErrorMessage);
            }
        }
        [db close];
    }
}

#pragma mark - Singleton Pattern

+ (NSString*)dbPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *dbURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    dbURL = [dbURL URLByAppendingPathComponent:@"SuperReady.sqlite"];
    return dbURL.absoluteString;
}

+ (SRDatabase*)db{
    static SRDatabase *globalDatabase;
    @synchronized(self){
        if(globalDatabase == nil){
            globalDatabase = [[self alloc] init];
        }
    }
    return globalDatabase;
}

- (id)init{
    self = [super init];
    if(self != nil){
        db = [FMDatabase databaseWithPath:[SRDatabase dbPath]];
    }
    return self;
}

#pragma mark - Basic IO Methods

- (NSArray*)getAllDataModelsForDataModel:(Class)dataModel{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", [dataModel databaseName]];
    if([db open]){
        FMResultSet *rs = [db executeQuery:query];
        [db close];
        return [rs dataModelsValueForClass:dataModel];
    }
    return nil;
}

- (BOOL)insertDataModel:(SRDataModel*)dataModel{
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", [[dataModel class] databaseName], [[dataModel class] databaseKeysSQL], [[dataModel class] databaseKeysParameterSQL]];
    if([db open]){
        [db executeQuery:query withParameterDictionary:[dataModel databaseDictionary]];
        [db close];
        return YES;
    }
    return NO;
}

- (BOOL)deleteDataModel:(SRDataModel*)dataModel{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@", [[dataModel class] databaseName], [[dataModel class] databaseUniqueKey], [dataModel databaseUnique]];
    if([db open]){
        [db executeQuery:query];
        [db close];
        return YES;
    }
    return NO;
}

- (BOOL)clearDataModel:(Class)dataModel{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@", [dataModel databaseName]];
    if([db open]){
        [db executeQuery:query];
        [db close];
        return YES;
    }
    return NO;
}

- (BOOL)checkDuplicateDataModel:(SRDataModel*)dataModel{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@ LIMIT 1", [[dataModel class] databaseName], [[dataModel class] databaseUniqueKey], [dataModel databaseUnique]];
    if([db open]){
        FMResultSet *rs = [db executeQuery:query];
        [db close];
        if([rs next]){
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)countForDataModel:(Class)dataModel{
    NSString *query = [NSString stringWithFormat:@"SELECT count(*) FROM %@", [[dataModel class] databaseName]];
    if([db open]){
        FMResultSet *rs = [db executeQuery:query];
        [db close];
        if([rs next]){
            return [[rs objectForColumnIndex:0] unsignedIntegerValue];
        }
    }
    return 0;
}

@end

@implementation FMResultSet (SRDBFMResultSetAddition)

#pragma mark - DataModel Converters

- (NSArray*)dataModelsValueForClass:(Class)dataModelClass{
    NSMutableArray *values = [@[] mutableCopy];
    SRDataModel *dataModel;
    while((dataModel = [self nextDataModelValueForClass:dataModelClass]) != nil){
        [values addObject:dataModel];
    }
    return values;
}

- (SRDataModel*)nextDataModelValueForClass:(Class)dataModelClass{
    if([self next]){
        NSDictionary *dictionary = [self dictionaryValueForClass:dataModelClass];
        return [(SRDataModel*)[dataModelClass alloc] initWithDictionary:dictionary];
    }else{
        return nil;
    }
}

- (NSDictionary*)dictionaryValueForClass:(Class)dataModelClass{
    SRDataModel *dataModel = [[dataModelClass alloc] init];
    NSDictionary *dictionary = [self dictionaryWithValuesForKeys:[[dataModel class] databaseKeys]];
    return dictionary;
}

@end
