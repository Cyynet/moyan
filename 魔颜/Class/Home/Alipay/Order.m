//
//  AlipayOrder.m
//  魔颜
//
//  Created by abc on 15/11/4.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "Order.h"

@implementation Order


- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    if (self.service) {
        [discription appendFormat:@"service=\"%@\"",self.service];// //   接口名称mobile.securitypay.pay
    }
    if (self.partner) {
        [discription appendFormat:@"&partner=\"%@\"", self.partner];  //合作者id
    }
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8 商户网站使用的编码格式，固定为utf-8
    }
    if (self.rsaDate) {
        [discription appendFormat:@"&sign_type=\"%@\"",self.rsaDate];//     签名方式
    }
    if (self.signstr) {
        
        [discription appendFormat:@"&sign=\"%@\"", self.signstr];  //       签名
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];// 服务器异步通知页面路径
    }
    if (self.appID) {
//        [discription appendFormat:@"&app_id=\"%@\"",self.appID];    //     客户端号
    }
    if (self.appenvstr) {
        
//        [discription appendFormat:@"&appenv=\"%@\"",self.appenvstr];    //     客户端来源
        
    }
    if (self.tradeNO) {
        
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO]; // 订单号
    }
    if (self.productName) {
     
        [discription appendFormat:@"&subject=\"%@\"", self.productName]; // 商品名
    }
    if (self.paymentType) {
        
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1  支付类型
    }
    if (self.seller) {
        
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller]; //卖家支付宝账号
    }
    if (self.amount) {
     
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount]; //    总金额
    }
    if (self.productDescription) {
     
        [discription appendFormat:@"&body=\"%@\"", self.productDescription]; // 商品详情
    }

    
//    可空参数
    if (self.itBPay) {
     
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m 未付款交易的超时时间
    }
    if (self.showUrl) {
        
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
   
  
    for (NSString * key in [self.extraParams allKeys]) {
        
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    
    return discription;
}


@end
