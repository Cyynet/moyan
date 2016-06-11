//
//  MYPublicBtn.m
//  魔颜
//
//  Created by Meiyue on 16/5/10.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYPublicBtn.h"

@implementation MYPublicBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:MYColor(128,128,128) forState:UIControlStateNormal];
        self.titleLabel.font = MYSFont(10);
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

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat labelW = contentRect.size.width;
    CGFloat labelH = MYMargin;
    CGFloat labelX = 0;
    CGFloat labelY = contentRect.size.height - 2;
    
    return CGRectMake(labelX, labelY, labelW, labelH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageH = contentRect.size.height;
    CGFloat imageW = imageH;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
