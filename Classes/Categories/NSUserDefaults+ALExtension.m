//
//  NSUserDefaults+Utility.m
//  pandora
//
//  Created by Albert Lee on 1/24/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "NSUserDefaults+ALExtension.h"

@implementation NSUserDefaults (ALExtension)
- (void)setSafeStringObject:(id)value forKey:(NSString *)defaultName{
  @synchronized (self) {
    if (value && [value isKindOfClass:[NSString class]]) {
      [self setObject:value forKey:defaultName];
    }
  }
}

- (void)setSafeNumberObject:(id)value forKey:(NSString *)defaultName{
  @synchronized (self) {
    if (value && [value isKindOfClass:[NSNumber class]]) {
      [self setObject:value forKey:defaultName];
    }
  }
}

- (void)setSafeDictionaryObject:(id)value forKey:(NSString *)defaultName{
  @synchronized (self) {
    if (value && [value isKindOfClass:[NSDictionary class]]) {
      [self setObject:value forKey:defaultName];
    }
  }
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

@end
