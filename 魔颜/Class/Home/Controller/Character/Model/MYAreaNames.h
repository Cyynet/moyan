//
//  MYAreaNames.h
//  魔颜
//
//  Created by Meiyue on 16/3/20.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYAreaNames : NSObject

/** 地区 */
@property (copy, nonatomic) NSString *areaName;

/** 地区id */
@property (copy, nonatomic) NSString *areaId;

/** 商圈 */
@property (strong, nonatomic) NSArray *trading;

@end
