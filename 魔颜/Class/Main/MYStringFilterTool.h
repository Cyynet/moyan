//
//  BZStringFilterTool.h
//  pet668
//
//  Created by 蔡士林 on 15/9/24.
//  Copyright © 2015年 SSBun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYStringFilterTool : NSObject

+ (BOOL)filterByLoginPassWord:(NSString *)passWord;

+ (BOOL)filterByPhoneNumber:(NSString *)phone;

+ (NSString *)getmd5WithString:(NSString *)string;

+ (NSString *)getTimeNow;
+ (NSString *)getSignature;

+ (NSString *)getUDID;

+ (NSString *)getDeviceType;


@end
