//
//  MYCircleCommentHeadView.h
//  魔颜
//
//  Created by Meiyue on 15/10/31.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCircleComment.h"
#import "MYCircleDesComment.h"

typedef void(^MYHeadBlock)(NSString *userName);

@interface MYCircleCommentHeadView : UITableViewHeaderFooterView

@property (strong, nonatomic) MYCircleComment *comment;


//提供一个类方法，创建一个头部视图

+(instancetype)headerWithTableView:(UITableView *)tableView section:(NSInteger)indexPath;


@property (copy, nonatomic) MYHeadBlock headBlock;


@end
