//
//  NSNumber+ALExtension.m
//  ALExtension
//
//  Created by Albert Lee on 8/22/16.
//  Copyright © 2016 Albert Lee. All rights reserved.
//

#import "NSNumber+ALExtension.h"

@implementation NSNumber (ALExtension)
- (NSNumber *)increment{
  return @([self integerValue]+1);
}
- (NSNumber *)decrement{
  return @([self integerValue]-1);
}

- (NSNumber *)plus:(NSInteger)num{
  return @([self integerValue]+num);
}

- (NSNumber *)minus:(NSInteger)num{
  return @([self integerValue]-num);
}

- (NSString *)feedTimeString{
  NSTimeInterval currentTime = [NSDate currentTime];
  NSTimeInterval feedTime = [self doubleValue];
  
  if (feedTime >= currentTime) {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:currentTime-1];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
  }else{
    int diff = (int)(currentTime - feedTime);
    if (diff < 86400) {
      NSDate *date = [NSDate dateWithTimeIntervalSince1970:feedTime];
      NSDateFormatter *formatter = [NSDateFormatter new];
      formatter.dateFormat = @"HH:mm";
      NSString *dateStr = [formatter stringFromDate:date];
      return dateStr;
    }else{
      NSDate *date = [NSDate dateWithTimeIntervalSince1970:feedTime];
      NSDateFormatter *formatter = [NSDateFormatter new];
      formatter.dateFormat = @"MM/dd";
      NSString *dateStr = [formatter stringFromDate:date];
      return dateStr;
    }
  }
}

- (NSString *)liveTimeString{
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
  NSDateFormatter *formatter = [NSDateFormatter new];
  formatter.dateFormat = @"HH:mm";
  NSString *dateStr = [formatter stringFromDate:date];
  return dateStr;
}

- (NSString *)floatString{
  CGFloat value = [self floatValue];
  NSString *str = [NSString stringWithFormat:@"%.2f",value];
  if ([str rangeOfString:@".00"].location != NSNotFound) {
    str = [str substringToIndex:str.length-3];
  }else if ([[str substringFromIndex:str.length-1] isEqualToString:@"0"]) {
    str = [str substringToIndex:str.length-1];
  }
  return str;
}

@end
