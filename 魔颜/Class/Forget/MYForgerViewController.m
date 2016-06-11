//
//  MYForgerViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/8.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYForgerViewController.h"
#import "MYForget2ViewController.h"
#import "MYStringFilterTool.h"
#import "MYHeader.h"
#define deatiltextcolor  MYColor(109, 109, 109)
@interface MYForgerViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) UITextField *accountField;
@property (weak, nonatomic)  UIImageView *navBarHairlineImageView;

@end

@implementation MYForgerViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navBarHairlineImageView.hidden = NO;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xeaeaea);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    [self.accountField becomeFirstResponder];
    self.tabBarController.tabBar.hidden = YES;
    self.navBarHairlineImageView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.title = @"找回密码";
    [self step1];
}

- (void)step1
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
    loginLable.font =leftFont;
    loginLable.textColor = titlecolor;
    loginLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loginLable];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 70, self.view.width - 40, 35);
    label.textColor = [UIColor grayColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"1输入账号>2验证身份>3设置新密码>4完成"];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0] range:NSMakeRange(0, 5)];
   	[str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,5)];
    label.attributedText = str;
    label.font = leftFont;
    [self.view addSubview:label];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(20, 120, self.view.width - 40, 35);
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:view];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(60, 1, view.width - 60, 30);
    textField.placeholder = @"手机号";
    textField.font = leftFont;
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = UIKeyboardTypePhonePad;
    self.accountField = textField;
    [view addSubview:textField];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"账号 :  ";
    label1.frame = CGRectMake(10, 0,40, textField.height);
    label1.textColor = subTitleColor;
    label1.font = leftFont;
    [view addSubview:label1];
    
    
    UIButton *stepBtn = [[UIButton alloc]init];
    stepBtn.frame = CGRectMake(20, 200, self.view.width - 40, 35);
    [stepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    stepBtn.layer.cornerRadius = 3;
    stepBtn.layer.masksToBounds = YES;
    stepBtn.backgroundColor = deatiltextcolor;
    stepBtn.titleLabel.font = leftFont;
    stepBtn.adjustsImageWhenHighlighted = NO;
    [stepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [stepBtn addTarget:self action:@selector(clickStepBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stepBtn];
}

- (void)clickStepBtn
{
    if ([self checkInput]) {
        
        MYForget2ViewController *forget2VC = [[MYForget2ViewController alloc] init];
        [forget2VC setPhone:self.accountField.text];
        [self.navigationController pushViewController:forget2VC animated:YES];
    }
    
    
}
- (BOOL)checkInput
{
    BOOL accountNumGood = [MYStringFilterTool filterByPhoneNumber:self.accountField.text];
    
    if (!accountNumGood) {
        
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return NO;
        
    }else{
        return YES;
    }
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_accountField resignFirstResponder];
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}



@end
