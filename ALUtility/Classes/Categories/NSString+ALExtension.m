//
//  NSString+Category.m
//  Pandora
//
//  Created by Albert Lee on 12/25/13.
//  Copyright (c) 2013 Albert Lee. All rights reserved.
//

#import "NSString+ALExtension.h"
#import "NSDate+ALExtension.h"
#import "NSData+ALExtension.h"
#import "NSArray+ALExtension.h"
#import <AVFoundation/AVFoundation.h>
@implementation NSString (ALExtension)
+ (NSString*)timeString:(NSString *)unixTime format:(MHPrettyDateFormat)format{
  return [NSString time:[unixTime doubleValue] format:format];
}

+ (NSString*)time:(NSTimeInterval)unixTime format:(MHPrettyDateFormat)format{
  if (unixTime==0) {
    return @"";
  }
  
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime];
  NSString *timeString = [MHPrettyDate prettyDateFromDate:date
                                               withFormat:format];
  
  if (format == MHPrettyDateShortRelativeTime && ![[timeString substringFromIndex:timeString.length-1] isEqualToString:@"前"]) {
    timeString = [timeString stringByAppendingString:@"前"];
  }
  
  if (timeString.length>0 && [timeString characterAtIndex:0] == '-') {
    return [timeString substringFromIndex:1];
  }
  
  return timeString;
}

+ (NSString*)timeString:(NSTimeInterval)time{
  [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterFullStyle];
  [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
  return [NSString stringWithFormat:@"?%@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
}

+ (NSString *)calendarWithWeekday:(NSTimeInterval)unixTime{
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime];
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                             fromDate:date];
  
  NSInteger day = [components day];
  NSInteger month = [components month];
  NSInteger year = [components year];
  
  
  NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[NSDate currentTime]];
  NSCalendar* currentCalendar = [NSCalendar currentCalendar];
  NSDateComponents* currentDateComponents = [currentCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                               fromDate:currentDate];
  
  NSInteger currentYear = [currentDateComponents year];
  NSInteger currentDay = [currentDateComponents day];
  NSInteger currentMonth = [currentDateComponents month];
  
  NSString *yearStr = year==currentYear?@"":[NSString stringWithFormat:@"%@年",@(year)];
  
  NSString *suffix = @"";
  if (currentDay == day && currentMonth == month && currentYear == year) {
    suffix = @"今天";
  }else if (currentDay-1 == day && currentMonth == month && currentYear == year){
    suffix = @"昨天";
  }else{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
    suffix = [dateFormatter stringFromDate:date];
  }
  
  NSString *timeStr = [NSString stringWithFormat:@"%@%@月%@日 %@",yearStr,@(month),@(day), suffix];
  return timeStr;
}

+ (NSString *)calendarString:(NSTimeInterval)unixTime{
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime];
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                             fromDate:date];
  
  NSInteger day = [components day];
  NSInteger month = [components month];
  NSInteger year = [components year];
  
  
  NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[NSDate currentTime]];
  NSCalendar* currentCalendar = [NSCalendar currentCalendar];
  NSDateComponents* currentDateComponents = [currentCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                               fromDate:currentDate];
  
  NSInteger currentYear = [currentDateComponents year];
  NSString *yearStr = year==currentYear?@"":[NSString stringWithFormat:@"%@年",@(year)];
  NSString *timeStr = [NSString stringWithFormat:@"%@%@月%@日",yearStr,@(month),@(day)];
  return timeStr;
}

+ (NSString *)timeStringFromSec:(int)sec{
  int h = sec/3600;
  int m = (sec-h*3600)/60;
  int s = sec%30;
  NSString *time = h==0?@"":[NSString stringWithFormat:@"%d小时",h];
  time = m==0?[time stringByAppendingString:@""]:[time stringByAppendingString:[NSString stringWithFormat:@"%d分",m]];
  time = s==0?[time stringByAppendingString:@""]:[time stringByAppendingString:[NSString stringWithFormat:@"%d秒",s]];
  return time;
}

