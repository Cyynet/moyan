//
//  MYAttention.h
//  魔颜
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYAttention : NSObject

@property (assign, nonatomic) NSInteger CLASSIFICATION;
@property(strong,nonatomic) NSString * id;

@property (copy, nonatomic) NSString *address;

@property(copy,nonatomic) NSString *  caseNum;

//资质编号
@property(strong,nonatomic) NSString * docCode;
//擅长项目
@property(copy,nonatomic) NSString * goodProject;
@property(copy,nonatomic) NSString * hospitalId;

//标签
@property(copy,nonatomic) NSString * lable;

//头像
@property(strong,nonatomic) NSString * listPic;
@property(copy,nonatomic) NSString * name;
@property(copy,nonatomic) NSString * qualification;
@property(strong,nonatomic) NSString * reputation;



//内容
@property (copy, nonatomic) NSString *content;
//创建日期
@property (copy, nonatomic) NSString *createTime;

//用户图像
@property (copy, nonatomic) NSString *userPic;

//用户上传的照片
@property (copy, nonatomic) NSString *pic;

//userName
@property (copy, nonatomic) NSString *userName;

//标签
@property (copy, nonatomic) NSString *secProCode;

//帖子评论
@property (copy, nonatomic) NSString *countComments;

//赞
@property (copy, nonatomic) NSString *countPraise;

@property (copy, nonatomic) NSString *title;

@property(strong,nonatomic) NSString * homePagePic;

@end
