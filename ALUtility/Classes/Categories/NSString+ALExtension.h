//
//  NSString+Category.h
//  Pandora
//
//  Created by Albert Lee on 12/25/13.
//  Copyright (c) 2013 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "MHPrettyDate.h"
typedef void(^COMPLETION_BLOCK_FilePath)(NSString *filePath, NSString *imgfilePath);
@interface NSString (ALExtension)
#pragma mark - Time
- (NSString *)timeString;
+ (NSString *)timeString:(NSTimeInterval)time;
+ (NSString *)timeString:(NSString *)unixTime format:(MHPrettyDateFormat)format;
+ (NSString *)time:(NSTimeInterval)unixTime format:(MHPrettyDateFormat)format;
+ (NSString *)timeStringFromSec:(int)sec;
+ (NSString *)timeCountStringByTime:(NSTimeInterval)time;
+ (NSString *)calendarWithWeekday:(NSTimeInterval)unixTime;
+ (NSString *)calendarString:(NSTimeInterval)unixTime;

#pragma mark - MD5
+ (NSString *)stringByMD5Encoding:(NSString*)inputString;
- (NSString *)MD5;

#pragma mark Base64 Related
+ (NSString*)stringWithBase64EncodedString:(NSString *)string;
- (NSString*)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString*)base64EncodedString;
- (NSString*)base64DecodedString;
- (NSData  *)base64DecodedData;

#pragma mark - Attributed String
- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font textColor:(UIColor *)textColor;
- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size;
- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode;


#pragma mark - Detect
+ (BOOL)stringContainsEmoji:(NSString *)string;
- (BOOL)containsTraditionalChinese;
- (BOOL)isValidPassword;
- (BOOL)isAllDigits;
+ (BOOL)validateIDCardNumber:(NSString *)value;
+ (int )convertToInt:(NSString*)strtemp;


#pragma mark - Custom
- (NSString *)trimWhitespace;
- (NSNumber *)numberValue;
- (NSData   *)UTF8Data;
- (NSArray  *)getAtNames;
- (NSString *)convertSingleQuote;
+ (NSString *)lineStringByLength:(CGFloat)length font:(CGFloat)fontSize;
+ (NSString *)stringWithLimitedChineseCharacter:(NSInteger)length string:(NSString*)strtemp;

#pragma mark - WTF
+ (NSString *)getFaceImageLocalPathByStoreData:(NSData *)imageData;
+ (NSString *)pathByCacheDirection:(NSString*)customCacheDirectionName;
- (NSData   *)getThumnailWithURL:(int)width height:(int)height;
- (UIImage  *)getThumnailImageWithURL:(int)width height:(int)height;

#pragma mark - URL
- (NSURL   *)url;
- (NSURL   *)urlWithSuffix:(NSString *)suffix;
- (NSString*)urlDecodedString;
@end
