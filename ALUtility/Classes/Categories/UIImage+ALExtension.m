//
//  UIImage+Category.m
//  pandora
//
//  Created by Albert Lee on 1/10/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "UIImage+ALExtension.h"
#import <Accelerate/Accelerate.h>
#import <float.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIView+ALExtension.h"
#import "UIDevice-Hardware.h"
@implementation UIImage (ALExtension)
- (UIImage *)applyLightEffectWithBlur:(NSInteger)blur
{
  UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.1];
  return [self applyBlurWithRadius:blur tintColor:tintColor saturationDeltaFactor:1.3 maskImage:nil];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
  // Check pre-conditions.
  if (self.size.width < 1 || self.size.height < 1) {
    NSLog(@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
    return nil;
  }
  if (!self.CGImage) {
    NSLog (@"*** error: image must be backed by a CGImage: %@", self);
    return nil;
  }
  if (maskImage && !maskImage.CGImage) {
    NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
    return nil;
  }
  
  CGRect imageRect = { CGPointZero, self.size };
  UIImage *effectImage = self;
  
  BOOL hasBlur = blurRadius > __FLT_EPSILON__;
  BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
  if (hasBlur || hasSaturationChange) {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -self.size.height);
    CGContextDrawImage(effectInContext, imageRect, self.CGImage);
    
    vImage_Buffer effectInBuffer;
    effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
    effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
    effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
    effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
    vImage_Buffer effectOutBuffer;
    effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
    effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
    effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
    effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
    
    if (hasBlur) {
      CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
      unsigned int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
      if (radius % 2 != 1) {
        radius += 1; // force radius to be odd so that the three box-blur methodology works.
      }
      vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
      vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
      vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    }
    BOOL effectImageBuffersAreSwapped = NO;
    if (hasSaturationChange) {
      CGFloat s = saturationDeltaFactor;
      CGFloat floatingPointSaturationMatrix[] = {
        0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
        0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
        0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
        0,                    0,                    0,  1,
      };
      const int32_t divisor = 256;
      NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
      int16_t saturationMatrix[matrixSize];
      for (NSUInteger i = 0; i < matrixSize; ++i) {
        saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
      }
      if (hasBlur) {
        vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
        effectImageBuffersAreSwapped = YES;
      }
      else {
        vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
      }
    }
    if (!effectImageBuffersAreSwapped)
      effectImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (effectImageBuffersAreSwapped)
      effectImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }
  
  // Set up output context.
  UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
  CGContextRef outputContext = UIGraphicsGetCurrentContext();
  CGContextScaleCTM(outputContext, 1.0, -1.0);
  CGContextTranslateCTM(outputContext, 0, -self.size.height);
  
  // Draw base image.
  CGContextDrawImage(outputContext, imageRect, self.CGImage);
  
  // Draw effect image.
  if (hasBlur) {
    CGContextSaveGState(outputContext);
    if (maskImage) {
      CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
    }
    CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
    CGContextRestoreGState(outputContext);
  }
  
  // Add in color tint.
  if (tintColor) {
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
    CGContextFillRect(outputContext, imageRect);
    CGContextRestoreGState(outputContext);
  }
  
  // Output image is ready.
  UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return outputImage;
}

+ (UIImage *) imageWithView:(UIView *)view
{
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  
  UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return img;
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
  UIGraphicsBeginImageContext(size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, color.CGColor);
  CGContextFillRect(context, (CGRect){.size = size});
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
  return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}

- (CGFloat  )imageLuminosity{
  CGImageRef cgimage = self.CGImage;
  
  size_t width  = CGImageGetWidth(cgimage);
  size_t height = CGImageGetHeight(cgimage);
  
  size_t bpr = CGImageGetBytesPerRow(cgimage);
  size_t bpp = CGImageGetBitsPerPixel(cgimage);
  size_t bpc = CGImageGetBitsPerComponent(cgimage);
  size_t bytes_per_pixel = bpp / bpc;
  
  CGDataProviderRef provider = CGImageGetDataProvider(cgimage);
  NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
  
  double totalLuminance = 0.0;
  const uint8_t* bytes = [data bytes];
  for(size_t row = 0; row < height; row++){
    for(size_t col = 0; col < width; col++){
      const uint8_t* pixel =
      &bytes[row * bpr + col * bytes_per_pixel];
      for(size_t x = 0; x < bytes_per_pixel; x++){
        totalLuminance+=pixel[x]*(x==0?0.299:((x==1)?0.587:0.114));
      }
    }
  }
  totalLuminance /= height*width;
  totalLuminance /= 255.0;
  NSLog(@"Searched image luminance = %f",totalLuminance);
  
  return totalLuminance;
}

