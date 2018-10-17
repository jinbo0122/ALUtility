//
//  NSMutableAttributedString+ALExtension.m
//  XSB
//
//  Created by Albert Lee on 19/03/2018.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import "NSMutableAttributedString+ALExtension.h"

@implementation NSMutableAttributedString (ALExtension)
- (void)addLineSpacing:(CGFloat)lineSpacing{
  NSInteger strLength = [self.string length];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style setLineSpacing:lineSpacing];
  [self addAttribute:NSParagraphStyleAttributeName
               value:style
               range:NSMakeRange(0, strLength)];
}

- (void)addParagraphSpacing:(CGFloat)lineSpacing AndLineSpacing:(CGFloat )lineSpa{
    NSInteger strLength = [self.string length];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setParagraphSpacing:lineSpacing];
    [style setLineSpacing:lineSpa];
    [self addAttribute:NSParagraphStyleAttributeName
                 value:style
                 range:NSMakeRange(0, strLength)];
}


- (void)addWordSpacing:(CGFloat)wordSpacing{
    NSInteger strLength = [self.string length];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSDictionary * dic = @{NSKernAttributeName:@(wordSpacing)};
    [self addAttribute:NSParagraphStyleAttributeName
                 value:style
                 range:NSMakeRange(0, strLength)];
    [self addAttributes:dic range:NSMakeRange(0, strLength)];
}

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size lineBreakMode:(NSString *)str{
    CGSize resultSize = CGSizeZero;
    @try {
        resultSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    } @catch (NSException *exception) {
    } @finally {
        return resultSize;
    }
}

-(void)attributedWithFont:(UIFont *)dFont HighFont:(UIFont *)sFont SelectStr:(NSString *)sStr IsSeparated:(BOOL)isSep{
    [self addAttribute:NSFontAttributeName value:dFont range:NSMakeRange(0, self.string.length)];
    NSString * signStr = @"";
    if (isSep) {
        NSArray * ary = [self.string componentsSeparatedByString:sStr];
        if (ary && ary.count > 1) {
            signStr = ary[1];
        }
    }else{
        signStr = sStr;
    }
    
    NSRange range = [self.string rangeOfString:signStr];
    if (range.location != NSNotFound) {
        NSInteger location = range.location;
        NSInteger lenght = range.length;
        [self addAttribute:NSFontAttributeName value:sFont range:NSMakeRange(location, lenght)];
    }
}


@end
