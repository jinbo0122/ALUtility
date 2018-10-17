//
//  ALPhotoListFullView.m
//  ALExtension
//
//  Created by Albert Lee on 7/13/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import "ALPhotoListFullView.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>
#import "ALUtility.h"
#import "UIView+ALExtension.h"
#import "UIColor+ALExtension.h"
#import "NSArray+ALExtension.h"
#import "ALButtonItem.h"
#import "PDProgressHUD.h"
#import "PDProgressHUD+ALExtension.h"
#import "UIAlertController+ALExtension.h"
#import "UIImage+ALExtension.h"
#import <SDWebImage/UIImageView+WebCache.h>
@protocol ALZoomScrollViewDelegate;
@interface ALZoomScrollView : UIScrollView<UIActionSheetDelegate>
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic,   weak)id<ALZoomScrollViewDelegate>zoomScrollviewDelegate;
@property(nonatomic, strong)UITapGestureRecognizer * doubleTapGesture;
@property(nonatomic)BOOL isZoomedToFullScreen;
@end


@protocol ALZoomScrollViewDelegate <NSObject>
- (void)zoomScrollviewSavePhotoToLocalAlbumSucceed;
- (void)zoomScrollviewSavePhotoToLocalAlbumFailed;
@end



@implementation ALZoomScrollView

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = NO;
    [self addSubview:_imageView];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.contentSize = self.bounds.size;
    
    //lh++ 长按保存到相册
    UILongPressGestureRecognizer *pressLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressLongGestureAction:)];
    [self addGestureRecognizer:pressLongGesture];
    
    //lh++ 双击放大到全屏
    _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTapGestureAction)];
    _doubleTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleTapGesture];
    
    
  }
  return self;
}
-(void)imageViewPressLongGestureAction:(UILongPressGestureRecognizer*)longPress{
  if (longPress.state == UIGestureRecognizerStateBegan) {
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *bundleDisplayName = [info objectForKey:@"CFBundleDisplayName"];
    __weak typeof(self)wSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片到手机相册"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                                
                                              }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                [wSelf.imageView.image saveToAlbum:bundleDisplayName
                                                                    competionBlock:^{
                                                                      if (wSelf.zoomScrollviewDelegate && [wSelf.delegate respondsToSelector:@selector(zoomScrollviewSavePhotoToLocalAlbumSucceed)]) {
                                                                        [wSelf.zoomScrollviewDelegate zoomScrollviewSavePhotoToLocalAlbumSucceed];
                                                                      }
                                                                    } failedBlock:^{
                                                                      if (wSelf.zoomScrollviewDelegate && [wSelf.delegate respondsToSelector:@selector(zoomScrollviewSavePhotoToLocalAlbumFailed)]) {
                                                                        [wSelf.zoomScrollviewDelegate zoomScrollviewSavePhotoToLocalAlbumFailed];
                                                                      }
                                                                    }];
                                              }]];
    [alert show];
  }
}

- (void)imageViewDoubleTapGestureAction
{
  CGFloat imageWidth = CGImageGetWidth(_imageView.image.CGImage);
  CGFloat imageHeight = CGImageGetHeight(_imageView.image.CGImage);
  CGFloat zoomScale = (UIScreenWidth/UIScreenHeight)/(imageWidth/imageHeight);
  CGFloat zoomScaleRelative= zoomScale>1?zoomScale:(1/zoomScale);
  if (imageWidth/imageHeight != UIScreenWidth/UIScreenHeight && _isZoomedToFullScreen == NO) {
    _isZoomedToFullScreen = YES;
    [self setZoomScale:zoomScaleRelative animated:YES];
  }else if(_isZoomedToFullScreen == YES){
    _isZoomedToFullScreen = NO;
    [self setZoomScale:1/zoomScaleRelative animated:YES];
  }
}

@end


@interface ALPhotoListFullView()<UIScrollViewDelegate,ALZoomScrollViewDelegate>
@property(nonatomic, strong)UIScrollView    *scrollView;
@property(nonatomic, strong)UIPageControl   *pageControl;
@property(nonatomic, strong)NSArray         *photoList;
@property(nonatomic, strong)UITapGestureRecognizer *tapGesture;

@property(nonatomic, strong)NSArray         *originFrames;

@end

