//
//  MYRelatedBtn.m
//  魔颜
//
//  Created by Meiyue on 16/1/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYRelatedBtn.h"

@implementation MYRelatedBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView.layer.cornerRadius = 37;
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        [self setTitleColor:titlecolor forState:UIControlStateNormal];
        self.titleLabel.font = leftFont;
        
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat labelW = contentRect.size.width + kMargin;
    CGFloat labelH = MYMargin;
    CGFloat labelX = 0;
    CGFloat labelY = contentRect.size.height + 5;
    
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
