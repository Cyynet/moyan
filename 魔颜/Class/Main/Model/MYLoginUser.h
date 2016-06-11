//
//  MYLoginUser.h
//  魔颜
//
//  Created by Meiyue on 15/10/26.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYLoginUser : NSObject

/**用户ID*/
@property (copy, nonatomic) NSString *ID;

/**用户名*/
@property (copy, nonatomic) NSString *name;

/**姓名*/
@property (copy, nonatomic) NSString *realName;

/**用户手机号*/
@property (copy, nonatomic) NSString *phone;

/**用户名*/
@property (copy, nonatomic) NSString *code;

/**用户密码*/
@property (copy, nonatomic) NSString *password;

/**token*/
@property (copy, nonatomic) NSString *token;

/** 图片 */
@property (copy, nonatomic) NSString *pic;

/**地区*/
@property (copy, nonatomic) NSString *region;

/**性别*/
@property (copy, nonatomic) NSString *sex;

@end
