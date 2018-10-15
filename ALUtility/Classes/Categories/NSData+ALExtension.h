//
//  NSData+ALExtension.h
//  ALExtension
//
//  Created by Albert Lee on 7/14/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ALExtension)
-(NSArray*)array;
-(NSDictionary*)dictionary;
- (NSString *)UTF8String;
#pragma mark Image Related
- (NSString *)detectImageSuffix;

#pragma mark MD5 Digest
+(NSData *)MD5Digest:(NSData *)input;
-(NSData *)MD5Digest;

+(NSString *)MD5HexDigest:(NSData *)input;
-(NSString *)MD5HexDigest;

#pragma mark Base64
+ (NSString*)base64forData:(NSData*)theData;
+ (NSData  *)dataWithBase64EncodedString:(NSString *)string;
- (NSString*)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString*)base64EncodedString;
@end
