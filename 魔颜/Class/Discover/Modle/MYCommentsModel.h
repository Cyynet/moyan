//
//  MYCommentsModel.h
//  魔颜
//
//  Created by Meiyue on 16/5/11.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYCommentsModel : NSObject

/** ID */
@property (copy, nonatomic) NSString *id;

/** 创建日期 */
@property (copy, nonatomic) NSString *createTime;

/** 发布文章ID */
@property (copy, nonatomic) NSString *publishId;

/** 父类用户名 */ 
@property (copy, nonatomic) NSString *fatherCommentUserName;

/** 顶楼评论ID */
@property (copy, nonatomic) NSString *totalCommentId;

/** 用户名 */
@property (copy, nonatomic) NSString *name;

/**  */
@property (copy, nonatomic) NSString *fatherCommentId;

/** 用户ID */
@property (copy, nonatomic) NSString *userid;

/** 用户图像 */
@property (copy, nonatomic) NSString *pic;

/** 标题 */
@property (copy, nonatomic) NSString *comment;


@end
