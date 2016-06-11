//
//  BZStringFilterTool.m
//  pet668
//
//  Created by 蔡士林 on 15/9/24.
//  Copyright © 2015年 SSBun. All rights reserved.
//

#import "MYStringFilterTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"

@implementation MYStringFilterTool

/*
 @brief 登陆密码
 */
+ (BOOL)filterByLoginPassWord:(NSString *)passWord
{
    NSString *regex = @"^[A-Za-z0-9]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:passWord];
    return isMatch;
    
}

/*****
 * 手机正则匹配
 */
#define PHONENO  @"\\b(1)[34578][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b"
+(BOOL)filterByPhoneNumber:(NSString *)phone
{
    NSPredicate * telePhoneNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONENO];
    BOOL isTelephoneNumber = [telePhoneNumberPred evaluateWithObject:phone];
    return isTelephoneNumber;
}

/*
 @brief MD5加密
 */

+ (NSString*)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (unsigned int)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

/*
 @brief 当前毫秒值
 */
+ (NSString *)getTimeNow
{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    // 如果想转成int型，必须转成long long型才够大。
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    // 将double转为long long型
    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime];
    // 输出long long型
    return curTime;
    
}

/*
 @brief 数字签名
 */
+ (NSString *)getSignature
{
    //用户名
    NSString *code = [MYUserDefaults objectForKey:@"code"];
    //MD5对明文密码加密
    NSString *pwd = [MYUserDefaults objectForKey:@"password"];
    //当前毫秒值
    NSString *timeNow = [self getTimeNow];
    [MYUserDefaults setObject:timeNow forKey:@"time"];
    [MYUserDefaults synchronize];
    
    //MD5
    NSString *md5 = [self getmd5WithString:[NSString stringWithFormat:@"%@%@%@",code,pwd,timeNow]];
    //返回的数字签名
    //    return [NSString stringWithFormat:@"%@%@%@",md5,ID,timeNow];
    return md5;
    
}

/**
 @breif 设备唯一标示
 */

+ (NSString *)getUDID
{
    NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return identifier;
}

/**
 @breif 设备型号
 */

+ (NSString *)getDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *devCode;
    if ([platform isEqualToString:@"iPhone8,2"]) {
        devCode = @"iphone 6s Plus";
    }if ([platform isEqualToString:@"iPhone8,1"]) {
        devCode = @"iphone 6s";
    }if ([platform isEqualToString:@"iPhone7,2"]) {
        devCode = @"iphone 6";
    }if ([platform isEqualToString:@"iPhone7,1"]) {
        devCode = @"iphone 6 Pluse";
    }if ([platform isEqualToString:@"iPhone6,2"]) {
        devCode = @"iphone 5s";
    }if ([platform isEqualToString:@"iPhone6,1"]) {
        devCode = @"iphone 5s";
    }if ([platform isEqualToString:@"iPhone5,4"]) {
        devCode = @"iphone 5c";
    }if ([platform isEqualToString:@"iPhone5,3"]) {
        devCode = @"iphone 5c";
    }if ([platform isEqualToString:@"iPhone5,2"]) {
        devCode = @"iphone 5";
    }if ([platform isEqualToString:@"iPhone5,1"]) {
        devCode = @"iphone 5";
    }if ([platform isEqualToString:@"iPhone4,1"]) {
        devCode = @"iphone 4s";
    }if ([platform isEqualToString:@"iPhone3,3"]) {
        devCode = @"iphone 4";
    }if ([platform isEqualToString:@"iPhone3,2"]) {
        devCode = @"iphone 4";
    }if ([platform isEqualToString:@"iPhone3,1"]) {
        devCode = @"iphone 4";
    }
    
    return devCode;
    
    
}



@end
