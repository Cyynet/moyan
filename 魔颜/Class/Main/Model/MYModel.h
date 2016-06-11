//
//  MYModel.h
//  魔颜
//
//  Created by Meiyue on 15/10/26.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYLoginUser.h"
@interface MYModel : NSObject

/** 是否是新用户 0 是 1 不是 */
@property (copy, nonatomic) NSString *isLogin;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic)  MYLoginUser *user;

@end
