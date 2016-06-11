//
//  MYTabBar.h
//  魔颜
//
//  Created by Meiyue on 16/4/9.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class pushView,MYWeather;
typedef void(^MYPublicBlock)();

@interface MYTabBar : UITabBar

@property (copy, nonatomic) MYPublicBlock publicBlock;

@property(strong,nonatomic)pushView *myPushView;

/** 天气模型 */
@property (strong, nonatomic) MYWeather *weatherModel;

@end
