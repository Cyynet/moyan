//
//  WeiXinZhiFuController.h
//  魔颜
//
//  Created by abc on 15/11/7.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYWeiXinZhiFuController : UIViewController

@property(strong,nonatomic) NSString * oderName;

@property(strong,nonatomic) NSString * oderPrice;

@property(strong,nonatomic) NSString * shangpingname;

@property(strong,nonatomic) NSString * shangpindeatil;

@property(strong,nonatomic) NSString * preice;

@property(strong,nonatomic) NSString * dingdanhao;


@property(strong,nonatomic) NSString * appId;       //appid

@property(strong,nonatomic) NSString * mchId;

@property(strong,nonatomic) NSString *  sign ;

@property(strong,nonatomic) NSString * oderid; //订单号

@property(strong,nonatomic) NSString * PayPath; // 用来支付后回跳判断标示

@end
