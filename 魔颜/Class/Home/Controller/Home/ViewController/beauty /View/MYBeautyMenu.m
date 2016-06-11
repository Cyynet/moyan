//
//  MYBeautyMenu.m
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYBeautyMenu.h"
#define MaxCols 3

@interface MYBeautyMenu ()

/** <#注释#> */
@property (weak, nonatomic) UIButton *lastBtn;


@end

@implementation MYBeautyMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    
     [self addBtnWithImageName:@"meirongyuan" SelectedImage:@"meirongyuan2" andMenuType:0];
     [self addBtnWithImageName:@"meirongfuwu" SelectedImage:@"meirongfuwu2" andMenuType:1];
     [self addBtnWithImageName:@"jinnangmiaoji" SelectedImage:@"jinnangmiaoji_selected" andMenuType:2];
    
    return self;
}


- (UIButton *)addBtnWithImageName:(NSString *)imageName SelectedImage:(NSString *)SelectedImage andMenuType:(int )tag;
{
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = tag;
    
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:SelectedImage] forState:UIControlStateSelected];

//    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:SelectedImage] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.backgroundColor = [UIColor whiteColor];
    return btn;
}

- (void)clickMenuBtn:(UIButton *)btn
{
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    
    if (self.btnType) {
        self.btnType(btn);
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat btnW = (MYScreenW - 55*4) / MaxCols;
    CGFloat btnH = btnW;
    CGFloat btnY = 30;
    
    NSUInteger count = self.subviews.count;
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x =  (i+1) * 55 + i*btnW ;
        btn.y = btnY;
        
    }
    
    
    
}

@end
