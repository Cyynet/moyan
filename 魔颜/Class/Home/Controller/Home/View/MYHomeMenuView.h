//
//  MYHomeMenuView.h
//  魔颜
//
//  Created by Meiyue on 16/4/9.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBtnBlock)(NSInteger btnType);

typedef NS_ENUM(NSInteger, UIMenuBtnStyle)
{
    UIMenuBtnStyleBeauty,
    UIMenuBtnStyleHospital,
    UIMenuBtnStyleGoods,
};


@interface MYHomeMenuView : UIView

/** 按钮类型 */
@property (nonatomic, assign)  UIMenuBtnStyle btnStyle;
@property (copy, nonatomic)    MyBtnBlock btnType;



@end
