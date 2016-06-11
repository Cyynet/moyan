//
//  MYAdModel.h
//  魔颜
//
//  Created by Meiyue on 16/4/18.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYAdModel : NSObject

/** 广告ID */
@property (copy, nonatomic) NSString *id;

/** 广告地址 */
@property (copy, nonatomic) NSString *bannerPath;

/** 广告链接 */
@property (copy, nonatomic) NSString *url;

@end
