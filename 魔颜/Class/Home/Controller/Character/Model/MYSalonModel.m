//
//  MYSalonModel.m
//  魔颜
//
//  Created by Meiyue on 16/2/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYSalonModel.h"


@implementation MYSalonModel

-(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"des":@"description"};
}

- (NSDictionary *)objectClassInArray
{
    return @{@"speList" : [MYSalonListModel class] } ;
    
}



@end
