//
//  ALZoomRotateImageView.m
//  ALExtension
//
//  Created by Albert Lee on 3/23/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import "ALZoomRotateImageView.h"
#import "UIView+ALExtension.h"
#define GAP_BORDER_TO_FRAME 20
#define MINIMUM_RADIUS 25

@interface ALZoomRotateImageView()
@property(nonatomic, strong)UIPanGestureRecognizer *panGesture;
@property(nonatomic, strong)UIPanGestureRecognizer *cornerPanGesture;
@property(nonatomic, strong)UITapGestureRecognizer *closeTapGesture;
@property(nonatomic, strong)UITapGestureRecognizer *imageTapGesure;
@property(nonatomic, assign)CGAffineTransform       transformOld;
@property(nonatomic, assign)CGAffineTransform       transformOldFrame;
@property(nonatomic, assign)CGPoint                 oldCornerCenter;
@property(nonatomic, assign)CGFloat                 oldRadius;
@property(nonatomic, assign)CGFloat                 angleOld;
@property(nonatomic, assign)CGPoint                 viewCenter;
@property(nonatomic, assign)CGFloat                 mMaxScale;
@property(nonatomic, assign)CGFloat                 mOriRadius;
@property(nonatomic, assign)CGFloat                 mNewScale;
@property(nonatomic, assign)CGPoint                 mLocation;
@property(nonatomic, assign)CGFloat                 mNewAngle;
@end

@implementation ALZoomRotateImageView
- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
//    self.layer.borderWidth = 1.0;
//    self.layer.borderColor = [[UIColor redColor] CGColor];
    
    self.frameView = [[UIView alloc] initWithFrame:CGRectMake(GAP_BORDER_TO_FRAME, GAP_BORDER_TO_FRAME,
                                                              self.width-GAP_BORDER_TO_FRAME*2+2,
                                                              self.height-GAP_BORDER_TO_FRAME*2+2)];
    self.frameView.layer.masksToBounds = YES;
    self.frameView.layer.borderColor = [UIColor clearColor].CGColor;//[[UIColor colorWithWhite:1 alpha:0.8] CGColor];
    self.frameView.layer.borderWidth = 1.5;
    
    [self addSubview:self.frameView];
    
    self.stickerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frameView.width-10, self.frameView.height-10)];
    self.stickerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.frameView addSubview:self.stickerImageView];
    
//    self.stickerImageView.backgroundColor = [UIColor colorWithRGBHex:0x00ff00 alpha:0.5];
    
    /////////关闭按钮///////////
    self.cornerCloseView = [[ALReceiveHitTestSubView alloc] initWithFrame:CGRectMake(0, 0,GAP_BORDER_TO_FRAME*2, GAP_BORDER_TO_FRAME*2)];
    [self addSubview:self.cornerCloseView];
    
    self.cornerCloseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 38, 38)];
    [self.cornerCloseView addSubview:self.cornerCloseImageView];
    self.cornerCloseImageView.userInteractionEnabled = YES;
    
    /////////旋转按钮///////////
    self.cornerRotateView = [[ALReceiveHitTestSubView alloc] initWithFrame:CGRectMake(self.width-GAP_BORDER_TO_FRAME*2, self.height-GAP_BORDER_TO_FRAME*2,
                                                                                      GAP_BORDER_TO_FRAME*2, GAP_BORDER_TO_FRAME*2)];
    [self addSubview:self.cornerRotateView];
    
    self.cornerRotateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 38, 38)];
    [self.cornerRotateView addSubview:self.cornerRotateImageView];
    self.cornerRotateImageView.userInteractionEnabled = YES;
    
    self.cornerPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.cornerRotateView addGestureRecognizer:self.cornerPanGesture];
    
    self.closeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [self.cornerCloseView addGestureRecognizer:self.closeTapGesture];
    
    self.imageTapGesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTapped:)];
    [self.frameView addGestureRecognizer:self.imageTapGesure];
    
    //Gesture
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImageView:)];
    [self.frameView addGestureRecognizer:self.panGesture];
    
    self.mMaxScale = 0;
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImageView:)];
    self.pinchGesture.delaysTouchesEnded = NO;
    
  }
  return self;
}

