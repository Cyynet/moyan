//
//  MYqianggoumodel.h
//  魔颜
//
//  Created by abc on 16/4/15.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYqianggoumodel : NSObject

@property(strong,nonatomic) NSString * id;

@property(strong,nonatomic) NSString  * time;

@property(strong,nonatomic) NSString * bannerPath;

@property(strong,nonatomic) NSString * type; //1 倒计时 2剩余量  0 普通

@property(strong,nonatomic) NSString * url;

@property(strong,nonatomic) NSString * surpluss;//剩余量


@end
