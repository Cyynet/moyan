//
//  MYOrderList.h
//  魔颜
//
//  Created by Meiyue on 15/11/7.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYOrderList : NSObject

/**标题*/
@property (copy, nonatomic) NSString *title;

/**订单编号*/
@property (copy, nonatomic) NSString *orderCode;

/**支付方式*/
@property (copy, nonatomic) NSString *payBy;

/**姓名*/
@property (copy, nonatomic) NSString *name;

/**联系电话*/
@property (copy, nonatomic) NSString *phone;

/**服务机构*/
@property (copy, nonatomic) NSString *serviceAgency;

/**商品总额*/
@property (copy, nonatomic) NSNumber *actualPayment;

/**实付款*/


/**下单时间*/
@property (copy, nonatomic) NSString *orderTime;

//设计师

@property(strong,nonatomic) NSString * userName;

@property(strong,nonatomic) NSString * userPhone;


@property(strong,nonatomic) NSString * reserId;

@property(strong,nonatomic) NSString * payType;


@property(strong,nonatomic) NSString * designerPrice;

@property(strong,nonatomic) NSString * designer;


@property(strong,nonatomic) NSString * status;

@end
