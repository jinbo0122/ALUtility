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

@interface ALUtility : NSObject
+ (NSString *)backBarButtonArrowResource;
+ (CGRect)backBarButtonArrowRect;
@end
