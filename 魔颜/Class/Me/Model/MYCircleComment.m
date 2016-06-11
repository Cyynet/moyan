//
//  MYComment.m
//  魔颜
//
//  Created by Meiyue on 15/10/9.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYCircleComment.h"
#import "MYCircleReply.h"

@implementation MYCircleComment

- (NSDictionary *)objectClassInArray
{
    return @{@"replyVOs" : [MYCircleReply class] } ;
    
}

@end
