//
//  MYWeather.h
//  魔颜
//
//  Created by Meiyue on 16/5/30.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Weather,Ad;
@interface MYWeather : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) Weather *weather;

@property (nonatomic, strong) NSArray<Ad *> *ad;

@end

@interface Weather : NSObject
/** 城市 */
@property (nonatomic, copy) NSString *city;
/** 星期几 */
@property (nonatomic, copy) NSString *week;
/** 风力 */
@property (nonatomic, copy) NSString *WS;
/** 气温 */
@property (nonatomic, copy) NSString *temp;
/** 天气情况 */
@property (nonatomic, copy) NSString *weather;
/** 风向 */
@property (nonatomic, copy) NSString *WD;
/** 年 */
@property (nonatomic, copy) NSString *year;
/** 月 */
@property (nonatomic, copy) NSString *month;
/** 日 */
@property (nonatomic, copy) NSString *date;


@end

@interface Ad : NSObject

/** ID */
@property (nonatomic, assign) NSInteger id;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 链接 */
@property (nonatomic, copy) NSString *url;

/** 图片 */
@property (nonatomic, copy) NSString *bannerPath;

@end