+ (CGFloat  )imageLuminosityWithColor:(UIColor *)color{
  CGImageRef cgimage = [UIImage imageWithColor:color size:CGSizeMake(5, 5)].CGImage;
  
  size_t width  = CGImageGetWidth(cgimage);
  size_t height = CGImageGetHeight(cgimage);
  
  size_t bpr = CGImageGetBytesPerRow(cgimage);
  size_t bpp = CGImageGetBitsPerPixel(cgimage);
  size_t bpc = CGImageGetBitsPerComponent(cgimage);
  size_t bytes_per_pixel = bpp / bpc;
  
  CGDataProviderRef provider = CGImageGetDataProvider(cgimage);
  NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
  
  double totalLuminance = 0.0;
  const uint8_t* bytes = [data bytes];
  for(size_t row = 0; row < height; row++){
    for(size_t col = 0; col < width; col++){
      const uint8_t* pixel =
      &bytes[row * bpr + col * bytes_per_pixel];
      for(size_t x = 0; x < bytes_per_pixel; x++){
        totalLuminance+=pixel[x]*(x==0?0.299:((x==1)?0.587:0.114));
      }
    }
  }
  totalLuminance /= height*width;
  totalLuminance /= 255.0;
  NSLog(@"Searched image luminance = %f",totalLuminance);
  
  return totalLuminance;
}


- (NSNumber *)imageAverageColor{
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  unsigned char rgba[4];
  CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  
  CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);
  long long alpha,red,green,blue;
  if(rgba[3] > 0) {
    alpha = ((NSInteger)rgba[3]);
    red = ((NSInteger)rgba[0])*alpha/255.0;
    green = ((NSInteger)rgba[1])*alpha/255.0;
    blue = ((NSInteger)rgba[2])*alpha/255.0;
  }
  else {
    alpha = ((NSInteger)rgba[3]);
    red = ((NSInteger)rgba[0]);
    green = ((NSInteger)rgba[1]);
    blue = ((NSInteger)rgba[2]);
  }
  return [NSNumber numberWithLongLong:(alpha<<24) + (red<<16) + (green << 8) + blue];
  //  if(rgba[3] > 0) {
  //    CGFloat alpha = ((CGFloat)rgba[3])/255.0;
  //    CGFloat multiplier = alpha/255.0;
  //    return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
  //                           green:((CGFloat)rgba[1])*multiplier
  //                            blue:((CGFloat)rgba[2])*multiplier
  //                           alpha:alpha];
  //  }
  //  else {
  //    return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
  //                           green:((CGFloat)rgba[1])/255.0
  //                            blue:((CGFloat)rgba[2])/255.0
  //                           alpha:((CGFloat)rgba[3])/255.0];
  //  }
}

+ (UIColor *)colorFromARGB:(NSNumber *)number{
  long long argb = [number longLongValue];
  long long blue = argb & 0xff;
  long long green = argb >> 8 & 0xff;
  long long red = argb >> 16 & 0xff;
  long long alpha = argb >> 24 & 0xff;
  
  return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha/255.f];
}

+ (UIImage*)thumbImage:(NSData*)imageData{
  UIImage* img = [UIImage imageWithData:imageData];
  CGSize size = CGSizeMake(50, 50*img.size.height/img.size.width);
  UIGraphicsBeginImageContextWithOptions(size, NO, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, 0, size.height);
  CGContextScaleCTM(context, 1, -1);
  CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), [img CGImage]);
  UIImage* img2 = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img2;
}

