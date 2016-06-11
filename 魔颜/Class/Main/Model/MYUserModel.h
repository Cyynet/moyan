//
//  MYUserModel.h
//  魔颜
//
//  Created by Meiyue on 15/10/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYUserModel : NSObject

/**用户ID*/
@property (assign, nonatomic) NSInteger id;

/**用户图像*/
@property(nonatomic,copy) NSString *pic;

/**用户昵称*/
@property (copy, nonatomic) NSString *name;

/**用户性别*/
@property (assign, nonatomic) NSInteger sex;

/**出生日期*/
@property (copy, nonatomic) NSString *birthday;

/**用户所在地*/
@property (copy, nonatomic) NSString *region;

/**联系电话*/
@property (copy, nonatomic) NSString *phone;

/** 邀请码 */
@property (assign, nonatomic) NSInteger inviteNum;

/*
 @brief 详细资料
 */
/**家庭收入*/
@property (copy, nonatomic) NSString *income;
/**兴趣爱好*/
@property (copy, nonatomic) NSString *interests;
/**驾驶车辆*/
@property (copy, nonatomic) NSString *cars;
/**家庭成员*/
@property (copy, nonatomic) NSString *family;
/**别人对我的看法*/
@property (copy, nonatomic) NSString *views;
/**希望哪变美*/
@property (copy, nonatomic) NSString *hopes;


/**用户明文密码*/
@property (copy, nonatomic) NSString *userPassWord;

/**用户登录后获得的临时Token(7天有效期)*/
@property (copy, nonatomic) NSString *userToken;

@end