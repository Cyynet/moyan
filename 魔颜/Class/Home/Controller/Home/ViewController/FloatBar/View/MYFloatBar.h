//
//  MYFloatBar.h
//  魔颜
//
//  Created by Meiyue on 16/4/13.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MYFloatBlock)(NSInteger tag);

@interface MYFloatBar : UIView

@property (copy, nonatomic) MYFloatBlock floatBlock;

/** 定位显示 */
@property (weak, nonatomic) UIButton *leftBtn;

@end
