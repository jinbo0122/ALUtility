//
//  UIView+IDPExtension.m
//  FMFramework
//
//  Created by 李 东江 on 12-11-14.
//  Copyright (c) 2012年 Ifely. All rights reserved.
//

#import "UIView+ALExtension.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UIColor+ALExtension.h"
#define kAnimationDidStopNotification              @"kAnimationDidStopNotification"

#define kAnimationDidStartNotification              @"kAnimationDidStartNotification"

NSString *const kFTAnimationFlyOut = @"kFTAnimationFlyOut";
NSString *const kFTAnimationTypeOut = @"kFTAnimationTypeOut";
NSString *const kFTAnimationTargetViewKey = @"kFTAnimationTargetViewKey";
NSString *const kFTAnimationCallerDelegateKey = @"kFTAnimationCallerDelegateKey";
NSString *const kFTAnimationCallerStartSelectorKey = @"kFTAnimationCallerStartSelectorKey";
NSString *const kFTAnimationCallerStopSelectorKey = @"kFTAnimationCallerStopSelectorKey";
NSString *const kFTAnimationName = @"kFTAnimationName";
NSString *const kFTAnimationType = @"kFTAnimationType";

static char UIViewCustomTag;

@implementation UIView (ALExtension)
- (void     )setBgWithColors:(NSArray *)colors direction:(UIViewBackgroundGradientColorDirection)direction{
  CAGradientLayer *theViewGradient = [CAGradientLayer layer];
  theViewGradient.colors = colors;
  theViewGradient.frame = self.bounds;
  if (direction == UIViewBackgroundGradientColorDirectionLeftToRight) {
    theViewGradient.startPoint = CGPointMake(0.0, 0.5);
    theViewGradient.endPoint = CGPointMake(1.0, 0.5);
  }
  
  BOOL isReplaced = NO;
  for (CAGradientLayer *layer in [self.layer sublayers]) {
    if ([layer isKindOfClass:[CAGradientLayer class]]) {
      [self.layer replaceSublayer:layer with:theViewGradient];
      isReplaced = YES;
    }
  }
  if (!isReplaced) {
    [self.layer insertSublayer:theViewGradient atIndex:0];
  }
}

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    
    return kNilOptions;
}

//view searching

- (UIView *)viewMatchingPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return self;
    }
    for (UIView *view in self.subviews)
    {
        UIView *match = [view viewMatchingPredicate:predicate];
        if (match) return match;
    }
    return nil;
}

- (UIView *)viewWithTag:(NSInteger)tag type:(Class)type
{
    return [self viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *evaluatedObject, NSDictionary *bindings)
                                        {
                                            return [evaluatedObject tag] == tag && [evaluatedObject isKindOfClass:type];
                                        }]];
}

- (UIView *)viewOfType:(Class)type
{
    return [self viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                                        {
                                            return [evaluatedObject isKindOfClass:type];
                                        }]];
}

- (NSArray *)viewsMatchingPredicate:(NSPredicate *)predicate
{
    NSMutableArray *matches = [NSMutableArray array];
    if ([predicate evaluateWithObject:self])
    {
        [matches addObject:self];
    }
    for (UIView *view in self.subviews)
    {
        //check for subviews
        //avoid creating unnecessary array
        if ([view.subviews count])
        {
        	[matches addObjectsFromArray:[view viewsMatchingPredicate:predicate]];
        }
        else if ([predicate evaluateWithObject:view])
        {
            [matches addObject:view];
        }
    }
    return matches;
}

- (NSArray *)viewsWithTag:(NSInteger)tag
{
    return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *evaluatedObject, NSDictionary *bindings)
                                         {
                                             return [evaluatedObject tag] == tag;
                                         }]];
}

- (NSArray *)viewsWithTag:(NSInteger)tag type:(Class)type
{
    return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *evaluatedObject, NSDictionary *bindings)
                                         {
                                             return [evaluatedObject tag] == tag && [evaluatedObject isKindOfClass:type];
                                         }]];
}

- (NSArray *)viewsOfType:(Class)type
{
    return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                                         {
                                             return [evaluatedObject isKindOfClass:type];
                                         }]];
}

- (UIView *)showVoiceWave:(CGFloat)width sex:(NSString *)sex{
  UIView *waveView = [[UIView alloc] initWithFrame:self.frame];
  waveView.backgroundColor = sex.integerValue == 1? [UIColor colorWithRGBHex:0x72bbf5]:[UIColor colorWithRGBHex:0xff6bb8];
  waveView.layer.masksToBounds = YES;
  waveView.layer.cornerRadius = waveView.width/2.0;
  
  if (self.superview) {
    [self.superview addSubview:waveView];
    [self.superview sendSubviewToBack:waveView];
  }

  CGPoint center = waveView.center;
  CGFloat times  = (self.width+width)/self.width;
  __weak typeof(waveView)view = waveView;
  [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat
                   animations:^{
                     view.alpha = 0.0;
                     view.center = center;
                     view.transform = CGAffineTransformScale(CGAffineTransformIdentity, times, times);
                   } completion:^(BOOL finished) {
                   }];

  
  return waveView;
}

