//
//  MYAttentionCellTableViewCell.h
//  魔颜
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYTieziPhotosView.h"
#import "MYAttention.h"
#import "MYTieziModel.h"

@interface MYAttentionCellTableViewCell : UITableViewCell

@property (strong, nonatomic) MYAttention *attention;
@property (strong, nonatomic) MYTieziPhotosView *tieziPhotosView;
//@property (strong, nonatomic) MYTieziModel *tieziModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath;

@end
