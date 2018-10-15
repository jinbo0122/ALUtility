//
//  KKTitleLabel.h
//  KKShopping
//
//  Created by Albert Lee on 10/14/13.
//  Copyright (c) 2013 KiDulty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALTitleLabel : UILabel
- (id)initWithTitle:(NSString *)titleText color:(UIColor*)color;
- (id)initWithTitle:(NSString *)titleText color:(UIColor*)color fontSize:(CGFloat)fontSize;
- (id)initWithTitle:(NSString *)titleText color:(UIColor *)color boldFontSize:(CGFloat)fontSize;

@end
