//
//  MYRequestTableViewCell.h
//  魔颜
//
//  Created by abc on 16/5/10.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYRequestModle.h"

@interface MYRequestTableViewCell : UITableViewCell

@property(strong,nonatomic) MYRequestModle * questModle;

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath;
@end
