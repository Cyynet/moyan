//
//  doctordeatilListModel.h
//  魔颜
//
//  Created by abc on 15/10/19.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface doctordeatilListModel : NSObject

@property(copy,nonatomic) NSString *address;

@property(copy,nonatomic) NSString *goodProject;

@property(copy,nonatomic) NSString *caseNum;

@property(copy,nonatomic) NSString *hospital;


@property(copy,nonatomic) NSString * overseasExp;

@property(copy,nonatomic) NSString * workexp;


@property(copy,nonatomic) NSString * introduction;

//奖项
@property(copy,nonatomic) NSString * honor;

@property(copy,nonatomic) NSString * infoPic;

@property(copy,nonatomic) NSString * reputation;

@property(strong,nonatomic) NSString * docCode;
@property (strong, nonatomic) NSString * name;

@property (assign, nonatomic) double  hospitallatitude;

@property (assign, nonatomic)  double hospitalLongitude;

@property(strong,nonatomic) NSString * qualification;
@property(strong,nonatomic) NSString * hospitalName;


@end
