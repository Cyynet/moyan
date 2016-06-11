//
//  MYRegionViewController.h
//  魔颜
//
//  Created by 易汇金 on 15/10/4.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBlock)(NSString *city);

@interface MYRegionViewController : UITableViewController

@property (nonatomic,copy) MyBlock myBlock;

@property (copy, nonatomic) NSString *currentCity;

@end
