//
//  MYPersonalInfo.h
//  魔颜
//
//  Created by Meiyue on 15/10/25.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYUserModel;

@interface MYUserInfoTool : NSObject

+ (void)save:(MYUserModel *)userInfo;
+ (MYUserModel *)userInfo;

/** 记住用户登录状态 */
+ (void)saveFirstRunStatus:(NSString *)userStatus;
+ (BOOL)readUserStatus; 

@end
