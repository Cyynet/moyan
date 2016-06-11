//
//  MYOwnSpe.h
//  魔颜
//
//  Created by Meiyue on 16/4/14.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYOwnSpe : NSObject

/** 美购id */
@property (nonatomic, assign) NSInteger id;

/** 图片 */
@property (copy, nonatomic) NSString *smallPic;

/** 上标图片是否显示 */
@property (copy, nonatomic) NSString *marking;

/** title */
@property (copy, nonatomic) NSString *title;

/** 特惠价 */
@property (copy, nonatomic) NSString *discountPrice;

/** 原价 */
@property (copy, nonatomic) NSString *price;


@end