+ (UIImage*)imageNamedNoCache:(NSString *)name{
  if (!name) {
    return nil;
  }
#ifndef BBSDKMODE
  UIImage *image = [UIImage imageNamed:name];
  if (image) {
    return image;
  }else{
    return [UIImage imageNamed:[name stringByAppendingString:@".jpg"]];
  }
#else
  NSBundle *bundle = [BBLiveSDKUtility bundleForName:@"assets"];
  int scale = 1;
  NSString* finalName = [name copy];
  NSString* secondName = [name copy];
  if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES)
  {
    scale = (int)[[UIScreen mainScreen] scale];
  }
  if (scale>1) {
    finalName = [NSString stringWithFormat:@"%@@%dx",name,scale];
  }
  
  if (scale==3) {
    secondName = [secondName stringByAppendingString:@"@2x"];
  }
  
  //retina 寻找文件
  NSString *filePath = [bundle pathForResource:finalName ofType:@"png"];
  
  if (!filePath) {
    filePath = [bundle pathForResource:finalName ofType:@"jpg"];
  }
  
  if (!filePath) {
    filePath = [bundle pathForResource:secondName ofType:@"png"];
    if (!filePath) {
      filePath = [bundle pathForResource:secondName ofType:@"jpg"];
    }
  }
  
  //如果没有 那寻找正常文件
  if (!filePath) {
    filePath = [bundle pathForResource:name ofType:@"png"];
    if (!filePath) {
      filePath = [bundle pathForResource:name ofType:@"jpg"];
    }
  }
  return [UIImage imageWithContentsOfFile:filePath];
#endif
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
  UIGraphicsBeginImageContext(newSize);
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

+ (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect{
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, image.size.width, image.size.height);
  CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
  [image drawInRect:drawRect];
  UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return croppedImage;
}

+ (UIImage*)imageWithNewSize:(UIImage*)sourceImage scaledToSize:(CGSize)targetSize
{
#define radians( degrees ) ( degrees * M_PI / 180 )
  CGFloat rawWidth = floorf(targetSize.width);
  CGFloat targetWidth;
  CGFloat targetHeight;
  
  CGImageRef imageRef = [sourceImage CGImage];
  if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown ||
      sourceImage.imageOrientation == UIImageOrientationUpMirrored || sourceImage.imageOrientation == UIImageOrientationDownMirrored)
  {
    if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
      targetWidth = CGImageGetWidth(imageRef);
      targetHeight = CGImageGetHeight(imageRef);
    }
    else if (rawWidth>=CGImageGetWidth(imageRef))
    {
      targetWidth = CGImageGetWidth(imageRef);
      targetHeight = CGImageGetHeight(imageRef);
    }
    else
    {
      targetWidth = rawWidth;
      targetHeight = CGImageGetHeight(imageRef)*rawWidth/CGImageGetWidth(imageRef);
    }
  }
  else
  {
    if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
      targetWidth = CGImageGetHeight(imageRef);
      targetHeight = CGImageGetWidth(imageRef);
    }
    else if (rawWidth>=CGImageGetHeight(imageRef))
    {
      targetWidth = CGImageGetHeight(imageRef);
      targetHeight = CGImageGetWidth(imageRef);
    }
    else
    {
      targetWidth = rawWidth;
      targetHeight = CGImageGetWidth(imageRef)*rawWidth/CGImageGetHeight(imageRef);
    }
  }
  ///
  CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little;
  CGColorSpaceRef colorSpaceInfo =CGColorSpaceCreateDeviceRGB();;//CGImageGetColorSpace(imageRef);
  
  CGContextRef bitmap;
  
  if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown ||
      sourceImage.imageOrientation == UIImageOrientationUpMirrored || sourceImage.imageOrientation == UIImageOrientationDownMirrored) {
    
    //bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), (4 * targetWidth), colorSpaceInfo, bitmapInfo);
    
  } else {
    // bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), (4 * targetWidth), colorSpaceInfo, bitmapInfo);
    
  }
  
  CGSize newSize = CGSizeMake(targetWidth, targetHeight);
  CGAffineTransform transform = CGAffineTransformIdentity;
  switch (sourceImage.imageOrientation) {
    case UIImageOrientationDown:           // EXIF = 3
    case UIImageOrientationDownMirrored:   // EXIF = 4
      transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationLeft:           // EXIF = 6
    case UIImageOrientationLeftMirrored:   // EXIF = 5
      transform = CGAffineTransformTranslate(transform, newSize.width, 0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    case UIImageOrientationRight:          // EXIF = 8
    case UIImageOrientationRightMirrored:  // EXIF = 7
      transform = CGAffineTransformTranslate(transform, 0, newSize.height);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;
    default:
      break;
  }
  
  switch (sourceImage.imageOrientation) {
    case UIImageOrientationUpMirrored:     // EXIF = 2
    case UIImageOrientationDownMirrored:   // EXIF = 4
      transform = CGAffineTransformTranslate(transform, newSize.width, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
      
    case UIImageOrientationLeftMirrored:   // EXIF = 5
    case UIImageOrientationRightMirrored:  // EXIF = 7
      transform = CGAffineTransformTranslate(transform, newSize.height, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
    default:
      break;
      
  }
  
  
  CGContextConcatCTM(bitmap, transform);
  
  if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown
      || sourceImage.imageOrientation == UIImageOrientationUpMirrored || sourceImage.imageOrientation == UIImageOrientationDownMirrored) {
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
  } else {
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetHeight, targetWidth), imageRef);
  }
  CGImageRef ref = CGBitmapContextCreateImage(bitmap);
  UIImage* newImage = [UIImage imageWithCGImage:ref];
  CGColorSpaceRelease(colorSpaceInfo);
  
  CGContextRelease(bitmap);
  CGImageRelease(ref);
  
  return newImage;
}

