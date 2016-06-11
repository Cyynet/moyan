//
//  MYtradingModel.h
//  魔颜
//
//  Created by Meiyue on 16/3/20.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYtradingModel : NSObject

/** 地区id */
//@property (nonatomic, assign) NSInteger areaId;
@property (copy, nonatomic) NSString *areaId;

/** 商圈id */
//@property (nonatomic, assign) NSInteger tradingId;
@property (copy, nonatomic) NSString *tradingId;

/** 商圈名字 */
@property (copy, nonatomic) NSString *tradingName;

@end