- (UIView *)addWave:(CGFloat)width{
  UIView *waveView = [[UIView alloc] initWithFrame:self.frame];
  waveView.backgroundColor = [UIColor whiteColor];
  waveView.layer.masksToBounds = YES;
  waveView.layer.cornerRadius = waveView.width/2.0;
  if (self.superview) {
    [self.superview addSubview:waveView];
    [self.superview bringSubviewToFront:self];
  }
  
  CGPoint center = waveView.center;
  CGFloat times  = (self.width+width)/self.width;
  __weak typeof(waveView)view = waveView;
  [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionRepeat
                   animations:^{
                     view.alpha = 0.0;
                     view.center = center;
                     view.transform = CGAffineTransformScale(CGAffineTransformIdentity, times, times);
                   } completion:^(BOOL finished) {
                   }];
  return waveView;
}

- (void)animationWithWave:(CGFloat)width{
  CGPoint center = self.center;
  CGFloat times  = (self.width+width)/self.width;
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionRepeat
                   animations:^{
                     wSelf.alpha = 0.0;
                     wSelf.center = center;
                     wSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, times, times);
                   } completion:^(BOOL finished) {
                   }];
}

- (void     )arrangeTopToCenterWithInHeight:(CGFloat)height{
  self.top = (height - self.height)/2.0;
}

//first responder

- (UIView *)firstResponder
{
    return [self viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                                        {
                                            return [evaluatedObject isFirstResponder];
                                        }]];
}

//frame accessors

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.left + self.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.top + self.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.center.x;
}

- (void)setX:(CGFloat)x
{
    self.center = CGPointMake(x, self.center.y);
}

- (CGFloat)y
{
    return self.center.y;
}

- (void)setY:(CGFloat)y
{
    self.center = CGPointMake(self.center.x, y);
}

- (CGFloat)centerX{
  return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
  self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY{
  return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
  self.center = CGPointMake(self.center.x, centerY);
}

//bounds accessors

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)size
{
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

- (CGFloat)boundsWidth
{
    return self.boundsSize.width;
}

- (void)setBoundsWidth:(CGFloat)width
{
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (CGFloat)boundsHeight
{
    return self.boundsSize.height;
}

- (void)setBoundsHeight:(CGFloat)height
{
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}

//content getters

- (CGRect)contentBounds
{
    return CGRectMake(0.0f, 0.0f, self.boundsWidth, self.boundsHeight);
}

- (CGPoint)contentCenter
{
    return CGPointMake(self.boundsWidth/2.0f, self.boundsHeight/2.0f);
}

- (NSNumber *)customTag{
  return objc_getAssociatedObject(self, &UIViewCustomTag);
}

- (void)setCustomTag:(NSNumber *)customTag{
  objc_setAssociatedObject(self, &UIViewCustomTag, customTag, OBJC_ASSOCIATION_ASSIGN);
}




-(void)removeWithTransition:(UIViewAnimationTransition)transition duration:(float)duration {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationTransition:transition forView:self.superview cache:YES];
    
	[self removeFromSuperview];
    
	[UIView commitAnimations];
}

- (void)addSubview:(UIView *)view withTransition:(UIViewAnimationTransition)transition duration:(float)duration {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationTransition:transition forView:self cache:YES];
    
	[self addSubview:view];
    
	[UIView commitAnimations];
}

- (void)setFrame:(CGRect)frame duration:(float)duration {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
    
	self.frame = frame;
    
	[UIView commitAnimations];
}

- (void)setAlpha:(float)alpha duration:(float)duration {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
    
	self.alpha = alpha;
    
	[UIView commitAnimations];
}

//===========================================================
#pragma mark -
#pragma mark Rounded Corners
//===========================================================

- (void)setCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
	CALayer *l = [self layer];
    
	l.masksToBounds = YES;
	l.cornerRadius = cornerRadius;
	l.borderWidth = borderWidth;
	l.borderColor = [borderColor CGColor];
}

//===========================================================
#pragma mark -
#pragma mark Shadows
//===========================================================

- (void)setShadowOffset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity {
	self.layer.masksToBounds = NO;
	self.layer.shadowOffset = offset;
	self.layer.shadowRadius = radius;
	self.layer.shadowOpacity = opacity;
}

//===========================================================
#pragma mark -
#pragma mark Gradient Background
//===========================================================

- (void)setGradientBackgroundWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
	CAGradientLayer *gradient = [CAGradientLayer layer];
    
	gradient.frame = self.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
    
	[self.layer insertSublayer:gradient atIndex:0];
}

-(UIImage*)getViewScreenImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*  viewImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

-(void)animationDidStop:(BOOL)flag
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAnimationDidStopNotification object:[NSNumber numberWithBool:flag]];
}

-(void)animationDidStart
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAnimationDidStartNotification object:nil];
}

- (UITapGestureRecognizer *)addTapGestureWithTarget:(id)target selector:(SEL)selector
{
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
  tap.delegate = target;
  [self addGestureRecognizer:tap];
  return tap;
  
}

- (UIPanGestureRecognizer *)addPanGestureWithTarget:(id)target selector:(SEL)selector
{
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:selector];
  [self addGestureRecognizer:pan];
  return pan;
}

- (UILongPressGestureRecognizer *)addLongPressGestureWithTarget:(id)target selector:(SEL)selector
{
  UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
  [self addGestureRecognizer:press];
  return press;
}

- (void)removeAllGesture{
  for (UIGestureRecognizer* gesture in self.gestureRecognizers) {
    gesture.delegate = nil ;
    gesture.enabled = NO;
  }
}


@end
