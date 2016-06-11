//
//  MYTopView.h
//  魔颜
//
//  Created by 易汇金 on 15/10/4.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UITableViewShowStyle)
{
    /**
     *  UITableViewShowStyle
     */
    UITableViewShowStyleOne = 1,//default
    UITableViewShowStyleDouble = 2,
};


@interface MYPopView : UIView

/**选择的数组*/
@property (strong, nonatomic)  NSMutableArray *chooseArray;

+ (instancetype)popViewWithTopBtn:(UIButton *)topBtn;

-(void)showInRect:(CGRect)rect;

/** 展示多少列 */
@property (nonatomic, assign) UITableViewShowStyle showStyle;

@property(strong,nonatomic) NSString * type;


@end
