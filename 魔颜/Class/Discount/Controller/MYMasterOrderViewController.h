//
//  MYMasterOrderViewController.h
//  魔颜
//
//  Created by abc on 16/3/31.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYMasterOrderViewController : UIViewController
@property(strong,nonatomic) NSString * qianggoutitle;
@property(strong,nonatomic) NSString * dingjin;
@property(strong,nonatomic) NSString * yuyuejia;
@property(strong,nonatomic) NSString * zongjia;
@property(strong,nonatomic) NSString * id;
@property (copy, nonatomic) NSString *hospotalId;

@property(strong,nonatomic) NSString  * Vctage;
@property(strong,nonatomic) NSString * jigoustr;//机构
@property(strong,nonatomic) NSString * lab;

@property(strong,nonatomic) NSString * LABLE;


@property(strong,nonatomic) NSString * bindDiscount;
@property(strong,nonatomic) NSString * depict;

@property(strong,nonatomic) NSString * number;  //判断是否隐藏数量的加减号

@end
/**
    status = "success",
	depict = "魔颜达人专享折扣价",
	isDiscount = "1",
	bindDiscount = "1847",
 */