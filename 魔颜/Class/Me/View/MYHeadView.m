//
//  MYHeadView.m
//  魔颜
//
//  Created by Meiyue on 15/9/29.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYHeadView.h"

#define MYHeadX MYScreenW * 0.08
#define MYHeadY MYScreenH * 0.15 // 100
#define MYHeadW MYScreenW * 0.4  //150
#define MYHeadH 35
@interface MYHeadView ()
@property (weak, nonatomic) UILabel *alertLabel;
@property (weak, nonatomic) UIButton *loginBtn;
@end

@implementation MYHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupApperence];

    }
    return self;
}

//登陆前
- (void)setupApperence
{
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.frame = CGRectMake(MYHeadX, MYHeadY, MYHeadW, MYHeadH);
    alertLabel.text = @"您还没有登录哦";
    alertLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
    alertLabel.textColor = [UIColor whiteColor];
    self.alertLabel = alertLabel;
    [self addSubview:alertLabel];

    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame = CGRectMake(self.width / 2, MYHeadY, MYHeadW, MYHeadH);
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitle:@"马上登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:titlecolor forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:13.0];
    [loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    [self addSubview:loginBtn];
    
    
}

- (void)clickLoginBtn
{
    
    if ([self.delegate respondsToSelector:@selector(headView:)]){
        [self.delegate headView:self];
    }
    
}


@end
