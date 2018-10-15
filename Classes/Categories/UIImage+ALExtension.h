//
//  UIImage+Category.h
//  pandora
//
//  Created by Albert Lee on 1/10/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
@interface UIImage (ALExtension)
- (UIImage *)applyLightEffectWithBlur:(NSInteger)blur;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
+ (UIImage *)imageWithView:(UIView *)view;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (CGFloat  )imageLuminosity;
+ (CGFloat  )imageLuminosityWithColor:(UIColor *)color;
- (NSNumber*)imageAverageColor;
+ (UIColor *)colorFromARGB:(NSNumber *)number;
+ (UIImage*)thumbImage:(NSData*)imageData;
+ (UIImage*)imageNamedNoCache:(NSString *)name;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect;
- (UIImage *)fixOrientation;
- (void)saveToAlbum:(NSString *)album;
- (void)saveToAlbum:(NSString *)album competionBlock:(COMPLETION_BLOCK)block;
- (void)saveToAlbum:(NSString *)album competionBlock:(COMPLETION_BLOCK)block failedBlock:(COMPLETION_BLOCK)failedBlock;
+ (void)saveToAlbum:(NSString *)album
     competionBlock:(COMPLETION_BLOCK)block
        failedBlock:(COMPLETION_BLOCK)failedBlock
              image:(UIImage *)image
           videoUrl:(NSURL *)videoUrl;
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;
+ (void)clearImageMemoryCache;
- (UIImage *)rotate:(UIDeviceOrientation)orientation needMirror:(BOOL)needMirror;
+ (void)setLatestPhotoPreviewFromAlbumWithSender:(UIView *)sender;
+ (UIImage*)imageWithNewSize:(UIImage*)sourceImage scaledToSize:(CGSize)targetSize;
- (UIImage *)imageByAddWaterMark:(UIImage *)image;
+ (UIImage *)takeOneScreenImage;
+ (UIImage *)convertImageToGrayScale:(UIImage *)image;
@end