- (NSString *)trimWhitespace
{
  NSMutableString *str = [self mutableCopy];
  CFStringTrimWhitespace((CFMutableStringRef)str);
  return str;
}

#pragma mark String MD5 Encoding & Decoding
+ (NSString *)stringByMD5Encoding:(NSString*)inputString{
  const char *cStr = [inputString UTF8String];
  unsigned char result[16];
  CC_MD5(cStr, (CGFloat)strlen(cStr), result); // This is the md5 call
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0], result[1], result[2], result[3],
          result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11],
          result[12], result[13], result[14], result[15]
          ];
}
#pragma mark URL String Encoding & Decoding
- (NSNumber *)numberValue{
  NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
  [f setNumberStyle:NSNumberFormatterDecimalStyle];
  return [f numberFromString:self];
}

- (NSData *)UTF8Data
{
  return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSArray *)getAtNames{
  NSMutableArray *substrings = [NSMutableArray new];
  NSScanner *scanner = [NSScanner scannerWithString:self];
  [scanner scanUpToString:@"@" intoString:nil]; // Scan all characters before #
  while(![scanner isAtEnd]) {
    NSString *substring = nil;
    [scanner scanString:@"@" intoString:nil]; // Scan the # character
    if([scanner scanUpToString:@" " intoString:&substring]) {
      // If the space immediately followed the #, this will be skipped
      [substrings addObject:substring];
    }
    [scanner scanUpToString:@"@" intoString:nil]; // Scan all characters before next #
  }
  // do something with substrings
  return substrings;
}

- (NSString *)convertSingleQuote{
  if ([self rangeOfString:@"'"].location != NSNotFound) {
    NSMutableString *str = [@"" mutableCopy];
    for (NSInteger i=0;i<self.length; i++) {
      NSString *subStr = [self substringWithRange:NSMakeRange(i, 1)];
      if ([subStr isEqualToString:@"'"]) {
        [str appendString:@"''"];
      }
      else{
        [str appendString:subStr];
      }
    }
    return [str copy];
  }
  else{
    return self;
  }
}
#pragma mark Cache Path Direction
+ (NSString *)pathByCacheDirection:(NSString*)customCacheDirectionName{
  NSArray *cacheDirectoryArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *pathString = [cacheDirectoryArray objectAtIndex:0];
  NSString *customCacheDirection = [pathString stringByAppendingPathComponent:customCacheDirectionName];
  if (![[NSFileManager defaultManager] fileExistsAtPath:customCacheDirection])
  {
    [[NSFileManager defaultManager] createDirectoryAtPath:customCacheDirection
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
  }
  
  return customCacheDirection;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
  __block BOOL returnValue = NO;
  [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
   ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
     
     const unichar hs = [substring characterAtIndex:0];
     // surrogate pair
     if (0xd800 <= hs && hs <= 0xdbff) {
       if (substring.length > 1) {
         const unichar ls = [substring characterAtIndex:1];
         const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
         if (0x1d000 <= uc && uc <= 0x1f77f) {
           returnValue = YES;
         }
       }
     } else if (substring.length > 1) {
       const unichar ls = [substring characterAtIndex:1];
       if (ls == 0x20e3) {
         returnValue = YES;
       }
       
     } else {
       // non surrogate
       if (0x2100 <= hs && hs <= 0x27ff) {
         returnValue = YES;
       } else if (0x2B05 <= hs && hs <= 0x2b07) {
         returnValue = YES;
       } else if (0x2934 <= hs && hs <= 0x2935) {
         returnValue = YES;
       } else if (0x3297 <= hs && hs <= 0x3299) {
         returnValue = YES;
       } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
         returnValue = YES;
       }
     }
   }];
  
  return returnValue;
}

