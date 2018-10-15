//
//  PDSingleton.h
//  pandora
//
//  Created by Albert Lee on 6/30/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - Macros

#undef	DEC_SINGLETON
#define DEC_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

@interface ALSingleton : NSObject

@end
