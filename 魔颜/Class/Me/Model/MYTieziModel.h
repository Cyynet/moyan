//
//  MYTieziModel.h
//  魔颜
//
//  Created by Meiyue on 15/10/27.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "doctorListModel.h"
#import "MYDiscountListModel.h"
@interface MYTieziModel : NSObject

//帖子上面的大图
@property (copy, nonatomic) NSString *homePagePic;

//内容
@property (copy, nonatomic) NSString *content;

//创建日期
@property (copy, nonatomic) NSString *createTime;

//ID
@property (copy, nonatomic) NSString *id;

//用户图像
@property (copy, nonatomic) NSString *userPic;

//用户上传的照片
@property (copy, nonatomic) NSString *pic;

//查看次数
@property (copy, nonatomic) NSString *pageView;

//userName
@property (copy, nonatomic) NSString *userName;

//标签
@property (copy, nonatomic) NSString *secProCode;

//帖子评论
@property (copy, nonatomic) NSString *countComments;

//赞
@property (copy, nonatomic) NSString *countPraise;

/** 标记是不是用到正文里的 */
@property(assign, nonatomic,getter=isDetail) BOOL isDetail;

/**标题*/
@property (copy, nonatomic) NSString *title;

/** 标记是不是用到我的关注里面的 */
@property(assign, nonatomic) BOOL isAttention;

@property (strong, nonatomic) NSArray<doctorListModel *> *doctorList;
@property (strong, nonatomic) NSArray<MYDiscountListModel *> *speList;

@property(strong,nonatomic) NSString * price;   // 原价


@end
