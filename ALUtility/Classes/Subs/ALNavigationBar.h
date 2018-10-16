//
//  PDNavigationBar.h
//  pandora
//
//  Created by Albert Lee on 2/24/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALNavigationBar : UINavigationBar
@property (nonatomic, strong) CALayer *colorLayer;
- (void)setBarTintColor:(UIColor *)barTintColor;
@end