- (void)onImageTapped:(UITapGestureRecognizer *)gesture{
  if ([[[self.superview subviews] lastObject] isEqual:self]) {
    [self setFrameBorderHidden];
  }else{
    [self.superview bringSubviewToFront:self];
    [self setFrameBorderHiddenToNO];
    
    for (UIView *view in [self.superview subviews]) {
      if ([view isKindOfClass:[ALZoomRotateImageView class]]&&
          ![view isEqual:self]) {
        [((ALZoomRotateImageView*)view) setFrameBorderHiddenToYES];
      }
    }
  }
}

- (void)moveImageView:(UIPanGestureRecognizer *)panGestureRecognizer{
  if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
    CGPoint translation = [panGestureRecognizer translationInView:[self superview]];
    //self.mLocation = [panGestureRecognizer locationInView:[self superview]];
    [self setCenter:CGPointMake([self center].x + translation.x, [self center].y + translation.y)];
    self.mLocation = [self center];
    [panGestureRecognizer setTranslation:CGPointZero inView:[self superview]];
  }
}

- (CGPoint) getViewLocation{
  return self.mLocation;
}

- (CGFloat) getViewScale{
  return self.mNewScale;
}

- (CGFloat) getViewAngle{
  return self.mNewAngle;
}

- (void) updateFaceInfo:(CGPoint)location scale:(CGFloat)scale angle:(CGFloat)angle{
  if (angle == 0 && scale == 0) {
    return;
  }
  CGAffineTransform t;
  t = CGAffineTransformMakeRotation(angle);
  
  if (scale > 0) {
    t = CGAffineTransformScale(t, scale, scale);
  }
  self.transform = t;
}

- (void)setFrameBorderHidden{
  BOOL hidden = self.cornerRotateView.hidden;
  hidden = !hidden;
  
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.2
                   animations:^{
                     if (hidden) {
                       wSelf.cornerRotateView.hidden = YES;
                       wSelf.cornerCloseView.hidden = YES;
                       wSelf.frameView.layer.borderWidth = 0;
                     }
                     else{
                       wSelf.cornerRotateView.hidden = NO;
                       wSelf.cornerCloseView.hidden = NO;
                       wSelf.frameView.layer.borderWidth = 1.5;
                     }
                   }];
}

- (void)setFrameBorderHiddenToYES{
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.2
                   animations:^{
                     wSelf.cornerCloseView.hidden = YES;
                     wSelf.cornerRotateView.hidden = YES;
                     wSelf.frameView.layer.borderWidth = 0;
                   }];
}

- (void)setFrameBorderHiddenToNO{
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.2
                   animations:^{
                     wSelf.cornerRotateView.hidden = NO;
                     wSelf.cornerCloseView.hidden = NO;
                     wSelf.frameView.layer.borderWidth = 1.5;
                   }];
}

- (void)setInitialAngle:(CGFloat)angle radius:(CGFloat)radius{
  self.transformOldFrame = self.frameView.transform; //保存转动开始时的中心，半径，及旋转按钮的点
  self.transformOld = self.transform; //保存转动开始时的中心，半径，及旋转按钮的点
  self.viewCenter = self.center;
  self.oldCornerCenter = [self convertRect:self.cornerRotateView.frame toView:self.superview].origin;
  self.oldRadius = 100;
  self.angleOld = 0;
  
  //获取应旋转的角度，及放大的倍数
  CGFloat scale = radius/100;
  CGAffineTransform transform = self.transformOldFrame;
  transform = CGAffineTransformScale(transform, scale, scale);
  self.frameView.transform = transform;
  
  
  CGAffineTransform transformA = self.transformOld;
  transformA = CGAffineTransformRotate(transformA, angle);
  
  self.transform = transformA;
  
  self.cornerRotateView.center = CGPointMake(self.frameView.right-1, self.frameView.bottom-1);
  self.cornerCloseView.center = CGPointMake(self.frameView.left, self.frameView.top);
  
  
  self.transformOldFrame = self.frameView.transform;
  self.transformOld = self.transform;
  self.oldRadius    = radius;
  self.angleOld     = angle;
  self.viewCenter   = self.center;
  self.oldCornerCenter = [self convertRect:self.cornerRotateView.frame toView:self.superview].origin;
}

