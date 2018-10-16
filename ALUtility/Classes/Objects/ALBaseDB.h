//
//  ALBaseDB.h
//  pandora
//
//  Created by Albert Lee on 2/3/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALDatabase.h"
#import "ALResultSet.h"
/***********DATABASE CONDITION***********/
#define DB_CONDITION_EQUAL            @"="
#define DB_CONDITION_NOT_EQUAL        @"!="
#define DB_CONDITION_GREATER          @">"
#define DB_CONDITION_LESS             @"<"
#define DB_CONDITION_LESS_OR_GREATER  @"<>"
/***********DATABASE COLUMN TYPE***********/
#define DB_COLUMN_TYPE_TEXT           @"TEXT"
#define DB_COLUMN_TYPE_BLOB           @"BLOB"
#define DB_COLUMN_TYPE_INT            @"INT"
#define DB_COLUMN_TYPE_BIGINT         @"BIGINT"
#define DB_COLUMN_TYPE_NCHAR55        @"NCHAR(55)"
#define DB_COLUMN_TYPE_BOOL           @"BOOLEAN"
#define DB_RESULT_ORDER_BY_TYPE_DESC  @"desc"
#define DB_RESULT_ORDER_BY_TYPE_ASC   @"asc"
/**********COMMON SQL**********************/
#define SQL_MSG_DB_GET_USER_VERSION   @"pragma user_version"

@class ALDataBase;
@interface ALDataBase(ALBaseDB)
+ (NSString *)conditionColumn:(NSString *)column compareType:(NSString *)compareType value:(id)value;
+ (NSString *)columnName:(NSString *)column dbType:(NSString *)dbType isPrimaryKey:(BOOL)isPrimaryKey isNotNull:(BOOL)isNotNull;
+ (NSString *)sqlForValueInColumn:(NSString *)column table:(NSString *)table conditions:(NSArray *)conditions;
+ (NSString *)sqlForValueInColumn:(NSString *)column table:(NSString *)table conditions:(NSArray *)conditions
                          orderBy:(NSString *)orderByColumn orderByType:(NSString *)orderByType limit:(int)limit;

- (NSError *)dbExecuteUpdate:(NSString *)sql;
- (NSError *)dbCreateTable:(NSString *)table columns:(NSArray *)columns;
- (NSError *)dbCreateIndex:(NSString *)indexName table:(NSString *)table columns:(NSArray *)columns;
- (NSError *)dbAddColumn:(NSString *)columnName type:(NSString *)type table:(NSString *)table;
- (NSError *)dbInsertIntoTable:(NSString *)table values:(NSArray *)values;
- (NSError *)dbUpdateTable:(NSString *)table setValueDic:(NSDictionary *)valueDic conditions:(NSArray *)conditions;
- (NSError *)dbDeleteFromTable:(NSString *)table conditions:(NSArray *)conditions;
- (NSError *)dbDeleteAllFromTable:(NSString *)table;
- (NSError *)dbSetUserVersion:(int)version;

- (ALResultSet *)dbResultFromTable:(NSString *)table conditions:(NSArray *)conditions;
- (ALResultSet *)dbResultFromTable:(NSString *)table conditions:(NSArray *)conditions limit:(NSInteger)limit;
- (ALResultSet *)dbResultFromTable:(NSString *)table conditions:(NSArray *)conditions orderBy:(NSString *)orderByColumn orderByType:(NSString *)orderByType;
- (ALResultSet *)dbResultFromTable:(NSString *)table conditions:(NSArray *)conditions orderBy:(NSString *)orderByColumn orderByType:(NSString *)orderByType limit:(NSInteger)limit;
- (int)dbResultCountFromTable:(NSString *)table conditions:(NSArray *)conditions;
@end
