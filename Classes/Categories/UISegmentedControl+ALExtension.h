//
//  UISegmentedControl+ALExtension.h
//  ALExtension
//
//  Created by Albert Lee on 4/11/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (ALExtension)
- (void)setSegmentsWithStringArray:(NSArray *)segments;
- (void)setSegmentsWithImageArray:(NSArray *)segments;
@end
