//
//  IDPStorageFileInner.m
//  IDP
//
//  Created by douj on 17-3-12.
//
//

#import "IDPStorageFileInner.h"
#import "IDPStorageConst.h"
#import <Foundation/Foundation.h>
#import "NSString+ALExtension.h"
#import "NSDictionary+ALExtension.h"
@interface IDPStorageFileInner ()
@property (nonatomic,copy) NSString* nameSpace;
@property (nonatomic,copy,getter = getStoragePath) NSString* storagePath;
@end
@implementation IDPStorageFileInner


static NSFileManager* get_file_manager()
{
  static NSFileManager *idpShareFileManager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    idpShareFileManager = [NSFileManager new];
  });
  return idpShareFileManager;
}


-(id)initWithNameSpace:(NSString*)nameSpace
{
  self = [super init];
  if (self)
  {
    self.nameSpace = nameSpace;
    //新建namesapce目录
    [get_file_manager() createDirectoryAtPath:self.storagePath withIntermediateDirectories:YES attributes:nil error:nil];
  }
  return self;
}
- (void)dealloc
{
  self.nameSpace = nil;
  _storagePath = nil;
}

-(NSError*)createError:(NSString*)description errorCode:(NSInteger)code
{
  NSDictionary * userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
  return [NSError errorWithDomain:@"com.baobao.idp" code:code userInfo:userInfo];
}

-(BOOL)existObjectForKey:(NSString*)key
{
  NSFileManager* manager = get_file_manager();
  NSString* fullPath = [self getFullPathForKey:key];
  if ([manager fileExistsAtPath:fullPath]) {
    return YES;
  }
  return NO;
}
//同步方法
-(NSData*)loadObjectForKey:(NSString*)key error:(NSError**)error
{
  NSString* fullPath = [self getFullPathForKey:key];
  NSData* data= [NSData dataWithContentsOfFile:fullPath];
  // 更新文件修改时间，以便不被清除
  NSFileManager* manager = get_file_manager();
  [manager setAttributes: @{NSFileModificationDate: [NSDate date]} ofItemAtPath:fullPath error:nil];
  return data;
}
-(BOOL)saveObject:(NSData*)obj forKey:(NSString*)key error:(NSError**)error
{
  if ([obj isEqual:[NSNull null]]) {
    if (error) {
      *error = [self createError:@"not support Null value" errorCode:-1];
    }
    return FALSE;
  }
  NSString* fullPath = [self getFullPathForKey:key];
  //新建namesapce目录
  if(![get_file_manager() fileExistsAtPath:self.storagePath])
  {
    [get_file_manager() createDirectoryAtPath:self.storagePath withIntermediateDirectories:YES attributes:nil error:nil];
  }
  return [get_file_manager() createFileAtPath:fullPath contents:obj attributes:nil];
}

-(BOOL)removeObjectForKey:(NSString*)key error:(NSError **)error
{
  if ([self existObjectForKey:key]) {
    NSString* fullPath = [self getFullPathForKey:key];
    NSFileManager* manager = get_file_manager();
    return [manager removeItemAtPath:fullPath error:error];
  }
  return YES;
}

+(void)cleanExpiredFiles:(NSString *)nameSpace expire:(NSNumber *)expireNumber
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    NSFileManager *manager = get_file_manager();
    NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:[IDPStorageFileInner getStoragePath:nameSpace]];
    NSString *filePath = [enumerator nextObject];
    NSDate *date = [[NSDate alloc] init];
    double currDate = [date timeIntervalSince1970];
    
    while (filePath) {
      @autoreleasepool
      {
        NSDictionary *attributes = [enumerator fileAttributes];
        double modifyDate = [(NSDate *)[attributes objectAtPath:NSFileModificationDate] timeIntervalSince1970];
        double expireDate = modifyDate + [expireNumber doubleValue];
        if (expireDate < currDate) {
          NSString *fullPath = [[IDPStorageFileInner getStoragePath:nameSpace] stringByAppendingPathComponent:filePath];
          NSLog(@"Delete cached file: %@", fullPath);
          [manager removeItemAtPath:fullPath error:nil];
        }
        filePath = [enumerator nextObject];
      }
    }
  });
}

//清空整个命名空间
+(BOOL)cleanNameSpace:(NSString*)nameSpace error:(NSError **)error
{
  NSString* fullPath  =  [IDPStorageFileInner getStoragePath:nameSpace];
  NSFileManager* manager = get_file_manager();
  return [manager removeItemAtPath:fullPath error:error];
}

//获取当前对象的存储文件夹
-(NSString*)getStoragePath
{
  if(!_storagePath)
  {
    _storagePath = [[IDPStorageFileInner getStoragePath:self.nameSpace] copy];
  }
  return _storagePath;
}

//获取文件的完整文件路径
-(NSString*)getFullPathForKey:(NSString*)key
{
  NSString* md5 = [key MD5];
  NSString* fullPath = [self.storagePath stringByAppendingPathComponent:md5];
  return fullPath;
}

//获取namespace对应的文件路径
+(NSString*)getStoragePath:(NSString*)nameSpace
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString* fullFileName = [[NSString stringWithFormat:@"%@",nameSpace] MD5];
  NSString* path = [documentsDirectory stringByAppendingPathComponent:fullFileName];
  return path;
}

@end
