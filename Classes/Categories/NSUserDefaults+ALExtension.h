//
//  NSUserDefaults+Utility.h
//  pandora
//
//  Created by Albert Lee on 1/24/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (ALExtension)
- (void)setSafeStringObject:(id)value forKey:(NSString *)defaultName;
- (void)setSafeNumberObject:(id)value forKey:(NSString *)defaultName;
- (void)setSafeDictionaryObject:(id)value forKey:(NSString *)defaultName;


- (id)safeArrayObjectForKey:(NSString*)key;
- (id)safeStringObjectForKey:(NSString*)key;
- (id)safeNumberObjectForKey:(NSString*)key;
- (id)safeObjectForKey:(NSString*)key;
- (id)safeDicObjectForKey:(NSString*)key;
@end
