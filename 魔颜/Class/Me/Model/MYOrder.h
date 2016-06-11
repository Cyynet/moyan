//
//  MYOrder.h
//  魔颜
//
//  Created by Meiyue on 15/11/2.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYOrder : NSObject

//类型
@property (copy, nonatomic) NSString *type;

/**创建时间*/
@property (copy, nonatomic) NSString *ctime;

/**标题*/
@property (copy, nonatomic) NSString *title;

/**单价*/
@property (copy, nonatomic) NSNumber *price;

/**总价*/
@property (copy, nonatomic) NSNumber *sumall;

/**描述*/
@property (copy, nonatomic) NSString *dis;

/**是否评价*/
@property (copy, nonatomic) NSString *isEvaluat;

/**数量*/
@property (copy, nonatomic) NSNumber *num;

/**图片*/
@property (copy, nonatomic) NSString *pic;

/**状态*/
/**
 *  0 未付款
    1 已付款
    2 已完成
    8 
    9
 */
@property (nonatomic, assign) NSInteger status;

/**订单id*/
@property (copy, nonatomic) NSString *id;

/** 标记是不是用到正文里的 */
@property(assign, nonatomic,getter=isDetail) BOOL isDetail;



@end
