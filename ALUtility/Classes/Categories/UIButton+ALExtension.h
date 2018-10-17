//
//  UIButton+ALExtension.h
//  ALExtension
//
//  Created by Albert Lee on 8/25/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ALExtension)
@property (nonatomic, strong)NSString *tagString;
@property (nonatomic, strong)UIImageView *customImageView;
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)UILabel *lblCustom;
@property (nonatomic, strong)UILabel *lblCustom2;
@property (nonatomic, assign)UIEdgeInsets hitTestEdgeInsets; //用于扩大按钮的点击范围, 外部调用时生效

- (void)arrangeCustomSubviewToCenterWithGap:(CGFloat)gap;
- (void)arrangeCustomSubviewToCenterWithGap:(CGFloat)gap left:(CGFloat)left;
- (void)setImage:(UIImage *)image
            text:(NSString *)text
    textColorHex:(UInt32)textColorHex
        fontSize:(NSInteger)fontSize
             gap:(CGFloat)gap;
- (void)setImage:(UIImage *)image text:(NSString *)text textColorHex:(UInt32)textColorHex fontSize:(NSInteger)fontSize;
@end
