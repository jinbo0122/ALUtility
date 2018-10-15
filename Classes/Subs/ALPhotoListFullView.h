//
//  ALPhotoListFullView.h
//  ALExtension
//
//  Created by Albert Lee on 7/13/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ALPhotoListFullViewDelegate;
@interface ALPhotoListFullView : UIView
@property(nonatomic,   weak)id<ALPhotoListFullViewDelegate>delegate;
- (id)initWithFrames:(NSArray *)frames photoList:(NSArray *)photoList index:(NSInteger)index;
@end

@protocol ALPhotoListFullViewDelegate <NSObject>
- (void)savePhotoTolocalAlbumSucceed:(ALPhotoListFullView *)view;
- (void)savePhotoTolocalAlbumFailed:(ALPhotoListFullView *)view;
@end
