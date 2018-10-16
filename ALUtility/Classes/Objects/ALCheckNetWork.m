//
//  ALCheckNetWork.m
//  Pandora
//
//  Created by Albert on 13-6-26.
//  Copyright (c) 2014年 Pandora. All rights reserved.
//

#import "ALCheckNetWork.h"
#import "ALReachability.h"
@implementation ALCheckNetWork

+ (BOOL)isUsingWifi{
  BOOL isUsingWifi = NO;
  ALReachability *rea = [ALReachability reachabilityForInternetConnection];
  if ([rea currentReachabilityStatus]==ReachableViaWiFi){
    isUsingWifi = YES;
  }
  return isUsingWifi;
}

+ (BOOL)isReachable:(NSString *)serverName{
  ALReachability *rea = [ALReachability reachabilityForInternetConnection];
  if ([rea currentReachabilityStatus]!= NotReachable){
    return YES;
  }
  return NO;
}

+ (NSString*)currentNetWork:(NSString *)serverName{
  ALReachability *rea = [ALReachability reachabilityForInternetConnection];
  if ([rea currentReachabilityStatus]!= NotReachable) {
    if ([rea currentReachabilityStatus]==ReachableViaWiFi) {
      return @"WLAN";
    }
    else{
      return @"3G/2G";
    }
  }
  return @"None";
}
@end
