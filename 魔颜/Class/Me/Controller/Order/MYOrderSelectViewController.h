//
//  MYOrderSelectViewController.h
//  魔颜
//
//  Created by Meiyue on 15/10/12.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBlock)(NSInteger type);

@interface MYOrderSelectViewController : UIViewController

@property (nonatomic,copy) MyBlock myBlock;

@property (assign, nonatomic) NSInteger currentType;

@end
