//
//  MYLifeSecondModle.h
//  魔颜
//
//  Created by abc on 16/2/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYLifeSecondModle : NSObject

@property(strong,nonatomic) NSString * id;
@property(strong,nonatomic) NSString * title;
@property(strong,nonatomic) NSString * price;

@property(strong,nonatomic) NSString * listPic;
@property(strong,nonatomic) NSString * salonName;
@property(strong,nonatomic) NSString * desc;
@property(strong,nonatomic) NSString * discountPrice;
@property(assign,nonatomic) float  zeKou;

#pragma mark--首页的更多页面需要
@property(strong,nonatomic) NSString * shortTitle;
@property(strong,nonatomic) NSString * salonType;
@property(strong,nonatomic) NSString * name;


@end
