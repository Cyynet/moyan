//
// MYArrowItem//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//


#import "MYArrowItem.h"

@implementation MYArrowItem

-(instancetype)initWithtitle:(NSString *)title destVC:(Class)destVC
{
    if (self = [super initWithtitle:title]) {
        
        self.destVC = destVC;
    }
    return self;
}

+(instancetype)itemWithtitle:(NSString *)title destVC:(Class)destVC
{
    return [[self alloc]initWithtitle:title destVC:destVC];
}




@end
