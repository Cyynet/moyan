//
//  MYHomeDesignerDeatilAppointmentViewController.h
//  魔颜
//
//  Created by abc on 15/10/8.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYHomeDesignerDeatilAppointmentViewController : UIViewController

//设计师id
@property(strong,nonatomic) NSString * desigerId;
//设计师费
@property(strong,nonatomic) NSString * desigerPrice;
@property(strong,nonatomic) NSString * name;
//资质
@property(strong,nonatomic) NSString * desigerzhizi;

@property(strong,nonatomic) NSString * originalPrice;//原价

@property(strong,nonatomic) NSString * VCtag;  //判断是banner调用还是设计师调用


@end
