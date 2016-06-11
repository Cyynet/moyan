//
//  AlipayOrder.h
//  魔颜
//
//  Created by abc on 15/11/4.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject


@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller;
@property(nonatomic, copy) NSString * tradeNO;
@property(nonatomic, copy) NSString * productName;
@property(nonatomic, copy) NSString * productDescription;
@property(nonatomic, copy) NSString * amount;
@property(nonatomic, copy) NSString * notifyURL;

@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * paymentType;
@property(nonatomic, copy) NSString * inputCharset;
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;
@property(copy,nonatomic) NSString * signstr; //    签名

@property(copy,nonatomic) NSString * appenvstr; //   客户端来源



@property(nonatomic, copy) NSString * rsaDate;//可选
@property(nonatomic, copy) NSString * appID;//可选

@property(nonatomic, readonly) NSMutableDictionary * extraParams;
@end
