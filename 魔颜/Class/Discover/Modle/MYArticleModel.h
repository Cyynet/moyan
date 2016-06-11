//
//  MYArticleModel.h
//  魔颜
//
//  Created by Meiyue on 16/5/11.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYArticleModel : NSObject

/** 用户上传的照片 */
@property (copy, nonatomic) NSString *commentPic;

/** 创建日期 */
@property (copy, nonatomic) NSString *createTime;

/** 用户图像 */
@property (copy, nonatomic) NSString *userPic;

/** 阅读数 */
@property (copy, nonatomic) NSString *readNumber;

/** 用户ID */
@property (copy, nonatomic) NSString *userid;

/** 大图 */
@property (copy, nonatomic) NSString *homePic;

/** 喜欢 */
@property (copy, nonatomic) NSString *likeNumber;

/** 评论数 */
@property (copy, nonatomic) NSString *anwserNumber;

/** ID */
@property (copy, nonatomic) NSString *id;

/** 标题 */
@property (copy, nonatomic) NSString *title;

/** 用户名字 */
@property (copy, nonatomic) NSString *name;

/** 帖子内容 */
@property (copy, nonatomic) NSString *comment;


@end
