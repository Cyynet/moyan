//
//  MYPersonalInfo.m
//  魔颜
//
//  Created by Meiyue on 15/10/25.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYUserInfoTool.h"
#import "MYUserModel.h"

#define kUserInfoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.data"]

#define kUserStatusPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userStatus.data"]


@implementation MYUserInfoTool
+ (void)save:(MYUserModel *)userInfo
{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:kUserInfoPath];
    
}

+ (MYUserModel *)userInfo
{
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:kUserInfoPath];
}

+ (void)saveFirstRunStatus:(NSString *)userStatus
{
    [NSKeyedArchiver archiveRootObject:userStatus toFile:kUserStatusPath];
}
+ (BOOL)readUserStatus
{
    BOOL status = [NSKeyedUnarchiver unarchiveObjectWithFile:kUserStatusPath];
    return  status;
    
}


@end
