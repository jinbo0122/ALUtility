//
//  ALLineView.h
//  ALExtension
//
//  Created by Albert Lee on 10/9/15.
//  Copyright © 2015 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALLineView : UIView
+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex;
+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex alpha:(CGFloat)alpha;
+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex cornerRadius:(CGFloat)cornerRadius;
+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex layerRadius:(CGFloat)layerRadius;
+ (ALLineView *)lineWithFrame:(CGRect)frame colorHex:(UInt32)colorHex alpha:(CGFloat)alpha cornerRadius:(CGFloat)cornerRadius;
@end
