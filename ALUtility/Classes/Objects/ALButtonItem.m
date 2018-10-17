//
//  ALButtonItem.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "ALButtonItem.h"

@implementation ALButtonItem
@synthesize label;
@synthesize action;

+(id)item
{
    return [self new];
}

+(id)itemWithLabel:(NSString *)inLabel
{
    ALButtonItem *newItem = [self item];
    [newItem setLabel:inLabel];
    return newItem;
}

+(id)itemWithLabel:(NSString *)inLabel action:(void(^)(void))action
{
  ALButtonItem *newItem = [self itemWithLabel:inLabel];
  [newItem setAction:action];
  return newItem;
}

@end

