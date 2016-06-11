//
//  MYSalonModel.h
//  魔颜
//
//  Created by Meiyue on 16/2/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYSalonListModel.h"

@interface MYSalonModel : NSObject

@property (copy, nonatomic) NSString *typeName;
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *TYPE_PIC;
@property (copy, nonatomic) NSString *type;

@property (strong, nonatomic) NSArray *speList;

@end
