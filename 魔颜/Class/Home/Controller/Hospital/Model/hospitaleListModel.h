//
//  hospitaleListModel.h
//  魔颜
//
//  Created by abc on 15/10/19.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hospitaleListModel : NSObject



@property(copy,nonatomic) NSString * listPic;

@property(copy,nonatomic) NSString * id;

@property(copy,nonatomic) NSString * name;


@property(copy,nonatomic) NSString * address;

@property(copy,nonatomic) NSString * feature;


@property(strong,nonatomic) NSString * casenum;

@property(strong,nonatomic) NSString * qualification;

//活动
@property(strong,nonatomic) NSString * tag;



@property(assign,nonatomic) double  latitude;

@property(assign,nonatomic) double  longitude;

@property(strong,nonatomic) NSString * approve;//  承诺字段


@property(strong,nonatomic) NSString * type;

//地址拼接 （美容院）
@property(strong,nonatomic) NSString * areaName; //朝阳区
@property(strong,nonatomic) NSString * cityName; //  北京市
@property(strong,nonatomic) NSString * tradingName; //三里屯



@end
