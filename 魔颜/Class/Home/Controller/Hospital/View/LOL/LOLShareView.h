//
//  LOLShareView.h
//  掌上英雄联盟
//
//  Created by 尚承教育 on 15/8/30.
//  Copyright (c) 2015年 尚承教育. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LOLShareView,LOLShareBtn;
@protocol LOLShareViewDelegate  <NSObject>

- (void)shareViewDidClickShareBtn:(LOLShareView *)shareView selBtn:(LOLShareBtn *)shareBtn;

@end

@interface LOLShareView : UIImageView

- (void)startShareWithText:(NSString *)text image:(UIImage *)image;

@property (copy, nonatomic) NSString *shareText;
@property (strong, nonatomic) UIImage *shareImage;

@property (weak, nonatomic) id<LOLShareViewDelegate> delegate;

@end
