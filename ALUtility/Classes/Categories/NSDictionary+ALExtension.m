//
//  NSDictionary+Plist.m
//  KKShopping
//
//  Created by andaji on 13-9-18.
//  Copyright (c) 2013年 KiDulty. All rights reserved.
//

#import "NSDictionary+ALExtension.h"

@implementation NSDictionary (ALExtension)
-(NSData*)data
{
  NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
  return data;
}
- (NSObject *)objectAtPath:(NSString *)path
{
  @synchronized (self) {
    NSArray * array = [path componentsSeparatedByString:@"/"];
    if ( 0 == [array count] )
    {
      return nil;
    }
    
    NSObject * result = nil;
    NSDictionary * dict = self;
    
    for ( NSString * subPath in array )
    {
      if ( 0 == [subPath length] )
        continue;
      
      result = [dict objectForKey:subPath];
      if ( nil == result )
        return nil;
      
      if ( [array lastObject] == subPath )
      {
        return result;
      }
      else if ( NO == [result isKindOfClass:[NSDictionary class]] )
      {
        return nil;
      }
      
      dict = (NSDictionary *)result;
    }
    
    return (result == [NSNull null]) ? nil : result;
  }
}

- (NSObject *)objectAtPath:(NSString *)path otherwise:(NSObject *)other
{
  NSObject * obj = [self objectAtPath:path];
  return obj ? obj : other;
}

- (BOOL)boolAtPath:(NSString *)path
{
  return [self boolAtPath:path otherwise:NO];
}

- (BOOL)boolAtPath:(NSString *)path otherwise:(BOOL)other
{
  NSObject * obj = [self objectAtPath:path];
  if ( [obj isKindOfClass:[NSNull class]] )
  {
    return NO;
  }
  else if ( [obj isKindOfClass:[NSNumber class]] )
  {
    return [(NSNumber *)obj intValue] ? YES : NO;
  }
  else if ( [obj isKindOfClass:[NSString class]] )
  {
    if ( [(NSString *)obj hasPrefix:@"y"] ||
        [(NSString *)obj hasPrefix:@"Y"] ||
        [(NSString *)obj hasPrefix:@"T"] ||
        [(NSString *)obj hasPrefix:@"t"] ||
        [(NSString *)obj isEqualToString:@"1"] )
    {
      // YES/Yes/yes/TRUE/Ture/true/1
      return YES;
    }
    else
    {
      return NO;
    }
  }
  
  return other;
}

- (NSNumber *)numberAtPath:(NSString *)path
{
  NSObject * obj = [self objectAtPath:path];
  if ( [obj isKindOfClass:[NSNull class]] )
  {
    return nil;
  }
  else if ( [obj isKindOfClass:[NSNumber class]] )
  {
    return (NSNumber *)obj;
  }
  else if ( [obj isKindOfClass:[NSString class]] )
  {
    return [NSNumber numberWithDouble:[(NSString *)obj doubleValue]];
  }
  
  return nil;
}

- (NSNumber *)numberAtPath:(NSString *)path otherwise:(NSNumber *)other
{
  NSNumber * obj = [self numberAtPath:path];
  return obj ? obj : other;
}

- (NSString *)stringAtPath:(NSString *)path
{
  NSObject * obj = [self objectAtPath:path];
  if ( [obj isKindOfClass:[NSNull class]] )
  {
    return nil;
  }
  else if ( [obj isKindOfClass:[NSNumber class]] )
  {
    return [NSString stringWithFormat:@"%lld", [(NSNumber *)obj longLongValue]];
  }
  else if ( [obj isKindOfClass:[NSString class]] )
  {
    return (NSString *)obj;
  }
  
  return nil;
}

- (NSString *)stringAtPath:(NSString *)path otherwise:(NSString *)other
{
  NSString * obj = [self stringAtPath:path];
  return obj ? obj : other;
}

- (NSArray *)arrayAtPath:(NSString *)path
{
  NSObject * obj = [self objectAtPath:path];
  return [obj isKindOfClass:[NSArray class]] ? (NSArray *)obj : nil;
}

- (NSArray *)arrayAtPath:(NSString *)path otherwise:(NSArray *)other
{
  NSArray * obj = [self arrayAtPath:path];
  return obj ? obj : other;
}

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path
{
  NSObject * obj = [self objectAtPath:path];
  return [obj isKindOfClass:[NSMutableArray class]] ? (NSMutableArray *)obj : nil;
}

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path otherwise:(NSMutableArray *)other
{
  NSMutableArray * obj = [self mutableArrayAtPath:path];
  return obj ? obj : other;
}

- (NSDictionary *)dictAtPath:(NSString *)path
{
  NSObject * obj = [self objectAtPath:path];
  return [obj isKindOfClass:[NSDictionary class]] ? (NSDictionary *)obj : nil;
}

