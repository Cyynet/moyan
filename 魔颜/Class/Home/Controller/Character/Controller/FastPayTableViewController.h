//
//  FastPayTableViewController.h
//  魔颜
//
//  Created by abc on 16/1/28.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastPayTableViewController : UIViewController

@property(strong,nonatomic) NSString * vctittle;      //标题

@property(strong,nonatomic) NSString * youhuiPrice; //优惠条件 满足减免条件

@property(strong,nonatomic) NSString * discountPrice;    //减免多少

@property(strong,nonatomic) NSString * realityPrice; //实付款

@property(strong,nonatomic) NSString * organization;  //机构名称

@property(strong,nonatomic) NSString * solanID;     //美容院


@property(strong,nonatomic) NSString * Vctag; //判读是医院还是美容院

@end
