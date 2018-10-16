//
//  ALCheckNetWork.h
//  Pandora
//
//  Created by Albert on 13-6-26.
//  Copyright (c) 2014年 Pandora. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ALCheckNetWork : NSObject
+ (BOOL)isUsingWifi;
+ (NSString*)currentNetWork:(NSString *)serverName;
+ (BOOL)isReachable:(NSString *)serverName;
@end
