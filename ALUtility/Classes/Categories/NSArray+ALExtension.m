//
//  NSArray+Plist.m
//  KKShopping
//
//  Created by Albert Lee on 6/8/13.
//  Copyright (c) 2013 KiDulty. All rights reserved.
//

#import "NSArray+ALExtension.h"

@implementation NSArray(ALExtension)
-(BOOL)writeToPlistFileSync:(NSString*)filename{
  if (self==nil||(
                  (![self isKindOfClass:[NSArray class]])&&
                  (![self isKindOfClass:[NSMutableArray class]]))||
      [self count]==0) {
    return NO;
  }
  BOOL didWriteSuccessfull = NO;
  NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  didWriteSuccessfull = [data writeToFile:path atomically:YES];
  return didWriteSuccessfull;
}

+(NSArray*)readFromPlistFile:(NSString*)filename{
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  NSData * data = [NSData dataWithContentsOfFile:path];
  if(!data){
    return @[];
  }
  else{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
  }
}

+(void)removePlistFile:(NSString*)filename
{
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  BOOL result = [[[NSFileManager alloc] init] removeItemAtPath:path error:nil];
  ALLogVerbose(@"%@",result?@"sucess":@"fail");
}

- (id)safeObjectAtIndex:(NSUInteger)index{
  @synchronized(self) {
    if (![self isKindOfClass:[NSArray class]] || index >= self.count)
      return nil;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:[NSObject class]]) {
      return obj;
    }else{
      return nil;
    }
  }
}

- (id)safeObjectAtIndex:(NSUInteger)index class:(Class)aClsss{
  @synchronized(self) {
    if (![self isKindOfClass:[NSArray class]] || index >= self.count || !self)
      return [[aClsss alloc] init];
    
    if ([[self objectAtIndex:index] isKindOfClass:aClsss]) {
      return [self objectAtIndex:index];
    }else{
      return [[aClsss alloc] init];
    }
  }
}

- (NSArray *)subarrayWithRangeSafely:(NSRange)range
{
  if (![self isRightWithRange:range forArray:self onFunction:__FUNCTION__]){
    return nil;
  }
  return [self subarrayWithRange:range];
}

- (BOOL)isRightWithRange:(NSRange)range forArray:(NSArray *)array onFunction:(const char *)function
{
  BOOL isRight = array.count >= range.location + range.length;
  BOOL isValidRange = range.location <10000 && range.length < 10000 && range.location != NSNotFound && range.location < array.count && range.length <= array.count; //subarray 1000 个应该足够了
  isRight = isRight && isValidRange;
  if (!isRight) {
    [[self class] printRangeError:range forArray:array onFunction:function];
  }
  return isRight;
}

+ (void)printRangeError:(NSRange)range forArray:(NSArray *)array onFunction:(const char *)function
{
#if PDLogEnable
  NSLog(@"*************error******************\n %s:\n range.location %d range.length %d beyond array count %d",function ,range.location,range.length ,array.count);
  NSLog(@"array data : \n %@",array);
  NSLog(@"*************error stack****************** \n%@",ThreadCallStackSymbols);
#else
#endif
  
}

- (id)safeDicObjectAtIndex:(NSUInteger)index{
  @synchronized(self) {
    if ( index >= self.count ||!self || ![self isKindOfClass:[NSArray class]])
      return [NSDictionary dictionary];
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:[NSDictionary class]]) {
      return obj;
    }
    else{
      return [NSDictionary dictionary];
    }
  }
}

- (NSArray *)safeArrayObjectAtIndex:(NSUInteger)index{
  @synchronized(self) {
    if ( index >= self.count || ![self isKindOfClass:[NSArray class]])
      return [NSArray array];
    
    if ([[self objectAtIndex:index] isKindOfClass:[NSArray class]]) {
      return [self objectAtIndex:index];
    }
    else{
      return [NSArray array];
    }
  }
}

- (id)safeNumberObjectAtIndex:(NSUInteger)index{
  @synchronized(self) {
    if ( index >= self.count || ![self isKindOfClass:[NSArray class]])
      return @0;
    
    if ([[self objectAtIndex:index] isKindOfClass:[NSNumber class]]) {
      return [self objectAtIndex:index];
    }
    else{
      return @0;
    }
  }
}

- (id)safeStringObjectAtIndex:(NSUInteger)index{
  @synchronized(self) {
    if ( index >= self.count || ![self isKindOfClass:[NSArray class]])
      return @"";
    if ([[self objectAtIndex:index] isKindOfClass:[NSString class]]) {
      return [self objectAtIndex:index];
    }
    else{
      return @"";
    }
  }
}

-(NSData*)data
{
  NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
  return data;
}
@end

@implementation NSMutableArray (ALExtension)
- (void)safeAddObject:(id)anObject
{
  @synchronized(self){
    if (anObject) {
      [self addObject:anObject];
    }
  }
}
-(bool)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
  @synchronized(self){
    if ( index >= self.count && index != 0)
    {
      return NO;
    }
    [self insertObject:anObject atIndex:index];
  }
  return YES;
}

-(bool)safeRemoveObjectAtIndex:(NSUInteger)index
{
  @synchronized(self){
    if ( index >= self.count )
    {
      return NO;
    }
    [self removeObjectAtIndex:index];
  }
  return YES;
  
}
-(bool)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
  @synchronized(self){
    if ( index >= self.count )
    {
      return NO;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
  }
  return YES;
}
@end
