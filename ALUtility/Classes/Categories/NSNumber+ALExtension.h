//
//  NSNumber+ALExtension.h
//  ALExtension
//
//  Created by Albert Lee on 8/22/16.
//  Copyright © 2016 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (ALExtension)
- (NSNumber *)increment;
- (NSNumber *)decrement;
- (NSNumber *)plus:(NSInteger)num;
- (NSNumber *)minus:(NSInteger)num;

- (NSString *)feedTimeString;
- (NSString *)liveTimeString;
- (NSString *)floatString;
@end
