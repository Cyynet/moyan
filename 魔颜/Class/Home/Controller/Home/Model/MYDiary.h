//
//  MYDiary.h
//  魔颜
//
//  Created by Meiyue on 16/4/14.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYDiary : NSObject

/** 体验日记id */
@property (nonatomic, assign) NSInteger id;
/**帖子标题 */
@property (copy, nonatomic) NSString *title;
/**帖子内容*/
@property (copy, nonatomic) NSString *content;
/**图片*/
@property (copy, nonatomic) NSString *homePagePic;

@property (nonatomic, copy) NSString *status;

/**用户名字*/
@property (copy, nonatomic) NSString *userName;
/**用户头像*/
@property (copy, nonatomic) NSString *userPic;
/**发帖时间*/
@property (copy, nonatomic) NSString *createTime;


/**
 *  首页体验日记
 */
/**图片*/
@property (copy, nonatomic) NSString *homePic;

/**帖子标题 */
@property (copy, nonatomic) NSString *noteTitle;

/**帖子内容*/
@property (copy, nonatomic) NSString *project;

/**角标*/
@property (copy, nonatomic) NSString *marking;



@end

