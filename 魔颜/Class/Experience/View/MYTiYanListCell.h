//
//  MYTiYanListCell.h
//  魔颜
//
//  Created by abc on 16/5/3.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYTiYanListModle.h"

@interface MYTiYanListCell : UITableViewCell

@property(strong,nonatomic) MYTiYanListModle * tiyanmodle;

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath;

@end
