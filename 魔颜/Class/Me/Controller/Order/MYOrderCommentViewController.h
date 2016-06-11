//
//  MYOrderCommentViewController.h
//  魔颜
//
//  Created by Meiyue on 15/11/2.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYOrder.h"

typedef void(^CommentBlock)(NSInteger mark);

@interface MYOrderCommentViewController : UIViewController

@property (strong, nonatomic) MYOrder *orderLists;

@property (copy, nonatomic) CommentBlock commentBlock;

@end
