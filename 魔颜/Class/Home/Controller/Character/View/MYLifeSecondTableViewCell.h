//
//  MYLifeSecondTableViewCell.h
//  魔颜
//
//  Created by abc on 16/2/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MYLifeSecondModle.h"

@interface MYLifeSecondTableViewCell : UITableViewCell

@property(strong,nonatomic) MYLifeSecondModle * lifenmodle;


+ (instancetype)cellWithTableView:(UITableView *)tableView  index:(NSIndexPath *)indexPath;

@end
