//
//  NSArray+Plist.h
//  KKShopping
//
//  Created by Albert Lee on 6/8/13.
//  Copyright (c) 2013 KiDulty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ALExtension)
- (NSData*)data;
- (BOOL)writeToPlistFileSync:(NSString*)filename;
+ (NSArray*)readFromPlistFile:(NSString*)filename;
+ (void)removePlistFile:(NSString*)filename;
- (id)safeObjectAtIndex:(NSUInteger)index;
- (id)safeDicObjectAtIndex:(NSUInteger)index;
- (id)safeObjectAtIndex:(NSUInteger)index class:(Class)aClsss;
- (NSArray *)safeArrayObjectAtIndex:(NSUInteger)index;
- (id)safeNumberObjectAtIndex:(NSUInteger)index;
- (id)safeStringObjectAtIndex:(NSUInteger)index;

- (NSArray *)subarrayWithRangeSafely:(NSRange)range;

@end

@interface NSMutableArray(ALExtension)
//安全add函数
- (void)safeAddObject:(id)anObject;
//安全插入函数
-(bool)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;
//安全移除函数
-(bool)safeRemoveObjectAtIndex:(NSUInteger)index;
//安全替换函数
-(bool)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end
