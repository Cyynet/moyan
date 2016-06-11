//
//  MYComment.h
//  魔颜
//
//  Created by Meiyue on 15/10/9.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MYCircleDesComment,MYCircleReply;
@interface MYCircleComment : NSObject

@property (strong, nonatomic) MYCircleDesComment *diaryComments;

@property (strong, nonatomic) NSArray<MYCircleReply *> *replyVOs;

//赞 回复 组尾
@property (nonatomic, assign) NSInteger commentPraiseStatus;

@end
