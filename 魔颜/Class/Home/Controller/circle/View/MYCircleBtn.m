//
//  MYCircleBtn.m
//  魔颜
//
//  Created by Meiyue on 15/11/20.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYCircleBtn.h"

@implementation MYCircleBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
           
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = MYSFont(15);
        self.adjustsImageWhenHighlighted = NO;
        [self setTitleColor:titlecolor forState:UIControlStateNormal];

    }
    return self;
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
