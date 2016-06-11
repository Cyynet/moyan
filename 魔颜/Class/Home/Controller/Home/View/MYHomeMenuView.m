//
//  MYHomeMenuView.m
//  魔颜
//
//  Created by Meiyue on 16/4/9.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYHomeMenuView.h"
#import "MYMenuButton.h"

#define MaxCols 3

@implementation MYHomeMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self addBtnWithTitle:@"去美容" imageName:@"去美容图标" andMenuType:UIMenuBtnStyleBeauty];
    [self addBtnWithTitle:@"去整形" imageName:@"整形图标" andMenuType:UIMenuBtnStyleHospital];
    [self addBtnWithTitle:@"护肤品" imageName:@"去美购图标" andMenuType:UIMenuBtnStyleGoods];
    
    return self;
}


- (MYMenuButton *)addBtnWithTitle:(NSString *)title imageName:(NSString *)imageName andMenuType:(UIMenuBtnStyle )btnStyle;
{
    MYMenuButton *btn = [[MYMenuButton alloc]init];
    btn.tag = btnStyle;
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.backgroundColor = [UIColor whiteColor];
    return btn;
}

- (void)clickMenuBtn:(MYMenuButton *)shareBtn
{
    
    if (self.btnType) {
        self.btnType(shareBtn.tag);
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat btnW = (MYScreenW - 55*4) / MaxCols;
    CGFloat btnH = btnW;
    CGFloat btnY = 10;
    
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
