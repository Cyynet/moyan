//
//  WQTabBarController.h
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYBaseGroup : NSObject

/** 组头 */
@property (nonatomic, copy) NSString *header;

/** 这组的所有行模型(数组中存放的都是MYCommonItem模型) */
@property (nonatomic, strong) NSArray *items;

+ (instancetype)group;


@end
