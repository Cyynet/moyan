//
//  MYComment.h
//  魔颜
//
//  Created by Meiyue on 15/10/9.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MYUser;

@interface MYComment : NSObject

/** string	创建时间 */
@property (copy, nonatomic) NSString *created_at;

/** string	信息内容 */
@property (copy, nonatomic) NSString *title;

/** string	信息内容 */
@property (copy, nonatomic) NSString *text;

/** user	object	作者的用户信息字段 详细 */
@property (strong, nonatomic) MYUser *user;

/**  是否用在详情 */
@property(assign, nonatomic,getter=isDetail) BOOL isDetail;

@end
