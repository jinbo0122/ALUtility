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
@end
