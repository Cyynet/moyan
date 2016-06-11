//
//  MYPicModel.h
//  魔颜
//
//  Created by Meiyue on 16/5/10.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYPicModel : NSObject

/** 广告ID */
@property (copy, nonatomic) NSString *id;

/** 广告标题 */
@property (copy, nonatomic) NSString *title;

/** 广告地址 */
@property (copy, nonatomic) NSString *pic;

/** 广告链接 */
@property (copy, nonatomic) NSString *url;

@end
