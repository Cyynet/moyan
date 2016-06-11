//
//  MYHomeStoreDiaryModle.h
//  魔颜
//
//  Created by abc on 16/2/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYHomeStoreDiaryModle : NSObject

@property(strong,nonatomic) NSString * id;
@property(strong,nonatomic) NSString * classify;
@property(strong,nonatomic) NSString * price;
@property(strong,nonatomic)  NSString* listPic;     //大图
@property(strong,nonatomic) NSString * countryPic;  //小图标

@property(strong,nonatomic) NSString * countryTitel;
@property(strong,nonatomic) NSString * discountPrice;
@property(strong,nonatomic) NSString * TITLE;



@end
