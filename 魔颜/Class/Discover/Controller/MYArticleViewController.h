//
//  MYArticleViewController.h
//  魔颜
//
//  Created by Meiyue on 16/5/11.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MYDeleteBlock)();

@interface MYArticleViewController : UIViewController

////头部图片
@property (copy, nonatomic) NSString *headImage;

/** 帖子id */
@property (copy, nonatomic) NSString *id;  

@property(strong,nonatomic) NSString * TYpe;

@property(strong,nonatomic) NSData * headimagedata;


/** <#注释#> */
@property (nonatomic, copy)  MYDeleteBlock deleteBlock;
@property(strong,nonatomic) NSString * Path; //从搜索列表进来的标示
@end
