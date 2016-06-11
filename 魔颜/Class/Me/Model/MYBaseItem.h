//
//  WQTabBarController.h
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void (^myBlock)();

@interface MYBaseItem : NSObject

/** 红点图标 */
@property (nonatomic, copy) NSString *icon;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 子标题 */
@property (nonatomic, copy) NSString *subTitle;

///** 点击这行cell，需要调转到哪个控制器 */
@property (nonatomic, assign) Class destVcClass;

@property (nonatomic, copy) myBlock optional;

@property (nonatomic, assign) BOOL isLogin;

-(instancetype)initWithtitle:(NSString *)title;
+(instancetype)itemWithtitle:(NSString *)title;






@end
