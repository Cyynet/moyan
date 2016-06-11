//
//  designerdeatilModel.h
//  魔颜
//
//  Created by abc on 15/10/19.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface designerdeatilModel : NSObject


@property(copy,nonatomic) NSString * overseasExp;

@property(copy,nonatomic) NSString * introduction;

@property(copy,nonatomic) NSString * buniess;

@property(copy,nonatomic) NSString * pic;
@property(weak,nonatomic) NSString * bigPic;


@property(copy,nonatomic) NSString * avatar;

@property(copy,nonatomic) NSString * impression;

//资质
@property(strong,nonatomic) NSString * qualification;


@property(copy,nonatomic) NSString * name;
//设计师费
@property(copy,nonatomic) NSString * price;

@property(strong,nonatomic) NSString * id;

@property (assign, nonatomic) double latitude;

@property (assign, nonatomic) double  longitude;

@property(strong,nonatomic) NSString * originalPrice;


@end
