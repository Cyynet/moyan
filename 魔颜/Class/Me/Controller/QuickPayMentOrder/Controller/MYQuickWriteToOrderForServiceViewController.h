//
//  MYWriteToOrderViewController.h
//  魔颜
//
//  Created by abc on 16/5/18.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYQuickWriteToOrderForServiceViewController : UIViewController

/**
 *  商品
 */
/** 标题 */
@property (copy, nonatomic) NSString *goodsTitle;

/** ID */
@property (copy, nonatomic) NSString *id;

/** 特惠价 */
@property (copy, nonatomic) NSString *discountPrice;

/** 原价 */
@property (copy, nonatomic) NSString *price;

/** 图片 */
@property (copy, nonatomic) NSString *listPic;

@property(strong,nonatomic) NSString * jigoustr;

@property(strong,nonatomic) NSString * vctag;

@end
