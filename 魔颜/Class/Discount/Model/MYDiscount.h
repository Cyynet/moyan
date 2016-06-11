//
//  MYDiscount.h
//  魔颜
//
//  Created by Meiyue on 15/10/8.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYDiscount : NSObject


@property(copy,nonatomic) NSString * id;

/**当前已购买数 */
@property (assign, nonatomic) int buyNumber;

//描述
@property(copy,nonatomic) NSString * desc;

/** 特惠类型 */
@property (copy, nonatomic) NSString *type;

/**特惠标题*/
@property(copy,nonatomic) NSString * typeName;

/**特惠首页图片*/
@property(copy,nonatomic) NSString * typePic;


/**
 @breif 下面的小段列表
 */

//小图
@property (copy, nonatomic) NSString *smallPic;

//标题
@property (copy, nonatomic) NSString *title;

//剩余时间
@property (copy, nonatomic) NSString *time;

//价格
@property (copy, nonatomic) NSString *price;

//医院名称
@property (copy, nonatomic) NSString *hospitalName;

//特惠价
@property (nonatomic, copy) NSString *discountPrice;

@property(copy,nonatomic) NSString * advertising;


@end
