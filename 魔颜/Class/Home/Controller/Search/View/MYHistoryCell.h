//
//  WQHomeTableViewController.h
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MYHistoryCell : UITableViewCell

+ (instancetype)historyCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath atNSMutableArr:(NSMutableArray *)datas;

@end
