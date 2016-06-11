//
//  MYSearchResult.m
//  魔颜
//
//  Created by Meiyue on 15/11/4.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYSearchResult.h"

#import "MYTieziModel.h"
#import "doctorListModel.h"
#import "designerListModel.h"
#import "hospitaleListModel.h"
#import "MYDiscount.h"

@implementation MYSearchResult

-(NSDictionary *)objectClassInArray
{
    return @{
             
             @"searchInfo" : [MYTieziModel class],
             @"searchInfo" : [MYTieziModel class],
             @"searchInfo" : [MYTieziModel class],
             @"searchInfo" : [MYTieziModel class],
             @"searchInfo" : [MYTieziModel class]
             
             };
}


@end
