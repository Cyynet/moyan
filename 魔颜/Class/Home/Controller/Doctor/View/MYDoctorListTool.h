//
//  MYTool.h
//  魔颜
//
//  Created by 杨锐 on 15/10/29.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class doctorListModel;

@interface MYDoctorListTool : NSObject

//返回请求的医生列表数据
+(NSMutableArray *)doctorLists;

//保存请求的医生列表
+(void)saveDoctorList:(doctorListModel *)doctorListModel;

+ (void)deleteDoctorList:(doctorListModel *)doctorListModel;
+ (void)deleteDoctorLists:(NSArray *)doctorLists;
@end
