//
//  ColumnViewController.h
//  Column
//
//  Created by fujin on 15/11/18.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MySelectedBlock)(NSArray *selectedArray);

@interface MYColumnViewController : UIViewController
/**
 *  已选的数据
 */
@property (nonatomic, strong)NSMutableArray *selectedArray;
/**
 *  可选的数据
 */
@property (nonatomic, strong)NSMutableArray *optionalArray;

@property (copy, nonatomic) MySelectedBlock myBlock;
@end




