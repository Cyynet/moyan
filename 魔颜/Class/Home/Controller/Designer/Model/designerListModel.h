//
//  designerListModel.h
//  魔颜
//
//  Created by abc on 15/10/19.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface designerListModel : NSObject


@property(copy,nonatomic) NSString * name;

@property(copy,nonatomic) NSString * qualification;

@property(copy,nonatomic) NSString * agency;



@property(copy,nonatomic) NSString * caseNum;

@property(strong,nonatomic) NSString * avatar;


@property(copy,nonatomic) NSString * workExp;

@property(strong,nonatomic) NSString * id;


@property(strong,nonatomic) NSArray * queryDesignersInfoList;


@property(strong,nonatomic) NSString * features;


@property(strong,nonatomic) NSString * endTime;

@property(strong,nonatomic) NSString * startTime;



@end
