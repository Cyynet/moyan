//
//  MYSalonSpe.h
//  魔颜
//
//  Created by Meiyue on 16/4/14.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSalonSpe : NSObject

/** 美容ID */
@property (nonatomic, assign) NSInteger id;

/** 上标图片是否显示 */
@property (copy, nonatomic) NSString *marking;

/** 图片 */
@property (copy, nonatomic) NSString *listPic;

/** title */
@property (copy, nonatomic) NSString *title;

/** 特惠价 */
@property (copy, nonatomic) NSString *discountPrice;

/** 原价 */
@property (copy, nonatomic) NSString *price;

/** 纬度 */
@property(assign,nonatomic) double  latitude;

/** 经度 */
@property(assign,nonatomic) double  longitude;





@end
