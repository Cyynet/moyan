//
//  HGTitleView.h
//  HiGo
//
//  Created by Think_lion on 15/7/25.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TitleBlock)(NSInteger index);

@interface MYBeautyMenuView : UIView

@property (nonatomic,copy) TitleBlock titleBlock;

/**
 *  传入当前controller的偏移位置
 */
- (void)sliderMoveToOffsetX:(CGFloat)x;
/**
 *  根据传入的标题数组初始化
 */
- (id)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr imageArr:(NSArray *)imageArr type:(NSString *)type;



@end