- (UIImage *)fixOrientation{
  return [self fixOrientation:self.imageOrientation];
}

- (UIImage *)fixOrientation:(UIImageOrientation)orient {
  if (orient == UIImageOrientationUp) return self;
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  switch (orient) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.width, 0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, 0, self.size.height);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;
    case UIImageOrientationUp:
    case UIImageOrientationUpMirrored:
      break;
  }
  
  switch (orient) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.width, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
      
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.height, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
    case UIImageOrientationUp:
    case UIImageOrientationDown:
    case UIImageOrientationLeft:
    case UIImageOrientationRight:
      break;
  }
  
  CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                           CGImageGetBitsPerComponent(self.CGImage), 0,
                                           CGImageGetColorSpace(self.CGImage),
                                           CGImageGetBitmapInfo(self.CGImage));
  CGContextConcatCTM(ctx, transform);
  switch (orient) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
      break;
      
    default:
      CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
      break;
  }
  
  CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
  UIImage *img = [UIImage imageWithCGImage:cgimg];
  CGContextRelease(ctx);
  CGImageRelease(cgimg);
  return img;
}

- (void)saveToAlbum:(NSString *)album{
  [self saveToAlbum:album competionBlock:nil failedBlock:nil];
}

- (void)saveToAlbum:(NSString *)album competionBlock:(COMPLETION_BLOCK)block{
  [self saveToAlbum:album competionBlock:block failedBlock:nil];
}

- (void)saveToAlbum:(NSString *)album competionBlock:(COMPLETION_BLOCK)block failedBlock:(COMPLETION_BLOCK)failedBlock{
  [UIImage saveToAlbum:album competionBlock:block failedBlock:failedBlock image:self videoUrl:nil];
}

+ (void)saveToAlbum:(NSString *)album
     competionBlock:(COMPLETION_BLOCK)block
        failedBlock:(COMPLETION_BLOCK)failedBlock
              image:(UIImage *)image
           videoUrl:(NSURL *)videoUrl{
  if ([PHPhotoLibrary authorizationStatus]==PHAuthorizationStatusNotDetermined) {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
      [UIImage saveToAlbum:album competionBlock:block failedBlock:failedBlock image:image videoUrl:videoUrl];
    }];
  }
  else if ([PHPhotoLibrary authorizationStatus]==PHAuthorizationStatusAuthorized ||
           [PHPhotoLibrary authorizationStatus]==PHAuthorizationStatusRestricted){
    __block PHFetchResult *photosAsset;
    __block PHAssetCollection *collection;
    __block PHObjectPlaceholder *placeholder;
    // Find the album
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", album];
    collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                          subtype:PHAssetCollectionSubtypeAny
                                                          options:fetchOptions].firstObject;
    // Create the album
    if (!collection){
      [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *createAlbum = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:album];
        placeholder = [createAlbum placeholderForCreatedAssetCollection];
      } completionHandler:^(BOOL success, NSError *error) {
        if (success){
          PHFetchResult *collectionFetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[placeholder.localIdentifier]
                                                                                                      options:nil];
          collection = collectionFetchResult.firstObject;
          // Save to the album
          [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *assetRequest;
            if (image) {
              assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            }else if (videoUrl){
              assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoUrl];
            }
            placeholder = [assetRequest placeholderForCreatedAsset];
            photosAsset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection
                                                                                                                          assets:photosAsset];
            [albumChangeRequest addAssets:@[placeholder]];
          } completionHandler:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
              if (success){
                if (block) {
                  block();
                }
              }else{
                if (failedBlock) {
                  failedBlock();
                }
              }
            });
          }];
        }else{
          dispatch_async(dispatch_get_main_queue(), ^{
            if (failedBlock) {
              failedBlock();
            }
          });
        }
      }];
    }else{
      // Save to the album
      [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetRequest;
        if (image) {
          assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        }else if (videoUrl){
          assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoUrl];
        }
        placeholder = [assetRequest placeholderForCreatedAsset];
        photosAsset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection
                                                                                                                      assets:photosAsset];
        [albumChangeRequest addAssets:@[placeholder]];
      } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          if (success){
            if (block) {
              block();
            }
          }else{
            if (failedBlock) {
              failedBlock();
            }
          }
        });
        
      }];
    }
  }
}

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
  CGContextScaleCTM(ctx, 1, -1);
  CGContextTranslateCTM(ctx, 0, -area.size.height);
  CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
  CGContextSetAlpha(ctx, alpha);
  CGContextDrawImage(ctx, area, self.CGImage);
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (UIImage *)rotate:(UIDeviceOrientation)orientation needMirror:(BOOL)needMirror{
  UIImageOrientation orient;
  if (orientation==UIDeviceOrientationPortraitUpsideDown) {
    if (needMirror) {
      orient = UIImageOrientationDownMirrored;
    }else{
      orient = UIImageOrientationDown;
    }
  }else if (orientation==UIDeviceOrientationLandscapeLeft) {
    if (needMirror) {
      orient = UIImageOrientationLeftMirrored;
    }else{
      orient = UIImageOrientationLeft;
    }
  }else if (orientation==UIDeviceOrientationLandscapeRight) {
    if (needMirror) {
      orient = UIImageOrientationRightMirrored;
    }else{
      orient = UIImageOrientationRight;
    }
  }else{
    if (needMirror) {
      orient = UIImageOrientationUpMirrored;
    }else{
      orient = UIImageOrientationUp;
    }
  }
  
  return [[self fixOrientation] rotate:orient];
}