+ (NSString *)timeCountStringByTime:(NSTimeInterval)time{
  int h = time/3600;
  int m = (time-h*3600)/60;
  int s = time-h*3600-m*60;
  
  NSString *hStr = h<10?[NSString stringWithFormat:@"0%d",h]:[NSString stringWithFormat:@"%d",h];
  NSString *mStr = m<10?[NSString stringWithFormat:@"0%d",m]:[NSString stringWithFormat:@"%d",m];
  NSString *sStr = s<10?[NSString stringWithFormat:@"0%d",s]:[NSString stringWithFormat:@"%d",s];
  
  NSString *callingTime = @"";
  if (h>0) {
    callingTime = [NSString stringWithFormat:@"%@:%@:%@",hStr,mStr,sStr];
  }
  else{
    callingTime = [NSString stringWithFormat:@"%@:%@",mStr,sStr];
  }
  return callingTime;
}

#pragma mark Traditional Chinese Character
- (BOOL)containsTraditionalChinese{
  //  for (NSInteger i=0;i<[self length];i++) {
  //
  //  }
  
  return NO;
}

#pragma mark MD5 Related
- (NSString *)MD5
{
  const char *cStr = [self UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0], result[1], result[2], result[3],
          result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11],
          result[12], result[13], result[14], result[15]
          ];
}


#pragma mark Base64 Related

+ (NSString *)stringWithBase64EncodedString:(NSString *)string
{
  NSData *data = [NSData dataWithBase64EncodedString:string];
  if (data)
  {
    return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
  }
  return nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
  return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)base64EncodedString
{
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
  return [data base64EncodedString];
}

- (NSString *)base64DecodedString
{
  return [NSString stringWithBase64EncodedString:self];
}

- (NSData *)base64DecodedData
{
  return [NSData dataWithBase64EncodedString:self];
}

- (NSData *)getThumnailWithURL:(int)width height:(int)height{
  NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
  NSURL *url=[[NSURL alloc]initWithString:self];
  AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
  AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
  generator.appliesPreferredTrackTransform = YES;
  generator.maximumSize = CGSizeMake(width, height);
  NSError *error = nil;
  CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(25, 25) actualTime:NULL error:&error]; // 截图第一秒视频帧
  UIImage *image = [UIImage imageWithCGImage: img];
  return UIImageJPEGRepresentation(image,1.0);;
}

- (UIImage *)getThumnailImageWithURL:(int)width height:(int)height{
  NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
  NSURL *url=[[NSURL alloc]initWithString:self];
  AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
  AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
  generator.appliesPreferredTrackTransform = YES;
  generator.maximumSize = CGSizeMake(width, height);
  NSError *error = nil;
  CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(25, 25) actualTime:NULL error:&error]; // 截图第一秒视频帧
  UIImage *image = [UIImage imageWithCGImage: img];
  return image;
}

+ (NSString *)getFaceImageLocalPathByStoreData:(NSData *)imageData{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *imageLocalPath = [paths safeObjectAtIndex:0];
  imageLocalPath = [imageLocalPath stringByAppendingPathComponent:[[NSString stringByMD5Encoding:[NSString stringWithFormat:@"%@%@",@"FaceCamera",[NSString timeString:[NSDate currentTime]]]] stringByAppendingString:@".jpg"]];
  
  BOOL succeed = [imageData writeToFile:imageLocalPath atomically:YES];
  
  if (!succeed) {
    NSLog(@"write local image failed");
  }
  else{
    NSLog(@"%@",imageLocalPath);
  }
  return imageLocalPath;
}

