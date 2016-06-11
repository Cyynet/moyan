//
//  MYMenuBtn.m
//  魔颜
//
//  Created by 易汇金 on 15/10/3.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYMenuBtn.h"

@implementation MYMenuBtn


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupMenuBtn];
    }
    return self;
}
- (void)setupMenuBtn
{
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 1;
    self.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
    
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    
    [self setTitleColor:UIColorFromRGB(0xb5a653) forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.backgroundColor = [UIColor whiteColor];
    [self setBackgroundImage:[UIImage imageNamed:@"reporttop2"] forState:UIControlStateSelected];

}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}

-(void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
