//
//  MYFinishViewController.h
//  魔颜
//
//  Created by Meiyue on 15/10/20.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYOrder.h"

@interface MYFinishViewController : UIViewController

@property (copy, nonatomic) NSString *id;

@property (nonatomic, assign) BOOL isShow;


/** 1.设计师  2.特惠 */
@property (copy, nonatomic) NSString *type;

@property(strong,nonatomic) NSNumber * sumPrice;

@property(strong,nonatomic) NSString * status;

@property (strong, nonatomic) MYOrder *orderLists;


@end
