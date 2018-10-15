//
//  NSDate+ALExtension.h
//  ALExtension
//
//  Created by Albert Lee on 4/7/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ALUserDefaultsServerTimeDiffWithLocalTime @"ALUserDefaultsServerTimeDiffWithLocalTime"
@interface NSDate (ALExtension)
+ (NSTimeInterval)currentTime;
- (NSString *) stringWithFormat: (NSString *) format;
@end
