//
//  MYForget3ViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/8.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYForget3ViewController.h"
#import "MYForget4ViewController.h"
#import "MYStringFilterTool.h"
#import "MYResisterViewController.h"
#import "MYHeader.h"
#define deatiltextcolor  MYColor(109, 109, 109)
@interface MYForget3ViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) UITextField *secretField;

@end

@implementation MYForget3ViewController

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
    label.frame = CGRectMake(20, 70, self.view.width - 40, 35);
    label.textColor = subTitleColor;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"1输入账号>2验证身份>3设置新密码>4完成"];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0] range:NSMakeRange(12, 6)];
   	[str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(12,6)];
    label.attributedText = str;
    label.font = leftFont;
    [self.view addSubview:label];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(20, 120, self.view.width - 40, 35);
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:view];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(55, 0, view.width - 40, 30);
    textField.placeholder = @"请输入您的新密码";
    textField.font = leftFont;
    textField.delegate = self;
    self.secretField = textField;
    [view addSubview:textField];
    
    UILabel *label0 = [[UILabel alloc] init];
    label0.text = @"新密码:";
    label0.frame = CGRectMake(5, 0,50, textField.height);
    label0.textColor = subTitleColor;
    label0.font = MYFont(12);
    [view addSubview:label0];


    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(20, 160, self.view.width - 20, 60);
    label1.numberOfLines = 0;
    label1.font = leftFont;
    label1.textColor = subTitleColor;
    label1.text = @"*密码必须为6-16位字符,由字符加符号或数字组合而成,且不能单独使用字符,符号或数字";
    [self.view addSubview:label1];

    
    UIButton *stepBtn = [[UIButton alloc]init];
    stepBtn.frame = CGRectMake(20, 250, self.view.width - 40, 35);
    [stepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    stepBtn.layer.cornerRadius = 5;
    stepBtn.layer.masksToBounds = YES;
    stepBtn.backgroundColor = deatiltextcolor;
    stepBtn.adjustsImageWhenHighlighted = NO;
    stepBtn.titleLabel.font = leftFont;
    [stepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [stepBtn addTarget:self action:@selector(clickStepBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stepBtn];
}
- (void)clickStepBtn
{
    
    if ([self checkInput]) {

//        NSString *userName = [MYUserDefaults objectForKey:@"userName"];
    
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"code"] = self.phone;
        params[@"password"] = [MYStringFilterTool getmd5WithString:self.secretField.text];

        
        [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@user/modifyPassword",kOuternet1] params:params success:^(id responseObject) {
            
           NSString *status = [responseObject objectForKey:@"status"];
           
                if ([status isEqualToString:@"-205"]) {
        
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您还为注册,请先注册" message:@"先去注册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    
                }else{
                    
                    MYForget4ViewController *forget4VC = [[MYForget4ViewController alloc] init];
                    forget4VC.secret = self.secretField.text;
                    [self.navigationController pushViewController:forget4VC animated:YES];
                }
            } failure:^(NSError *error) {

            }];
    }

}
- (BOOL)checkInput
{
    BOOL passWordNumGood = [MYStringFilterTool filterByLoginPassWord:self.secretField.text];
    
    if (!passWordNumGood) {
        [MBProgressHUD showError:@"密码格式输入有误"];
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
    [_secretField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        MYResisterViewController *resignVC = [[MYResisterViewController alloc] init];
        [self.navigationController pushViewController:resignVC animated:YES];
    }
}

@end
