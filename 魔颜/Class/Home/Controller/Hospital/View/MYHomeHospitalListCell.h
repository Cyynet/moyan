//
//  MYHomeHospitalListCell.h
//  魔颜
//
//  Created by abc on 15/11/17.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "hospitaleListModel.h"

typedef NS_ENUM(NSUInteger, UIControlerStyle)
{
    /**
      *  不显示PageControl
     */
    UIControlerStyleHospital,//default
    UIControlerStyleSalon,
};

@interface MYHomeHospitalListCell : UITableViewCell

@property (assign,nonatomic) UIControlerStyle  controlerStyle;

@property(strong,nonatomic) hospitaleListModel * hospitalmodel;


+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath;

@end
