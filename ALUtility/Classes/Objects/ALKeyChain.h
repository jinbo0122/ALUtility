//
//  ALKeyChain.h
//  ALExtension
//
//  Created by Albert Lee on 4/7/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALKeyChain : NSObject

@end


@interface ALKeyChainManager : NSObject
+(void)savePassWord:(NSString *)password forKey:(NSString *)key keyChainHost:(NSString*)host;
+(id)readPassWordFromKey:(NSString *)key keyChainHost:(NSString*)host;
+(void)deletePassWordFromKeyChainHost:(NSString*)host;
@end