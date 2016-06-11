//
//  MYTopBtn.m
//  魔颜
//
//  Created by Meiyue on 15/9/29.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYTopBtn.h"

@interface MYTopBtn ()

@end

@implementation MYTopBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        // 1.文字颜色
        [self setTitleColor:titlecolor forState:UIControlStateNormal];
        [self setTitleColor:MYRedColor forState:UIControlStateSelected];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = MYFont(13);
        
//        // 2.设置按钮右边的箭头
//        [self setImage:[UIImage imageNamed:@"1.pic_03"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"1.pic_04"] forState:UIControlStateSelected];

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


//// 左文字的frame
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat titleX = -15;
//    CGFloat titleY = 0;
//    CGFloat titleH = self.height;
//    CGFloat titleW = MYScreenW / 2.4;
//    
//    return CGRectMake(titleX, titleY, titleW, titleH);
//}
//
//// 右图片的frame
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    //小箭头
//    CGFloat imageY = contentRect.size.height * 0.44;
//    CGFloat imageW = 10;
//    CGFloat imageH = 5.5;
//    CGFloat imageX = contentRect.size.width * 0.8;
//    
//    return CGRectMake(imageX, imageY, imageW, imageH);
//}


@end
