//
//  MYTieziMyCell.h
//  魔颜
//
//  Created by Meiyue on 15/10/27.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYTieziModel.h"
#import "MYTieziPhotosView.h"
#import "MYTieziRelatedView.h"

@interface MYTieziMyCell : UITableViewCell

@property (strong, nonatomic) MYTieziModel *tieziModel;
@property (strong, nonatomic) MYTieziPhotosView *tieziPhotosView;
@property (strong, nonatomic) MYTieziRelatedView *releatedView;


+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath;

@end
