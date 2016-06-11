//
//  MYUser.h
//  魔颜
//
//  Created by Meiyue on 15/10/9.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYUser : NSObject

/** name	string	显示名称 */
@property (copy, nonatomic) NSString *name;

/** profile_image_url	string	用户头像地址（中图），50×50像素 */
@property (copy, nonatomic) NSString *profile_image_url;

@end
