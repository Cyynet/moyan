//
//  MYTopBtn.h
//  魔颜
//
//  Created by Meiyue on 15/9/29.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYTopBtn : UIButton

@property (copy, nonatomic) NSString *title;

-(void)addTarget:(id)target action:(SEL)action;
- (void)setTitle:(NSString *)title;

@end