static CGRect swapWidthAndHeight(CGRect rect)
{
  CGFloat  swap = rect.size.width;
  
  rect.size.width  = rect.size.height;
  rect.size.height = swap;
  
  return rect;
}

-(UIImage*)rotate:(UIImageOrientation)orient
{
  CGRect             bnds = CGRectZero;
  UIImage*           copy = nil;
  CGContextRef       ctxt = nil;
  CGImageRef         imag = self.CGImage;
  CGRect             rect = CGRectZero;
  CGAffineTransform  tran = CGAffineTransformIdentity;
  
  rect.size.width  = CGImageGetWidth(imag);
  rect.size.height = CGImageGetHeight(imag);
  
  bnds = rect;
  
  switch (orient)
  {
    case UIImageOrientationUp:
      return self;
      
    case UIImageOrientationUpMirrored:
      tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
      tran = CGAffineTransformScale(tran, -1.0, 1.0);
      break;
      
    case UIImageOrientationDown:
      tran = CGAffineTransformMakeTranslation(rect.size.width,
                                              rect.size.height);
      tran = CGAffineTransformRotate(tran, M_PI);
      break;
      
    case UIImageOrientationDownMirrored:
      tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
      tran = CGAffineTransformScale(tran, 1.0, -1.0);
      break;
      
    case UIImageOrientationLeft:
      bnds = swapWidthAndHeight(bnds);
      tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
      tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
      break;
      
    case UIImageOrientationLeftMirrored:
      bnds = swapWidthAndHeight(bnds);
      tran = CGAffineTransformMakeScale(-1.0, 1.0);
      tran = CGAffineTransformRotate(tran, M_PI / 2.0);
      break;
      
    case UIImageOrientationRight:
      bnds = swapWidthAndHeight(bnds);
      tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
      tran = CGAffineTransformRotate(tran, M_PI / 2.0);
      break;
      
    case UIImageOrientationRightMirrored:
      bnds = swapWidthAndHeight(bnds);
      tran = CGAffineTransformMakeTranslation(rect.size.height,
                                              rect.size.width);
      tran = CGAffineTransformScale(tran, -1.0, 1.0);
      tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
      break;
      
    default:
      // orientation value supplied is invalid
      return self;
  }
  
  UIGraphicsBeginImageContext(bnds.size);
  ctxt = UIGraphicsGetCurrentContext();
  
  switch (orient)
  {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      CGContextScaleCTM(ctxt, -1.0, 1.0);
      CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
      break;
      
    default:
      CGContextScaleCTM(ctxt, 1.0, -1.0);
      CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
      break;
  }
  
  CGContextConcatCTM(ctxt, tran);
  CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
  
  copy = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return copy;
}


