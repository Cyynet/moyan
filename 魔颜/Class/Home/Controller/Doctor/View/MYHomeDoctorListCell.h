//
//  MYHomeDoctorListCell.h
//  魔颜
//
//  Created by abc on 15/11/8.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "doctorListModel.h"
@interface MYHomeDoctorListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath;


@property(strong,nonatomic) doctorListModel * doctorListMode;;
@property (nonatomic, assign) CGFloat cellHeight;

@end
 