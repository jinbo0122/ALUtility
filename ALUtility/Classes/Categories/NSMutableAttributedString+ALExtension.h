//
//  NSMutableAttributedString+ALExtension.h
//  XSB
//
//  Created by Albert Lee on 19/03/2018.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (ALExtension)
- (void)addLineSpacing:(CGFloat)lineSpacing;
- (void)addParagraphSpacing:(CGFloat)lineSpacing AndLineSpacing:(CGFloat )lineSpa;
- (void)addWordSpacing:(CGFloat)wordSpacing;
- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size lineBreakMode:(NSString *)str;
- (void)attributedWithFont:(UIFont *)dFont HighFont:(UIFont *)sFont SelectStr:(NSString *)sStr IsSeparated:(BOOL)isSep;
@end
