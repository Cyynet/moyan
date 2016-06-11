//
//  MYOrderResultViewController.h
//  魔颜
//
//  Created by Meiyue on 16/5/18.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYOrderResultViewController : UIViewController

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *phoneNumber;

@property (copy, nonatomic) NSString *isLogin;

/** 用户ID */
@property (copy, nonatomic) NSString *userId;

@property (copy, nonatomic) NSString *address;

@property(strong,nonatomic) NSString * beizhu;

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

@property(strong,nonatomic) NSString * FROMEVC;

@property(strong,nonatomic) NSString  * Vctage; //判断 美容院和医院

@property(strong,nonatomic) NSString * jigoustr;//机构

@property(strong,nonatomic) NSString *receiptTime; //收货时间


@end
