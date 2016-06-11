//
//  MYServiceLike.h
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYServiceLike : NSObject

/** id */
@property (copy, nonatomic) NSString *id;

/** title */
@property (copy, nonatomic) NSString *title;

/** 原价 */
@property (copy, nonatomic) NSString *price;

/** 特惠价 */
@property (copy, nonatomic) NSString *discountPrice;

/** 图片 */
@property (copy, nonatomic) NSString *listPic;

/** 美容院 */
@property (copy, nonatomic) NSString *salonName;

/** 短标题 */
@property (copy, nonatomic) NSString *shortTitle;

/** 描述 */
@property (copy, nonatomic) NSString *desc;

/** <#name#> */
@property (copy, nonatomic) NSString *name;

/** 纬度 */
@property(assign,nonatomic) double  latitude;

/** 经度 */
@property(assign,nonatomic) double  longitude;



@end
