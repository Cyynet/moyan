//
//  MYBeautyMenu.h
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYBeautyMenu : UIView

typedef void(^MyBtnBlock)(UIButton *btn);

@property (copy, nonatomic)    MyBtnBlock btnType;

@end
