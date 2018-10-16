//
//  ALBaseDB.m
//  pandora
//
//  Created by Albert Lee on 2/3/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import "ALBaseDB.h"
#import "../ALDatabase/ALDatabase.h"
#import "../ALDatabase/ALDatabaseAdditions.h"
#import "../Categories/NSDictionary+ALExtension.h"
@implementation ALDataBase (ALBaseDB)
+ (NSString *)conditionColumn:(NSString *)column compareType:(NSString *)compareType value:(id)value{
  NSString *valueString = @"";
  if ([value isKindOfClass:[NSString class]]) {
    valueString = [NSString stringWithFormat:@"'%@'",value];
  }
  else if ([value isKindOfClass:[NSNumber class]]){
    valueString = [(NSNumber *)value stringValue];
  }
  return [NSString stringWithFormat:@"%@ %@ %@",column,compareType,valueString];
}

+ (NSString *)columnName:(NSString *)column dbType:(NSString *)dbType isPrimaryKey:(BOOL)isPrimaryKey isNotNull:(BOOL)isNotNull{
  NSString *columnCreate = [NSString stringWithFormat:@"%@ %@",column, dbType];
  if (isPrimaryKey){
    columnCreate = [columnCreate stringByAppendingString:@" PRIMARY KEY"];
  }
  if (isNotNull) {
    columnCreate = [columnCreate stringByAppendingString:@" NOT NULL"];
  }
  return columnCreate;
}

+ (NSString *)sqlForValueInColumn:(NSString *)column table:(NSString *)table conditions:(NSArray *)conditions{
  return [ALDataBase sqlForValueInColumn:column table:table conditions:conditions orderBy:nil orderByType:nil limit:0];
}

+ (NSString *)sqlForValueInColumn:(NSString *)column table:(NSString *)table conditions:(NSArray *)conditions
                          orderBy:(NSString *)orderByColumn orderByType:(NSString *)orderByType limit:(int)limit{
  NSString *conditionString = @"";
  for (NSString *condition in conditions) {
    conditionString = [conditionString stringByAppendingString:condition];
    conditionString = [conditionString stringByAppendingString:@" and "];
  }
  if (conditionString.length>=5) {
    conditionString = [conditionString substringWithRange:NSMakeRange(0, conditionString.length-5)];
  }
  
  if (orderByColumn && orderByType) {
    conditionString = [conditionString stringByAppendingString:[NSString stringWithFormat:@" order by %@ %@",orderByColumn,orderByType]];
  }
  
  if (limit>0) {
    conditionString = [conditionString stringByAppendingString:[NSString stringWithFormat:@" limit %d",limit]];
  }
  return [NSString stringWithFormat:@"select %@ from %@ where %@",column,table,conditionString];
}


- (NSError *)dbExecuteUpdate:(NSString *)sql{
  NSError *error;
  [self executeUpdate:sql withErrorAndBindings:&error];
  return error;
}

- (NSError *)dbCreateTable:(NSString *)table columns:(NSArray *)columns{
  NSString *columnsString = @"";
  for (NSString *column in columns) {
    columnsString = [columnsString stringByAppendingString:[column stringByAppendingString:@","]];
  }
  if (columnsString.length>=1) {
    columnsString = [columnsString substringWithRange:NSMakeRange(0, columnsString.length-1)];
  }
  
  NSError *error;
  [self executeUpdate:[NSString stringWithFormat:@"create table if not exists %@(%@)",table,columnsString]
 withErrorAndBindings:&error];
  return error;
}

- (NSError *)dbCreateIndex:(NSString *)indexName table:(NSString *)table columns:(NSArray *)columns{
  NSString *columnsString = @"";
  for (NSString *column in columns) {
    columnsString = [columnsString stringByAppendingString:[column stringByAppendingString:@","]];
  }
  if (columnsString.length>=1) {
    columnsString = [columnsString substringWithRange:NSMakeRange(0, columnsString.length-1)];
  }
  
  NSError *error;
  [self executeUpdate:[NSString stringWithFormat:@"create unique index %@ on %@(%@)",indexName,table,columnsString]
 withErrorAndBindings:&error];
  return error;
}

- (NSError *)dbAddColumn:(NSString *)columnName type:(NSString *)type table:(NSString *)table{
  NSError *error;
  [self executeUpdate:[NSString stringWithFormat:@"alter table %@ add column %@ %@",table,columnName,type]
 withErrorAndBindings:&error];
  return error;
}

- (NSError *)dbSetUserVersion:(int)version{
  NSError *error;
  [self executeUpdate:[NSString stringWithFormat:@"pragma user_version = %d",version]
 withErrorAndBindings:&error];
  return error;
}

