//
//  MYHomeCellTableViewCell.h
//  魔颜
//
//  Created by Meiyue on 16/4/12.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYItemCell.h"

@interface MYHomeCell : UITableViewCell

/** 请求下来的数组 */
@property (strong, nonatomic) NSArray *items;

@property(strong,nonatomic) MYItemCell * item;


+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;       

@end
