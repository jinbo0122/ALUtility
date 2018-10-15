//
//  NSData+ALExtension.m
//  ALExtension
//
//  Created by Albert Lee on 7/14/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "NSData+ALExtension.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSData (ALExtension)
#pragma mark Image Related
- (NSString *)detectImageSuffix
{
  uint8_t c;
  NSString *imageFormat = @"";
  [self getBytes:&c length:1];
  
  switch (c) {
    case 0xFF:
      imageFormat = @".jpg";
      break;
    case 0x89:
      imageFormat = @".png";
      break;
    case 0x47:
      imageFormat = @".gif";
      break;
    case 0x49:
    case 0x4D:
      imageFormat = @".tiff";
      break;
    case 0x42:
      imageFormat = @".bmp";
      break;
    default:
      break;
  }
  return imageFormat;
}

#pragma mark MD5 Digest
+(NSData *)MD5Digest:(NSData *)input {
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  
  CC_MD5(input.bytes,(unsigned int) input.length, result);
  return [[NSData alloc] initWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

-(NSData *)MD5Digest {
  return [NSData MD5Digest:self];
}

+(NSString *)MD5HexDigest:(NSData *)input {
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  
  CC_MD5(input.bytes, (unsigned int)input.length, result);
  NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
  for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
    [ret appendFormat:@"%02x",result[i]];
  }
  return ret;
}

-(NSString *)MD5HexDigest {
  return [NSData MD5HexDigest:self];
}

#pragma mark Base64
#if !__has_feature(objc_arc)
#error This library requires automatic reference counting
#endif

+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
  const char lookup[] =
  {
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
    99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
    99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
  };
  
  NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSUInteger inputLength = [inputData length];
  const unsigned char *inputBytes = [inputData bytes];
  
  NSUInteger maxOutputLength = (inputLength / 4 + 1) * 3;
  NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
  unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
  
  int accumulator = 0;
  long long outputLength = 0;
  unsigned char accumulated[] = {0, 0, 0, 0};
  for (long long i = 0; i < inputLength; i++)
  {
    unsigned char decoded = lookup[inputBytes[i] & 0x7F];
    if (decoded != 99)
    {
      accumulated[accumulator] = decoded;
      if (accumulator == 3)
      {
        outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
        outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
        outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
      }
      accumulator = (accumulator + 1) % 4;
    }
  }
  
  //handle left-over data
  if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
  if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
  if (accumulator > 2) outputLength++;
  
  //truncate data to match actual output length
  outputData.length = (long)outputLength;
  return outputLength? outputData: nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
  //ensure wrapWidth is a multiple of 4
  wrapWidth = (wrapWidth / 4) * 4;
  
  const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  
  NSUInteger inputLength = [self length];
  const unsigned char *inputBytes = [self bytes];
  
  NSUInteger maxOutputLength = (inputLength / 3 + 1) * 4;
  maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
  unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
  
  NSUInteger i;
  NSUInteger outputLength = 0;
  for (i = 0; i < inputLength - 2; i += 3)
  {
    outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
    outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
    outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
    outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
    
    //add line break
    if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
    {
      outputBytes[outputLength++] = '\r';
      outputBytes[outputLength++] = '\n';
    }
  }
  
  //handle left-over data
  if (i == inputLength - 2)
  {
    // = terminator
    outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
    outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
    outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
    outputBytes[outputLength++] =   '=';
  }
  else if (i == inputLength - 1)
  {
    // == terminator
    outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
    outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
    outputBytes[outputLength++] = '=';
    outputBytes[outputLength++] = '=';
  }
  
  if (outputLength >= 4)
  {
    //truncate data to match actual output length
    outputBytes = realloc(outputBytes, outputLength);
    return [[NSString alloc] initWithBytesNoCopy:outputBytes
                                          length:outputLength
                                        encoding:NSASCIIStringEncoding
                                    freeWhenDone:YES];
  }
  else if (outputBytes)
  {
    free(outputBytes);
  }
  return nil;
}

- (NSString *)base64EncodedString
{
  return [self base64EncodedStringWithWrapWidth:0];
}

+ (NSString*)base64forData:(NSData*)theData {
	
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
  static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
  NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
  uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i,i2;
  for (i=0; i < length; i += 3) {
    NSInteger value = 0;
		for (i2=0; i2<3; i2++) {
      value <<= 8;
      if (i+i2 < length) {
        value |= (0xFF & input[i+i2]);
      }
    }
		
    NSInteger theIndex = (i / 3) * 4;
    output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
    output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
    output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
    output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
  }
	
  return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
-(NSArray*)array
{
  NSArray* arr= [NSKeyedUnarchiver unarchiveObjectWithData:self];
  return arr;
}
-(NSDictionary*)dictionary
{
  NSDictionary* dictionary= [NSKeyedUnarchiver unarchiveObjectWithData:self];
  return dictionary;
}
- (NSString *)UTF8String
{
  NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
  return string;
}
@end
