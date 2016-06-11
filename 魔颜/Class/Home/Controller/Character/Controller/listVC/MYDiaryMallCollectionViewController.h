//
//  MYDiaryMallCollectionViewController.h
//  魔颜
//
//  Created by Meiyue on 16/2/19.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYDiaryMallCollectionViewController : UIViewController

@property(strong,nonatomic) NSString*  TAGVC;



@property(assign,nonatomic) NSInteger  modle;

@property(assign,nonatomic) int  section;


/** 标题 */
@property (copy, nonatomic) NSString *titleName;
@end
