//
//  MYTagTool.h
//  魔颜
//
//  Created by Meiyue on 16/4/15.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYSortsModel.h"

@interface MYTagTool : NSObject

//体验里面的地区
+(NSArray *)areas;

// 所有的美容
+(NSArray *)beauties;

// 所有的分类
+(NSArray *)hospitals;

//返回所有的美购数据
+(NSArray *)owns;

// 存储用户最近选择的标签到沙盒
//+ (void)save:(MYSortsModel *)userInfo;
//+ (MYSortsModel *)userInfo;

+ (void)saveBeauty:(NSArray *)userInfo;
+ (NSArray *)readBeautyInfo;

+ (void)saveHospital:(NSArray *)userInfo;
+ (NSArray *)readHospitalInfo;

+ (void)saveOwn:(NSArray *)userInfo;
+ (NSArray *)readOwnInfo;


+(NSArray *)arrayWithString:(NSString *)string;


@end
