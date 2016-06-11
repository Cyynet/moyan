//
//  MYTool.m
//  魔颜
//
//  Created by 杨锐 on 15/10/29.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYDoctorListTool.h"

#define MYDoctorListFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"doctor.data"]
static NSMutableArray *_doctorLists;

@implementation MYDoctorListTool

+(NSMutableArray *)doctorLists
{
    if (!_doctorLists) {
        _doctorLists = [NSKeyedUnarchiver unarchiveObjectWithFile:MYDoctorListFile];
        
        if (!_doctorLists) {
            _doctorLists = [NSMutableArray array];
        }
    }
    return _doctorLists;
}
+ (void)saveDoctorList:(doctorListModel *)doctorListModel
{
    // 第一次启动手动调用doctorList创建数组，否则数据为空
    [self doctorLists];
    
    [_doctorLists removeObject:doctorListModel];
    
    [_doctorLists insertObject:doctorListModel atIndex:0];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:_doctorLists toFile:MYDoctorListFile];
}

+ (void)deleteDoctorList:(doctorListModel *)doctorListModel
{
    [_doctorLists removeObject:doctorListModel];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:doctorListModel toFile:MYDoctorListFile];
}

+ (void)deleteDoctorLists:(NSArray *)doctorLists
{
    [_doctorLists removeObjectsInArray:doctorLists];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:_doctorLists toFile:MYDoctorListFile];
}


@end
