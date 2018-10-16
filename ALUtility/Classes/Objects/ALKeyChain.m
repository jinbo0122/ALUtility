//
//  ALKeyChain.m
//  ALExtension
//
//  Created by Albert Lee on 4/7/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import "ALKeyChain.h"

@implementation ALKeyChain
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
  @autoreleasepool {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
  }
}

+ (void)save:(NSString *)service data:(id)data {
  @autoreleasepool {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
  }
}

+ (id)load:(NSString *)service {
  @autoreleasepool {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
      @try {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
      } @catch (NSException *e) {
        NSLog(@"Unarchive of %@ failed: %@", service, e);
      } @finally {
      }
    }
    return ret;
  }
}

+ (void)delete:(NSString *)service {
  @autoreleasepool {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
  }
}
@end


@implementation ALKeyChainManager

+(void)savePassWord:(NSString *)password forKey:(NSString *)key keyChainHost:(NSString*)host
{
  @autoreleasepool {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[ALKeyChain load:host];
    if (!usernamepasswordKVPairs) {
      usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    }
    [usernamepasswordKVPairs setObject:password forKey:key];
    [ALKeyChain save:host data:usernamepasswordKVPairs];
  }
}

+(id)readPassWordFromKey:(NSString *)key keyChainHost:(NSString*)host
{
  @autoreleasepool {
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[ALKeyChain load:host];
    return [usernamepasswordKVPair objectForKey:key];
  }
}

+(void)deletePassWordFromKeyChainHost:(NSString*)host
{
  @autoreleasepool {
    [ALKeyChain delete:host];
  }
}

@end