- (void)closeView:(UITapGestureRecognizer *)tapGesture{
  self.hidden = YES;
  [[NSNotificationCenter defaultCenter] postNotificationName:ALNotificationZoomRotateImageViewHidden
                                                      object:nil];
}

- (void)panView:(UIPanGestureRecognizer *)gesture{
  if (gesture.state == UIGestureRecognizerStateBegan){
    self.transformOldFrame = self.frameView.transform; //保存转动开始时的中心，半径，及旋转按钮的点
    self.transformOld = self.transform; //保存转动开始时的中心，半径，及旋转按钮的点
    self.viewCenter = self.center;
    self.oldCornerCenter = [self convertRect:self.cornerRotateView.frame toView:self.superview].origin;
    CGFloat xDistOld = (self.oldCornerCenter.x - self.viewCenter.x);
    CGFloat yDistOld = (self.oldCornerCenter.y - self.viewCenter.y);
    self.oldRadius = sqrt((xDistOld * xDistOld) + (yDistOld * yDistOld));
    self.angleOld = atan2(self.oldCornerCenter.y - self.viewCenter.y, self.oldCornerCenter.x - self.viewCenter.x);
    if (self.mOriRadius == 0) {
      self.mOriRadius = self.oldRadius;
    }
  }
  else if(gesture.state == UIGestureRecognizerStateChanged) {
    //计算转动之后的中心，半径，及旋转按钮的点
    CGPoint translation = [gesture translationInView:[self superview]];
    CGPoint newCornerCenter = CGPointMake(self.oldCornerCenter.x+translation.x, self.oldCornerCenter.y+translation.y);
    CGFloat xDistNew = (newCornerCenter.x - self.viewCenter.x);
    CGFloat yDistNew = (newCornerCenter.y - self.viewCenter.y);
    CGFloat newRadius = sqrt((xDistNew * xDistNew) + (yDistNew * yDistNew));
    //    CGFloat newRadius = MAX(MINIMUM_RADIUS, sqrt((xDistNew * xDistNew) + (yDistNew * yDistNew)));//最小半径25
    CGFloat angleNew = atan2(newCornerCenter.y - self.viewCenter.y, newCornerCenter.x - self.viewCenter.x);
    
    //获取应旋转的角度，及放大的倍数
    CGFloat scale = newRadius/self.oldRadius;
    CGFloat angle = angleNew - self.angleOld;
    
    if (self.mMaxScale > 0 && scale > self.mMaxScale) {
      scale = self.mMaxScale;
    }
    if (self.mMaxScale > 0 && newRadius/self.mOriRadius > self.mMaxScale) {
      return;
    }
    
    self.mNewScale = scale;
    self.mNewAngle = angle;
    CGAffineTransform transform = self.transformOldFrame;
    transform = CGAffineTransformScale(transform, scale, scale);
    self.frameView.transform = transform;
    
    CGAffineTransform transformA = self.transformOld;
    transformA = CGAffineTransformRotate(transformA, angle);
    
    self.transform = transformA;
    
    self.cornerRotateView.center = CGPointMake(self.frameView.right-1, self.frameView.bottom-1);
    self.cornerCloseView.center = CGPointMake(self.frameView.left, self.frameView.top);
    
  }
}

- (void) setMaxScale:(CGFloat)scale{
  self.mMaxScale = scale;
}

- (void)pinchImageView:(UIPinchGestureRecognizer *)gesture{
  if (gesture.state == UIGestureRecognizerStateBegan){
    self.transformOldFrame = self.frameView.transform; //保存转动开始时的中心，半径，及旋转按钮的点
    self.viewCenter = self.center;
    self.oldCornerCenter = [self convertRect:self.cornerRotateView.frame toView:self.superview].origin;
    [self setFrameBorderHiddenToNO];
  }
  else if(gesture.state == UIGestureRecognizerStateChanged) {
    CGFloat scale = gesture.scale;
    
    self.mNewScale = scale;
    CGAffineTransform transform = self.transformOldFrame;
    transform = CGAffineTransformScale(transform, scale, scale);
    self.frameView.transform = transform;
    
    self.cornerRotateView.center = CGPointMake(self.frameView.right-1, self.frameView.bottom-1);
    self.cornerCloseView.center = CGPointMake(self.frameView.left, self.frameView.top);
    
  }
}

- (void)dealloc{
  
}
@end
