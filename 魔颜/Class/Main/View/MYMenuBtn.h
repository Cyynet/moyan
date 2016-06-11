//
//  MYMenuBtn.h
//  魔颜
//
//  Created by 易汇金 on 15/10/3.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYMenuBtn : UIButton

@property (copy, nonatomic) NSString *title;

- (void)setTitle:(NSString *)title;
-(void)addTarget:(id)target action:(SEL)action;

@end
