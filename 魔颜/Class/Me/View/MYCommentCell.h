//
//  MYCommentCell.h
//  魔颜
//
//  Created by Meiyue on 15/10/9.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCircleComment.h"
#import "MYCircleDesComment.h"
#import "MYCircleReply.h"

@class MYCircleComment,MYCircleDesComment,MYCircleReply;


@interface MYCommentCell : UITableViewCell
@property (strong, nonatomic) MYCircleComment *comment;
@property (strong, nonatomic) MYCircleReply *reply;
/** 评论的楼主 */
@property (copy, nonatomic) NSString *hostName;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@end
