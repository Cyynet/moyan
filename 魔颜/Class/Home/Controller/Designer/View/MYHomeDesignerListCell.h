//
//  MYHomeDesignerCell.h
//  魔颜
//
//  Created by abc on 15/11/20.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "designerListModel.h"

@interface MYHomeDesignerListCell : UITableViewCell

@property(strong,nonatomic) designerListModel * designerModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath;

@end

