//
//  ALUtility.m
//  ALExtension
//
//  Created by Albert Lee on 11/04/2017.
//  Copyright © 2017 Albert Lee. All rights reserved.
//

#import "ALUtility.h"

@implementation ALUtility
+ (NSString *)backBarButtonArrowResource{
#ifndef BBSDKMODE
  NSBundle *bundle = [NSBundle mainBundle];
  NSDictionary *info = [bundle infoDictionary];
  NSString *bundleIdentifier = [info objectForKey:@"CFBundleIdentifier"];
  if ([bundleIdentifier isEqualToString:@"com.myhug.baobao"]) {
    return @"icon_message_return_gray";
  }else if ([bundleIdentifier isEqualToString:@"cn.myhug.avalon"]||
            [bundleIdentifier isEqualToString:@"cn.myhug.dikangavalon"]||
            [bundleIdentifier isEqualToString:@"cn.myhug.avalonGuanFang"]||
            [bundleIdentifier isEqualToString:@"cn.myhug.avalonen"]||
            [bundleIdentifier isEqualToString:@"cn.myhug.werewolf"]){
    return @"but_back_left_black";
  }else if ([bundleIdentifier isEqualToString:@"com.dianjinghudong.tclb"]||
            [bundleIdentifier isEqualToString:@"cn.myhug.sweetcone"]){
    return @"but_back_left_black";
  }else if ([bundleIdentifier isEqualToString:@"cn.myhug.moeshot"]){
    return @"but_back_left_black";
  }
  return @"icon_message_return_gray";
#else
  return [BBLiveSDKUtility backBarButtonArrowResource];
#endif
}

+ (CGRect)backBarButtonArrowRect{
#ifndef BBSDKMODE
  NSBundle *bundle = [NSBundle mainBundle];
  NSDictionary *info = [bundle infoDictionary];
  NSString *bundleIdentifier = [info objectForKey:@"CFBundleIdentifier"];
  if ([bundleIdentifier isEqualToString:@"com.myhug.baobao"]) {
    return [[ALUtility backBarButtonArrowResource] isEqualToString:@"icon_message_return_gray"]?CGRectMake(-8,8.5, 22, 22):CGRectMake(-8,8.5, 13.4, 22);
  }else if ([bundleIdentifier isEqualToString:@"cn.myhug.avalon"]||
            [bundleIdentifier isEqualToString:@"cn.myhug.avalonen"]||
            [bundleIdentifier isEqualToString:@"cn.myhug.werewolf"]){
    return CGRectMake(-5, 13, 12, 18);
  }else if ([bundleIdentifier isEqualToString:@"com.dianjinghudong.tclb"]||
            [bundleIdentifier isEqualToString:@"cn.myhug.sweetcone"]){
    return CGRectMake(-3, 7, 30, 30);
  }else if ([bundleIdentifier isEqualToString:@"cn.myhug.moeshot"]){
    return CGRectMake(-8,13, 12, 18);
  }else{
    return CGRectMake(-5, 13, 12, 18);
  }
#else
  return [BBLiveSDKUtility backBarButtonArrowRect];
#endif
}
@end
