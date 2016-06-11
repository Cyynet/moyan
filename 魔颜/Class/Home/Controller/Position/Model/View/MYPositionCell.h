//
//  MYPositionCell.h
//  魔颜
//
//  Created by Meiyue on 15/10/19.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPositionView.h"
#import "MYPositionGroup.h"
#import "MYItem.h"

@interface MYPositionCell : UITableViewCell

@property (strong, nonatomic) MYPositionGroup *groups;
@property (strong, nonatomic) MYItem *items;

@property (strong, nonatomic) MYPositionView *postionView;
@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)cellWithTableView:(UITableView *)tableView  index:(NSIndexPath *)indexPath;

@end
