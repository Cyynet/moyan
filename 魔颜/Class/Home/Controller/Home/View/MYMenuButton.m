//
//  MYMenuButton.m
//  魔颜
//
//  Created by Meiyue on 16/4/9.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYMenuButton.h"

@implementation MYMenuButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //        self.adjustsImageWhenHighlighted = NO;
        [self setTitleColor:titlecolor forState:UIControlStateNormal];
        self.titleLabel.font = MYFont(13);
        self.titleLabel.textColor = UIColorFromRGB(0x4c4c4c);
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat labelW = contentRect.size.width+10;
    CGFloat labelH = MYMargin;
    CGFloat labelX = -5;
    CGFloat labelY = contentRect.size.height+15;
    
    return CGRectMake(labelX, labelY, labelW, labelH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.height;
    CGFloat imageH = imageW * 122 / 102;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}



@end
