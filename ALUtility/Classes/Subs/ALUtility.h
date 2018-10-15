//
//  ALUtility.h
//  ALExtension
//
//  Created by Albert Lee on 11/04/2017.
//  Copyright © 2017 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ALWifiImageHome                 @"!wmid"
#define ALWifiImageAvatar               @"!umid"
#define ALWifiImageAvatarSmall          @"!usmall"
#define ALWifiImageAvatarBig            @"!ubig"
#define ALWifiImageDetail               @"!wbig"
#define ALWifiImageNotification         @"!wsmall"
#define ALWifiImageMessage              @"!imsmall"
#define ALWifiImageMessageBig           @"!imbig"
#define ALWifiImageGroupBg              @"!gbbig"
#define ALNoneWifiImageHome             @"!wmidss"
#define ALNoneWifiImageAvatar           @"!umid"
#define ALNoneWifiImageAvatarSmall      @"!usmall"
#define ALNoneWifiImageAvatarBig        @"!ubigss"
#define ALNoneWifiImageDetail           @"!wbigss"
#define ALNoneWifiImageNotification     @"!wsmall"
#define ALNoneWifiImageMessage          @"!imsmall"
#define ALNoneWifiImageMessageBig       @"!imbigss"
#define ALNoneWifiImageGroupBg          @"!gbbig"

#define isIphoneDevice (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
#define KIpadZoomScale (isIphoneDevice? 1: 1.5)

#define UIScreenWidth  [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIScreenScale  (NSInteger)[UIScreen mainScreen].scale

#define is35InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_35INCH)
#define is4InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_4INCH)
#define is47InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_4_7_INCH)
#define is55InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_5_5_INCH)
#define is65InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_6_5_INCH)
#define isXSeriesDevice ([UIDevice currentDevice].screenType==UIDEVICE_5_8_INCH || [UIDevice currentDevice].screenType==UIDEVICE_6_5_INCH)
#define is320WidthDevice          (UIScreenWidth==320)
#define isRunningOnIOS8           [[UIDevice currentDevice] isIOS8]
#define isRunningOnIOS9           [[UIDevice currentDevice] isIOS9]
#define isRunningOnIOS10          [[UIDevice currentDevice] isIOS10]
#define isRunningOnIOS11          [[UIDevice currentDevice] isIOS11]
#define iOS7NavHeight             (64)
#define iOS11NavHeight            (44)
#define iOSNavHeight              (isXSeriesDevice?88:64)
#define iOSStatusBarHeight        (isXSeriesDevice?44:20)
#define iphoneXBottomAreaHeight   (isXSeriesDevice?34:0)
#define iOSTopHeight              (isXSeriesDevice?24:0)
#define ALImageDownloadRetryTime            3
typedef void(^COMPLETION_BLOCK)(void);

@interface ALUtility : NSObject
+ (NSString *)backBarButtonArrowResource;
+ (CGRect)backBarButtonArrowRect;
@end