+ (void)setLatestPhotoPreviewFromAlbumWithSender:(UIView *)sender{
  PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
  fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
  PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
  if(fetchResult.count>0){
    PHAsset *lastAsset = [fetchResult lastObject];
    [[PHImageManager defaultManager] requestImageForAsset:lastAsset
                                               targetSize:sender.size
                                              contentMode:PHImageContentModeAspectFill
                                                  options:NULL
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                if([sender isKindOfClass:[UIImageView class]]){
                                                  [(UIImageView* )sender setImage:result];
                                                }else if ([sender isKindOfClass:[UIButton class]]){
                                                  [(UIButton *)sender setImage:result forState:UIControlStateNormal];
                                                }
                                              });
                                            }];
  }
}

- (UIImage *)imageByAddWaterMark:(UIImage *)image{
  UIGraphicsBeginImageContextWithOptions(self.size, FALSE, 0.0);
  [self drawInRect:CGRectMake( 0, 0, self.size.width, self.size.height)];
  
  CGSize imageSize = CGSizeMake(self.size.width/15.0, image.size.height*self.size.width/(15.0*image.size.width));
  
  [image drawInRect:CGRectMake(self.size.width-(imageSize.width*(is35InchDevice?2.0:1.1)),
                               self.size.height-imageSize.height,imageSize.width,imageSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}


+ (UIImage *)convertImageToGrayScale:(UIImage *)image {
  CIImage *ciImage = [[CIImage alloc] initWithImage:image];
  CIImage *grayscale = [ciImage imageByApplyingFilter:@"CIColorControls"
                                  withInputParameters: @{kCIInputSaturationKey : @0.0}];
  return [UIImage imageWithCIImage:grayscale];
  
}

// 截屏函数
// NOTE: 需要在主线调用
+ (UIImage *)takeOneScreenImage{
  __block UIImage *uiImage = nil;
  
  CVPixelBufferRef pixelBuffer = nil;
  
  const int width = [UIApplication sharedApplication].delegate.window.bounds.size.width;
  const int height = [UIApplication sharedApplication].delegate.window.bounds.size.height;
  
  NSDictionary* pixelBufferOptions = @{ (NSString*) kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
                                        (NSString*) kCVPixelBufferWidthKey : @(width),
                                        (NSString*) kCVPixelBufferHeightKey : @(height),
                                        (NSString*) kCVPixelBufferOpenGLESCompatibilityKey : @YES,
                                        (NSString*) kCVPixelBufferIOSurfacePropertiesKey : @{}};
  
  
  CVPixelBufferCreate(kCFAllocatorDefault,
                      width,
                      height,
                      kCVPixelFormatType_32BGRA,
                      (__bridge CFDictionaryRef)pixelBufferOptions,
                      &pixelBuffer);
  
  
  CVPixelBufferLockBaseAddress(pixelBuffer, 0);
  
  CGContextRef bitmapContext = NULL;
  CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
  
  bitmapContext = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(pixelBuffer),
                                        CVPixelBufferGetWidth(pixelBuffer),
                                        CVPixelBufferGetHeight(pixelBuffer),
                                        8,
                                        CVPixelBufferGetBytesPerRow(pixelBuffer),
                                        rgbColorSpace,
                                        kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst
                                        );
  CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, height);
  CGContextConcatCTM(bitmapContext, flipVertical);
  
  
  // draw each window into the context (other windows include UIKeyboard, UIAlert)
  // FIX: UIKeyboard is currently only rendered correctly in portrait orientation
  UIGraphicsPushContext(bitmapContext); {
    [[UIApplication sharedApplication].delegate.window drawViewHierarchyInRect:CGRectMake(0, 0, width, height) afterScreenUpdates:NO];
  }
  UIGraphicsPopContext();
  
  CGContextRelease(bitmapContext);
  CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
  
  
  CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
  
  CIContext *temporaryContext = [CIContext contextWithOptions:nil];
  CGImageRef videoImage = [temporaryContext
                           createCGImage:ciImage
                           fromRect:CGRectMake(0, 0,
                                               CVPixelBufferGetWidth(pixelBuffer),
                                               CVPixelBufferGetHeight(pixelBuffer))];
  
  uiImage = [UIImage imageWithCGImage:videoImage];
  CGImageRelease(videoImage);
  
  CGColorSpaceRelease(rgbColorSpace);
  
  return uiImage;
}
@end
