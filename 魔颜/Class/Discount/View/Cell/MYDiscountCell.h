//
//  MYDiscountCell.h
//  魔颜
//
//  Created by Meiyue on 15/10/8.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYDiscount;
@interface MYDiscountCell : UITableViewCell

/** cell对应的数据 */
@property (strong, nonatomic) MYDiscount *discount;

+ (instancetype)cellWithTableView:(UITableView *)tableView  index:(NSIndexPath *)indexPath;


@end
