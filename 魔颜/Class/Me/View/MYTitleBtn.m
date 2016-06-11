//
//  MYTitleBtn.m
//  魔颜
//
//  Created by Meiyue on 15/10/12.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYTitleBtn.h"

@implementation MYTitleBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.height = 35;
        
        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.adjustsImageWhenHighlighted = NO;
        
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleH = self.height;
    CGFloat titleW = self.width - self.height * 0.5;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageH = self.height;
    CGFloat imageW = imageH * 0.6;
    CGFloat imageX = self.width - imageW * 0.7;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
    
}



@end
