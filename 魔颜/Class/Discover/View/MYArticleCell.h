//
//  MYArticleCell.h
//  魔颜
//
//  Created by Meiyue on 16/5/12.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCommentsModel.h"

@interface MYArticleCell : UITableViewCell

/** 帖子回复模型 */
@property (strong, nonatomic) MYCommentsModel *commentsModel;


/** 帖子类型 */
@property (copy, nonatomic) NSString *type;

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath;

@end
