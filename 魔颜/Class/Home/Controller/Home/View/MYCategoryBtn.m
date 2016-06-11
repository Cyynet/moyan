//
//  WQCategoryBtn.m
//  魔颜
//
//  Created by 周文静 on 15/9/23.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYCategoryBtn.h"

@implementation MYCategoryBtn

+(instancetype)addbtn
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MYCategoryBtn" owner:nil options:nil]lastObject];
}

@end
