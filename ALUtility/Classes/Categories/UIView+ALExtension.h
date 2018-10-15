//
//
//  UIView+IDPExtension.h
//  IDP
//
//  Created by albert on 13-3-6.
//  Copyright (c) 2012年 Baobao. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, UIViewBackgroundGradientColorDirection){
  UIViewBackgroundGradientColorDirectionUpToBottom = 1,
  UIViewBackgroundGradientColorDirectionLeftToRight = 2,
};

@interface UIView (ALExtension)

//view searching

- (UIView  *)viewWithTag:(NSInteger)tag type:(Class)type;
- (UIView  *)viewOfType:(Class)type;
- (NSArray *)viewsWithTag:(NSInteger)tag;
- (NSArray *)viewsWithTag:(NSInteger)tag type:(Class)type;
- (NSArray *)viewsOfType:(Class)type;
- (UIView  *)showVoiceWave:(CGFloat)width sex:(NSString *)sex;
- (UIView  *)addWave:(CGFloat)width;
- (void     )animationWithWave:(CGFloat)width;
- (void     )arrangeTopToCenterWithInHeight:(CGFloat)height;
- (void     )setBgWithColors:(NSArray *)colors direction:(UIViewBackgroundGradientColorDirection)direction;
//frame accessors

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
//bounds accessors

@property (nonatomic, assign) CGSize boundsSize;
@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;

//content getters

@property (nonatomic, readonly) CGRect contentBounds;
@property (nonatomic, readonly) CGPoint contentCenter;


@property (nonatomic, strong)NSNumber *customTag;

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;
// Animate removing a view from its parent
- (void)removeWithTransition:(UIViewAnimationTransition)transition duration:(float)duration;

// Animate adding a subview
- (void)addSubview:(UIView *)view withTransition:(UIViewAnimationTransition)transition duration:(float)duration;

// Animate the changing of a views frame
- (void)setFrame:(CGRect)frame duration:(float)duration;

// Animate changing the alpha of a view
- (void)setAlpha:(float)alpha duration:(float)duration;

#pragma mark -
#pragma mark Rounded Corners
//===========================================================

- (void)setCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

//===========================================================
#pragma mark -
#pragma mark Shadows
//===========================================================

- (void)setShadowOffset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;

//===========================================================
#pragma mark -
#pragma mark Gradient Background
//===========================================================

- (void)setGradientBackgroundWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

-(UIImage*)getViewScreenImage;

- (UITapGestureRecognizer *)addTapGestureWithTarget:(id)target selector:(SEL)selector;
- (UITapGestureRecognizer *)addPanGestureWithTarget:(id)target selector:(SEL)selector;
- (UILongPressGestureRecognizer *)addLongPressGestureWithTarget:(id)target selector:(SEL)selector;
- (void)removeAllGesture;
@end
