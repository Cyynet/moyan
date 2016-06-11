//
//  AliPayViewController.h
//  魔颜
//
//  Created by abc on 15/11/5.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYAliPayViewController : UIViewController



@property(strong,nonatomic) NSString * seller;

@property(strong,nonatomic) NSString * privateKey;
@property(strong,nonatomic) NSString * serviece;
@property(strong,nonatomic) NSString * partner;

@property(strong,nonatomic) NSString * inputCharset;
@property(strong,nonatomic) NSString * notifyURL;
@property(strong,nonatomic) NSString * tradeNO;
@property(strong,nonatomic) NSString * productName;
@property(strong,nonatomic) NSString * paymentType;

@property(strong,nonatomic) NSString * sign_type;

@property(strong,nonatomic) NSString * amount;
@property(strong,nonatomic) NSString * productDescription;
@property(strong,nonatomic) NSString * itBPay;


//调转页面的 参数
@property(strong,nonatomic) NSString * shangpinmingcheng;

@property(strong,nonatomic) NSString * shangpinmiaoshu;


@property(strong,nonatomic) NSString * price;

@property(strong,nonatomic) NSString * dingdanhao;

@property(strong,nonatomic) NSString * PayPath; // 用来支付后回跳判断标示

@end
