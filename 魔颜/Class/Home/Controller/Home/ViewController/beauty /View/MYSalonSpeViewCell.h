//
//  MYSalonSpeViewCell.h
//  魔颜
//
//  Created by abc on 16/4/26.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hospitaleListModel.h"

@interface MYSalonSpeViewCell : UITableViewCell

@property(strong,nonatomic) hospitaleListModel * salonmodel;
@property(strong,nonatomic) UIView * boomview;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