- (NSDictionary *)dictAtPath:(NSString *)path otherwise:(NSDictionary *)other
{
  NSDictionary * obj = [self dictAtPath:path];
  return obj ? obj : other;
}

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path
{
  NSObject * obj = [self objectAtPath:path];
  return [obj isKindOfClass:[NSMutableDictionary class]] ? (NSMutableDictionary *)obj : nil;
}

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path otherwise:(NSMutableDictionary *)other
{
  NSMutableDictionary * obj = [self mutableDictAtPath:path];
  return obj ? obj : other;
}

-(BOOL)writeToPlistFile:(NSString*)filename{
  if (self==nil || self.count==0) {
    return NO;
  }
  __block BOOL didWriteSuccessfull = NO;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:[self copy]];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
    didWriteSuccessfull = [data writeToFile:path atomically:YES];
  });
  return didWriteSuccessfull;
}
-(BOOL)writeToPlistFileSync:(NSString*)filename{
  if (self==nil || self.count==0) {
    return NO;
  }
  
  BOOL didWriteSuccessfull = NO;
  NSData * data = [NSKeyedArchiver archivedDataWithRootObject:[self copy]];
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  didWriteSuccessfull = [data writeToFile:path atomically:YES];
  return didWriteSuccessfull;
}
+(NSDictionary*)readFromPlistFile:(NSString*)filename{
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  NSData * data = [NSData dataWithContentsOfFile:path];
  if (data) {
    return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
  }
  else{
    return [NSDictionary dictionary];
  }
}

+(void)removePlistFile:(NSString*)filename
{
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  BOOL result = [[[NSFileManager alloc] init] removeItemAtPath:path error:nil];
  NSLog(@"%@",result?@"sucess":@"fail");
}

- (id)safeObjectForKey:(NSString*)key{
  @synchronized (self) {
    if ([self objectForKey:key]) {
      return [self objectForKey:key];
    }
    else{
      return [[NSObject alloc] init];
    }
  }
}

- (id)safeDicObjectForKey:(NSString*)key{
  @synchronized (self) {
    if ([self objectForKey:key] && [[self objectForKey:key] isKindOfClass:[NSDictionary class]]) {
      return [self objectForKey:key];
    }
    else{
      return [[NSDictionary alloc] init];
    }
  }
}

- (id)safeArrayObjectForKey:(NSString*)key{
  @synchronized (self) {
    if ([self objectForKey:key] && [[self objectForKey:key] isKindOfClass:[NSArray class]]) {
      return [self objectForKey:key];
    }
    else{
      return [NSArray array];
    }
  }
}

- (id)safeStringObjectForKey:(NSString*)key{
  @synchronized (self) {
    if ([self objectForKey:key] && [[self objectForKey:key] isKindOfClass:[NSString class]]) {
      return [self objectForKey:key];
    }
    else{
      return @"";
    }
  }
}
- (id)safeNumberObjectForKey:(NSString*)key{
  @synchronized (self) {
    if ([self objectForKey:key] && [[self objectForKey:key] isKindOfClass:[NSNumber class]]) {
      return [self objectForKey:key];
    }
    else{
      return [NSNumber numberWithInteger:0];
    }
  }
}

- (NSObject *)bb_objectAtPath:(NSString *)path
{
  NSArray * array = [path componentsSeparatedByString:@"/"];
  if ( 0 == [array count] )
  {
    return nil;
  }
  
  NSObject * result = nil;
  NSDictionary * dict = self;
  
  for ( NSString * subPath in array )
  {
    if ( 0 == [subPath length] )
      continue;
    
    result = [dict objectForKey:subPath];
    if ( nil == result )
      return nil;
    
    if ( [array lastObject] == subPath )
    {
      return result;
    }
    else if ( NO == [result isKindOfClass:[NSDictionary class]] )
    {
      return nil;
    }
    
    dict = (NSDictionary *)result;
  }
  
  return (result == [NSNull null]) ? nil : result;
}

- (NSString *)bb_stringAtPath:(NSString *)path
{
  NSObject * obj = [self bb_objectAtPath:path];
  if ( [obj isKindOfClass:[NSNull class]] )
  {
    return nil;
  }
  else if ( [obj isKindOfClass:[NSNumber class]] )
  {
    return [NSString stringWithFormat:@"%lld", [(NSNumber *)obj longLongValue]];
  }
  else if ( [obj isKindOfClass:[NSString class]] )
  {
    return (NSString *)obj;
  }
  
  return nil;
}
@end


@implementation NSMutableDictionary(ALExtension)
- (void)setSafeObject:(id)anObject forKey:(id <NSCopying>)aKey{
  @synchronized (self) {
    if(anObject&&aKey){
      [self setObject:anObject forKey:aKey];
    }
  }
}
@end
