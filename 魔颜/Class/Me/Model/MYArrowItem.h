//
// MYArrowItem//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYBaseItem.h"

@interface MYArrowItem : MYBaseItem

@property(assign, nonatomic) Class destVC;

-(instancetype)initWithtitle:(NSString *)title  destVC:(Class)destVC;

+(instancetype)itemWithtitle:(NSString *)title destVC:(Class)destVC;


@end
