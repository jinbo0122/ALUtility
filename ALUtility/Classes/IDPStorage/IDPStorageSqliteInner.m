//
//  IDPStorageSqliteInner.m
//  IDP
//
//  Created by ZhangHe on 13-3-21.
//
//

#import "IDPStorageSqliteInner.h"
#import "IDPStorageConst.h"

@interface IDPStorageSqliteInner ()
@property (nonatomic,copy) NSString* nameSpace;
@property (nonatomic,retain,getter = getDatabase) ALDataBase *database;
@end
@implementation IDPStorageSqliteInner

-(id)initWithNameSpace:(NSString*)nameSpace
{
  self = [super init];
  if (self)
  {
    self.nameSpace = nameSpace;
    self.database = [[IDPStorageSqliteConnection sharedInstance] database];
    
    [_database executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (key TEXT, value BLOB)", nameSpace]];
    [_database executeUpdate:[NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS key ON %@(key)", nameSpace]];
  }
  return self;
}

- (void)dealloc
{
  self.nameSpace = nil;
  self.database = nil;
}

-(NSError*)createError:(NSString*)description errorCode:(NSInteger)code
{
  NSDictionary * userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
  return [NSError errorWithDomain:@"com.baobao.idp" code:code userInfo:userInfo];
}

-(BOOL)existObjectForKey:(NSString*)key
{
  ALResultSet *rs = [_database executeQuery:[NSString stringWithFormat:@"SELECT 1 FROM %@ WHERE key = ?", _nameSpace], key];
  if ([rs next])
  {
    return YES;
  }
  return NO;
}

//同步方法
-(NSData*)loadObjectForKey:(NSString*)key error:(NSError**)error
{
  ALResultSet *rs = [_database executeQuery:[NSString stringWithFormat:@"SELECT value FROM %@ WHERE key = ?", _nameSpace], key];
  if ([rs next])
  {
    return [rs dataForColumn:@"value"];
  }
  return nil;
}

-(BOOL)saveObject:(NSData*)obj forKey:(NSString*)key error:(NSError**)error
{
  if (nil == obj || [obj isEqual:[NSNull null]]) {
    //        *error = [self createError:@"does not support nil or Null value" errorCode:-1];
    return NO;
  }
  BOOL result = NO;
  BOOL isExists = [self existObjectForKey:key];
  if(isExists)
  {
    result = [_database executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET value = ? WHERE key = ?", _nameSpace], obj, key];
  }
  else
  {
    result = [_database executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (key, value) VALUES (?, ?)", _nameSpace], key, obj];
  }
  return result;
}

-(BOOL)removeObjectForKey:(NSString*)key error:(NSError **)error
{
  BOOL result = [_database executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE key = ?", _nameSpace], key];
  return result;
}

//清空整个命名空间
+(BOOL)cleanNameSpace:(NSString*)nameSpace error:(NSError **)error
{
  ALDataBase *database = [[IDPStorageSqliteConnection sharedInstance] database];
  BOOL result = [database executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", nameSpace]];
  return result;
}

@end


@implementation IDPStorageSqliteConnection

DEF_SINGLETON(IDPStorageSqliteConnection)

- (id)init
{
  self = [super init];
  if (self) {
    _database = [[ALDataBase alloc] initWithPath:[IDPStorageSqliteConnection getDatabasePath]];
    [_database setLogsErrors:YES];
    [_database open];
    
  }
  return self;
}

+(NSString *)getDatabasePath
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString* path = [documentsDirectory stringByAppendingPathComponent:@"data.db"];
  return path;
}

- (void)dealloc
{
  [_database close];
  self.database = nil;
}

@end

