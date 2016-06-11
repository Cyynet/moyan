//
//  pushView.h
//  animationOne
//
//  Created by 战明 on 16/5/15.
//  Copyright © 2016年 zhanming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYWeather.h"

#define  ScreenWidth [UIScreen mainScreen].bounds.size.width
#define  ScreenHeight [UIScreen mainScreen].bounds.size.height

typedef void(^MYPushBlock)(NSInteger type,NSString *urlStr);
@interface pushView : UIView

-(void)pushButton;

@property (copy, nonatomic) MYPushBlock pushBlock;

/** 天气模型 */
@property (strong, nonatomic) MYWeather *weatherModel;

@end
