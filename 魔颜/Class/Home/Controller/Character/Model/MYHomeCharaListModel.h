//
//  MYHomeCharaListModel.h
//  魔颜
//
//  Created by abc on 16/1/15.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYHomeCharaListModel : NSObject

@property(copy,nonatomic) NSString * listPic;
@property(copy,nonatomic) NSString * id;
@property(copy,nonatomic) NSString * address;

@property(copy,nonatomic) NSString * feature;
//活动
@property(strong,nonatomic) NSString * tag;

@property(assign,nonatomic) double  latitude;

@property(assign,nonatomic) double  longitude;

@property(assign,nonatomic) NSString *  name;

@property(strong,nonatomic) NSString * type;


@end