- (NSError *)dbInsertIntoTable:(NSString *)table values:(NSArray *)values{
  NSString *valueString = @"";
  for (id obj in values) {
    if ([obj isKindOfClass:[NSString class]]) {
      valueString = [valueString stringByAppendingString:[NSString stringWithFormat:@"'%@'",obj]];
    }
    else if ([obj isKindOfClass:[NSNumber class]]){
      valueString = [valueString stringByAppendingString:[(NSNumber *)obj stringValue]];
    }
    valueString = [valueString stringByAppendingString:@","];
  }
  if (valueString.length>=1) {
    valueString = [valueString substringWithRange:NSMakeRange(0, valueString.length-1)];
  }
  NSError *error;
  [self executeUpdate:[NSString stringWithFormat:@"insert or ignore into %@ values(%@)",table,valueString]
 withErrorAndBindings:&error];
  
//  NSLog(@" insert error %@ -------- %@ ", error, values);
  return error;
}

- (NSError *)dbUpdateTable:(NSString *)table setValueDic:(NSDictionary *)valueDic conditions:(NSArray *)conditions{
  NSString *valueString = @"";
  for (NSString *key in [valueDic allKeys]) {
    id value = [valueDic safeObjectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
      valueString = [valueString stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@'",key,value]];
    }
    else if ([value isKindOfClass:[NSNumber class]]){
      valueString = [valueString stringByAppendingString:[NSString stringWithFormat:@"%@ = %@",key,value]];
    }
    valueString = [valueString stringByAppendingString:@","];
  }
  if (valueString.length>=1) {
    valueString = [valueString substringWithRange:NSMakeRange(0, valueString.length-1)];
  }
  
  
  NSString *conditionString = @"";
  for (NSString *condition in conditions) {
    conditionString = [conditionString stringByAppendingString:condition];
    conditionString = [conditionString stringByAppendingString:@" and "];
  }
  if (conditionString.length>=5) {
    conditionString = [conditionString substringWithRange:NSMakeRange(0, conditionString.length-5)];
  }
  
  NSError *error;
  [self executeUpdate:[NSString stringWithFormat:@"update %@ set %@ where %@",table,valueString,conditionString]
 withErrorAndBindings:&error];
  return error;
}

- (NSError *)dbDeleteFromTable:(NSString *)table conditions:(NSArray *)conditions{
  NSString *conditionString = @"";
  for (NSString *condition in conditions) {
    conditionString = [conditionString stringByAppendingString:condition];
    conditionString = [conditionString stringByAppendingString:@" and "];
  }
  if (conditionString.length>=5) {
    conditionString = [conditionString substringWithRange:NSMakeRange(0, conditionString.length-5)];
  }
  
  NSError *error;
  [self executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@",table,conditionString]
 withErrorAndBindings:&error];
  return error;
}

- (NSError *)dbDeleteAllFromTable:(NSString *)table{
  NSError *error;
  [self executeUpdate:[NSString stringWithFormat:@"delete from %@",table]
 withErrorAndBindings:&error];
  return error;
}

- (ALResultSet *)dbResultFromTable:(NSString *)table conditions:(NSArray *)conditions{
  return [self dbResultFromTable:table conditions:conditions orderBy:nil orderByType:nil];
}

- (ALResultSet *)dbResultFromTable:(NSString *)table conditions:(NSArray *)conditions limit:(NSInteger)limit{
  return [self dbResultFromTable:table conditions:conditions orderBy:nil orderByType:nil limit:limit];
}

- (ALResultSet *)dbResultFromTable:(NSString *)table conditions:(NSArray *)conditions orderBy:(NSString *)orderByColumn orderByType:(NSString *)orderByType{
  return [self dbResultFromTable:table conditions:conditions orderBy:orderByColumn orderByType:orderByType limit:0];
}

- (ALResultSet *)dbResultFromTable:(NSString *)table conditions:(NSArray *)conditions orderBy:(NSString *)orderByColumn orderByType:(NSString *)orderByType limit:(NSInteger)limit{
  NSString *conditionString = @"where ";
  if (conditions.count>0) {
    for (NSString *condition in conditions) {
      conditionString = [conditionString stringByAppendingString:condition];
      conditionString = [conditionString stringByAppendingString:@" and "];
    }
    if (conditionString.length>=5) {
      conditionString = [conditionString substringWithRange:NSMakeRange(0, conditionString.length-5)];
    }
  }
  else{
    conditionString = @"";
  }

  
  NSString *orderByString = @"";
  if (orderByColumn && orderByType) {
    orderByString = [NSString stringWithFormat:@" order by %@ %@",orderByColumn,orderByType];
  }
  
  NSString *limitString = @"";
  if (limit>0){
    limitString = [NSString stringWithFormat:@" limit %d",(int)limit];
  }
  return [self executeQuery:[NSString stringWithFormat:@"select * from %@ %@%@%@",table,conditionString,orderByString,limitString]];
}

- (int)dbResultCountFromTable:(NSString *)table conditions:(NSArray *)conditions{
  NSString *conditionString = @"where ";
  if (conditions.count>0) {
    for (NSString *condition in conditions) {
      conditionString = [conditionString stringByAppendingString:condition];
      conditionString = [conditionString stringByAppendingString:@" and "];
    }
    if (conditionString.length>=5) {
      conditionString = [conditionString substringWithRange:NSMakeRange(0, conditionString.length-5)];
    }
  }
  else{
    conditionString = @"";
  }
  return [self intForQuery:[NSString stringWithFormat:@"select count(*) from %@ %@",table,conditionString]];
}
@end
