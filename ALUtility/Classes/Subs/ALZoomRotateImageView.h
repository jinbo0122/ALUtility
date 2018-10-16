//
//  ALZoomRotateImageView.h
//  ALExtension
//
//  Created by Albert Lee on 3/23/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALReceiveHitTestSubView.h"
#define ALNotificationZoomRotateImageViewHidden @"ALNotificationZoomRotateImageViewHidden"
@interface ALZoomRotateImageView : ALReceiveHitTestSubView
@property(nonatomic, strong)UIPinchGestureRecognizer   *pinchGesture;
@property(nonatomic, strong)UIView                     *frameView;//边框
@property(nonatomic, strong)UIImageView                *stickerImageView;
@property(nonatomic, strong)UIImageView                *cornerRotateImageView;
@property(nonatomic, strong)UIImageView                *cornerCloseImageView;
@property(nonatomic, strong)ALReceiveHitTestSubView    *cornerRotateView;
@property(nonatomic, strong)ALReceiveHitTestSubView    *cornerCloseView;

- (void)setFrameBorderHidden;
- (void)setFrameBorderHiddenToYES;
- (void)setFrameBorderHiddenToNO;
- (void)setInitialAngle:(CGFloat)angle radius:(CGFloat)radius;
// for video
- (void)setMaxScale:(CGFloat)scale;
- (CGPoint)getViewLocation;
- (CGFloat)getViewScale;
- (CGFloat)getViewAngle;
- (void) updateFaceInfo:(CGPoint)location scale:(CGFloat)scale angle:(CGFloat)angle;
@end
