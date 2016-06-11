//
//  MYTieziModel.m
//  魔颜
//
//  Created by Meiyue on 15/10/27.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYTieziModel.h"

@implementation MYTieziModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"doctorList" : [doctorListModel class] ,
             @"speList" : [MYDiscountListModel class]
             } ;
 
}

@end
