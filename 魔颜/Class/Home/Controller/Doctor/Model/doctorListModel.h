//
//  doctorListModel.h
//  魔颜
//
//  Created by abc on 15/10/17.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface doctorListModel : NSObject


@property (copy, nonatomic) NSString *address;

@property(copy,nonatomic) NSString *  caseNum;
//擅长项目
@property(copy,nonatomic) NSString * goodProject;


@property(copy,nonatomic) NSString * hospitalId;

//标签
@property(copy,nonatomic) NSString * lable;


@property(copy,nonatomic) NSString * name;

//
@property(copy,nonatomic) NSString * qualification;


//头像
@property(strong,nonatomic) NSString * listPic;

//资质编号
@property(strong,nonatomic) NSString * docCode;
@property(strong,nonatomic) NSString * reputation;

@property(strong,nonatomic) NSString * id;




@end