+ (NSString *)lineStringByLength:(CGFloat)length font:(CGFloat)fontSize{
  NSString *line = @"_";
  CGSize size = [line sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
  NSInteger count = length/size.width;
  while (count>0) {
    line= [line stringByAppendingString:@"_"];
    count--;
  }
  return line;
}
#pragma mark 字数判断
+ (int)convertToInt:(NSString*)strtemp {
  int strlength = 0;
  char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
  for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
    if (*p) {
      p++;
      strlength++;
    }
    else {
      p++;
    }
  }
  return (strlength+1)/2;
}
+ (NSString *)stringWithLimitedChineseCharacter:(NSInteger)length string:(NSString*)strtemp{
  int strlength = 0;
  char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
  for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
    if (*p) {
      p++;
      strlength++;
      if (((strlength+1)/2)>=length) {
        return [strtemp substringToIndex:i];
      }
    }
    else {
      p++;
    }
  }
  return strtemp;
}

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode{
  NSMutableDictionary *attrNew = [attrs mutableCopy];
  NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
  paragraph.lineBreakMode = mode;
  [attrNew setObject:paragraph forKey:NSParagraphStyleAttributeName];
  
  CGSize resultSize = CGSizeZero;
  @try {
    resultSize = [self boundingRectWithSize:size
                                    options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attrNew context:nil].size;
  } @catch (NSException *exception) {
  } @finally {
    return resultSize;
  }
}

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size{
  CGSize resultSize = CGSizeZero;
  @try {
    resultSize = [self boundingRectWithSize:size
                                    options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attrs context:nil].size;
  } @catch (NSException *exception) {
  } @finally {
    return resultSize;
  }
}


- (BOOL)isValidPassword{
  NSCharacterSet *validChars = [NSCharacterSet alphanumericCharacterSet];
  NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
  BOOL valid = [validChars isSupersetOfSet:inStringSet];
  return valid;
}

- (BOOL)isAllDigits{
  NSCharacterSet *validChars = [NSCharacterSet decimalDigitCharacterSet];
  NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
  BOOL valid = [validChars isSupersetOfSet:inStringSet];
  return valid;
}

+ (BOOL)validateIDCardNumber:(NSString *)value {
  value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  NSInteger length =0;
  if (!value) {
    return NO;
  }else {
    length = value.length;
    
    if (length !=15 && length !=18) {
      return NO;
    }
  }
  // 省份代码
  NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
  
  NSString *valueStart2 = [value substringToIndex:2];
  BOOL areaFlag =NO;
  for (NSString *areaCode in areasArray) {
    if ([areaCode isEqualToString:valueStart2]) {
      areaFlag =YES;
      break;
    }
  }
  
  if (!areaFlag) {
    return false;
  }
  
  
  NSRegularExpression *regularExpression;
  NSUInteger numberofMatch;
  
  int year =0;
  switch (length) {
    case 15:{
      year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
      
      if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
        
        regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                options:NSRegularExpressionCaseInsensitive
                                                                  error:nil];//测试出生日期的合法性
      }else {
        regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                options:NSRegularExpressionCaseInsensitive
                                                                  error:nil];//测试出生日期的合法性
      }
      numberofMatch = [regularExpression numberOfMatchesInString:value
                                                         options:NSMatchingReportProgress
                                                           range:NSMakeRange(0, value.length)];
      
      //            [regularExpressionrelease];
      
      if(numberofMatch >0) {
        return YES;
      }else {
        return NO;
      }
      
    }
      break;
    case 18:{
      
      year = [value substringWithRange:NSMakeRange(6,4)].intValue;
      if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
        
        regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                options:NSRegularExpressionCaseInsensitive
                                                                  error:nil];//测试出生日期的合法性
      }else {
        regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                options:NSRegularExpressionCaseInsensitive
                                                                  error:nil];//测试出生日期的合法性
      }
      numberofMatch = [regularExpression numberOfMatchesInString:value
                                                         options:NSMatchingReportProgress
                                                           range:NSMakeRange(0, value.length)];
      
      
      if(numberofMatch >0) {
        int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
        int Y = S %11;
        NSString *M =@"F";
        NSString *JYM =@"10X98765432";
        M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
        if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
          return YES;// 检测ID的校验位
        }else {
          return NO;
        }
        
      }else {
        return NO;
      }
      
    }
      break;
    default:
      return false;
  }
}

- (NSURL *)urlWithSuffix:(NSString *)suffix{
  return [NSURL URLWithString:[self stringByAppendingString:suffix]];
}

- (NSURL *)url{
  return [NSURL URLWithString:self];
}

- (NSString*) urlDecodedString {
  return [self stringByRemovingPercentEncoding];
}

- (NSString *)timeString{
  return [self stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}
@end
