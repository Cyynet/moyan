//
//  WQTabBarController.h
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYBaseItem.h"

@implementation MYBaseItem

-(instancetype)initWithtitle:(NSString *)title
{
    if (self = [super init]) {
        
        self.title = title;
    }
    return self;
    
}

+(instancetype)itemWithtitle:(NSString *)title
{
    return [[self alloc] initWithtitle:title];
}





@end
