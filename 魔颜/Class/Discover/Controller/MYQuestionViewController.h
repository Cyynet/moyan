//
//  MYQuestionViewController.h
//  魔颜
//
//  Created by Meiyue on 16/5/16.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MYDeleteBlock)();

@interface MYQuestionViewController : UIViewController

/** 帖子id */
@property (copy, nonatomic) NSString *id;

/** <#注释#> */
@property (nonatomic, copy)  MYDeleteBlock deleteBlock;

@property(strong,nonatomic) NSString * Path; //从搜索列表进来的标示

@end
