//
//  MYHomeDiscountListTableViewCell.h
//  魔颜
//
//  Created by abc on 15/11/2.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MYDiscountListModel.h"

@interface MYHomeDiscountListTableViewCell : UITableViewCell

@property (strong, nonatomic) MYDiscountListModel * discountList;

+ (instancetype)cellWithTableView:(UITableView *)tableView NSIndexPath:(NSIndexPath *)indexPath;
@end
