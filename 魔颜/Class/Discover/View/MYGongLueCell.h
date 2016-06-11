
//
//  MYGongLueCell.h
//  魔颜
//
//  Created by abc on 16/5/5.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYGongLueListModle.h"

@interface MYGongLueCell : UITableViewCell

@property(strong,nonatomic) MYGongLueListModle * listmodle;
@property(strong,nonatomic) UIView * boomview;

+(instancetype)cellwithTableview:(UITableView*)tableview indexPath:(NSIndexPath*)indexPath;

@end