@implementation ALPhotoListFullView
- (id)initWithFrames:(NSArray *)frames photoList:(NSArray *)photoList index:(NSInteger)index{
  if(self = [super initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0x282828 alpha:0.7];
    //点击退出
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(dismissFullScreen)];
    [self addGestureRecognizer:_tapGesture];
    
    self.originFrames = [frames copy];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.clipsToBounds = NO;
    _scrollView.decelerationRate = 0.0;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(UIScreenWidth*photoList.count, UIScreenHeight);
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.pagingEnabled = YES;
    [_scrollView setZoomScale:1.0];
    [self addSubview:_scrollView];
    [_scrollView setContentOffset:CGPointMake(UIScreenWidth*index, 0)];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height-50, UIScreenWidth, 50)];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRGBHex:0x323332];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRGBHex:0xffffff];
    _pageControl.numberOfPages = photoList.count;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPage = index;
    _pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:_pageControl];
    
    
    for (NSInteger i=0; i<photoList.count; i++) {
      CGRect frame = [[self.originFrames safeObjectAtIndex:i] CGRectValue];
      ALZoomScrollView *zoomImageView = [[ALZoomScrollView alloc] initWithFrame:CGRectMake(UIScreenWidth*i, 0, UIScreenWidth, UIScreenHeight)];
      zoomImageView.imageView.frame = frame;
      zoomImageView.tag = i;
      zoomImageView.delegate = self;
      zoomImageView.zoomScrollviewDelegate = self;
      [self.scrollView addSubview:zoomImageView];
      __block PDProgressHUD *hud;
      zoomImageView.maximumZoomScale = 3.0;
      zoomImageView.minimumZoomScale = 1.0;
      zoomImageView.zoomScale = 1.0;
      NSString *photoUrl = [photoList safeObjectAtIndex:i];
      if ([photoUrl rangeOfString:@"http"].location != NSNotFound) {
        [zoomImageView.imageView sd_setImageWithURL:[[photoList safeStringObjectAtIndex:i] urlWithSuffix:ALWifiImageAvatarBig]
                                          completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                            [hud hide:YES];
                                          }];
      }else{
        zoomImageView.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:photoUrl]];
      }
      
      __weak typeof(self)wSelf = self;
      __weak typeof(zoomImageView)wZoomImageView = zoomImageView;
      [UIView animateWithDuration:0.3 delay:0
                          options:UIViewAnimationOptionCurveEaseInOut
                       animations:^{
                         wZoomImageView.imageView.frame = zoomImageView.bounds;
                         wSelf.backgroundColor = [UIColor blackColor];
                       }
                       completion:^(BOOL finished) {
                         hud = [PDProgressHUD showLoadingInView:wZoomImageView.imageView];
                         if (wZoomImageView.imageView.image) {
                           [hud hide:NO];
                         }
                       }];
      
      [_tapGesture requireGestureRecognizerToFail:zoomImageView.doubleTapGesture];
      
    }
  }
  return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
  if ([scrollView isKindOfClass:[ALZoomScrollView class]]) {
    return [(ALZoomScrollView *)scrollView imageView];
  }
  return nil;
}



- (void)dismissFullScreen{
  __weak typeof(self)wSelf = self;
  NSInteger index = wSelf.scrollView.contentOffset.x/UIScreenWidth;
  for (ALZoomScrollView *zoomImageView in [self.scrollView subviews]) {
    if ([zoomImageView isKindOfClass:[ALZoomScrollView class]]&&
        zoomImageView.tag!=index) {
      [zoomImageView removeFromSuperview];
    }else{
      __weak typeof(zoomImageView)wZoomImageView = zoomImageView;
      [UIView animateWithDuration:0.2
                       animations:^{
                         wZoomImageView.zoomScale = 1.0;
                       }];
    }
  }
  CGRect frame = [[wSelf.originFrames safeObjectAtIndex:index] CGRectValue];
  [UIView animateWithDuration:0.2
                        delay:0.2f
                      options:(UIViewAnimationOptionCurveEaseInOut)
                   animations:^{
                     wSelf.pageControl.alpha = 0;
                     wSelf.scrollView.delegate = nil;
                     for (ALZoomScrollView *zoomImageView in [self.scrollView subviews]) {
                       if ([zoomImageView isKindOfClass:[ALZoomScrollView class]]&&
                           zoomImageView.tag==index) {
                         zoomImageView.imageView.frame = frame;
                       }
                     }
                     wSelf.backgroundColor = [UIColor clearColor];
                   }
                   completion:^(BOOL finished){
                     [wSelf removeFromSuperview];
                   }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat pageWidth = self.scrollView.frame.size.width;
  float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
  NSInteger page = lround(fractionalPage);
  self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  if (![scrollView isKindOfClass:[ALZoomScrollView class]]) {
    for (ALZoomScrollView *zoomView in scrollView.subviews) {
      if ([zoomView isKindOfClass:[ALZoomScrollView class]]) {
        zoomView.zoomScale = 1.0;
      }
    }
  }
}

#pragma mark - ALZoomScrollViewDelegate
- (void)zoomScrollviewSavePhotoToLocalAlbumSucceed{
  __weak typeof(self)wSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(savePhotoTolocalAlbumSucceed:)]) {
      [wSelf.delegate savePhotoTolocalAlbumSucceed:wSelf];
    }
  });
  
}
- (void)zoomScrollviewSavePhotoToLocalAlbumFailed{
  __weak typeof(self)wSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(savePhotoTolocalAlbumFailed:)]) {
      [wSelf.delegate savePhotoTolocalAlbumFailed:wSelf];
    }
  });
  
  
}

- (void)dealloc{
  
}
@end
