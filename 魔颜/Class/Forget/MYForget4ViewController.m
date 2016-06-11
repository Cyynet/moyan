//
//  MYForget4ViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/8.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYForget4ViewController.h"
#import "MYLoginViewController.h"
#import "MYHeader.h"
#define deatiltextcolor  MYColor(109, 109, 109)

@interface MYForget4ViewController ()

@end

@implementation MYForget4ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self step3];

}

- (void)step3
{
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(25);
        make.top.mas_equalTo(27);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *loginLable = [[UILabel alloc] init];
    loginLable.frame = CGRectMake(0, 0, self.view.width, 80);
    loginLable.text = @"找回密码";
    loginLable.font = leftFont;
    loginLable.textColor = titlecolor;
    loginLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loginLable];

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(30, 70, self.view.width - 60, 35);
    label.textColor = [UIColor grayColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"1输入账号>2验证身份>3设置新密码>4完成"];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0] range:NSMakeRange(19, 3)];
   	[str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(19,3)];
    label.attributedText = str;
    label.font = leftFont;
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(20, 125, self.view.width - 20, 40);
    label1.text = [NSString stringWithFormat:@"您的新密码设置成功:%@",self.secret];
    label.numberOfLines = 0;
    label1.font = leftFont;
    label1.textColor = subTitleColor;
    [self.view addSubview:label1];
    
    
    UIButton *stepBtn = [[UIButton alloc]init];
    stepBtn.frame = CGRectMake(20, 200, self.view.width - 40, 35);
    [stepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    stepBtn.layer.cornerRadius = 5;
    stepBtn.layer.masksToBounds = YES;
    stepBtn.backgroundColor = deatiltextcolor;
    stepBtn.titleLabel.font = leftFont;
    stepBtn.adjustsImageWhenHighlighted = NO;
    [stepBtn setTitle:@"完成" forState:UIControlStateNormal];
    [stepBtn addTarget:self action:@selector(clickStepBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stepBtn];
    
}
- (void)clickStepBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
