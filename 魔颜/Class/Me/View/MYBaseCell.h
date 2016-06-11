//
//  WQTabBarController.h
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MYBaseItem;
@interface MYBaseCell : UITableViewCell

/** cell对应的item数据 */
@property (nonatomic, strong) MYBaseItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (assign, nonatomic) BOOL isLogin;



@end
