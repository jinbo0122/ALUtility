//
//  UITableView+NoDataNotice.m
//  Avalon
//
//  Created by APPLE on 2017/8/29.
//  Copyright © 2017年 Baobao. All rights reserved.
//

#import "UITableView+NoDataNotice.h"

@implementation UITableView (NoDataNotice)

- (void)tableViewDisplayWithNotice:(NSString *)notice 
{
    UILabel *messageLabel = [UILabel new];
    messageLabel.text = notice;
    messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    messageLabel.textColor = [UIColor lightGrayColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel sizeToFit];
    
    self.backgroundView = messageLabel;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;

}


@end
