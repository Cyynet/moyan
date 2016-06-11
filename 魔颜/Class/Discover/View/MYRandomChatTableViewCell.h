//
//  MYRandomChatTableViewCell.h
//  魔颜
//
//  Created by abc on 16/5/10.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYRandonChatModle.h"


@interface MYRandomChatTableViewCell : UITableViewCell

@property(strong,nonatomic) UIView * boomview;

@property(strong,nonatomic) MYRandonChatModle * randomchatmodle;

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath;

@end
