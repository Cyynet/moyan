//
//  MYHomeNewFormMoreBtnCollectionViewController.h
//  魔颜
//
//  Created by abc on 16/4/27.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYHomeNewFormMoreBtnCollectionViewController : UICollectionViewController

@property(strong,nonatomic) NSString * id;

@property(assign,nonatomic) NSInteger  modle;

@property(assign,nonatomic) int  section;


/** 标题 */
@property (copy, nonatomic) NSString *titleName;

@end
