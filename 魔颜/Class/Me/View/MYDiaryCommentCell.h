//
//  MYDiaryCommentCell.h
//  魔颜
//
//  Created by Meiyue on 15/12/22.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYMyDiaryCommentsModel.h"

@interface MYDiaryCommentCell : UITableViewCell

@property(strong,nonatomic) MYMyDiaryCommentsModel *commentModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath;

@end
