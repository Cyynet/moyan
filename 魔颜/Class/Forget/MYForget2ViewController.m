//
//  MYForget2ViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/8.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYForget2ViewController.h"
#import "MYForget3ViewController.h"
#import "MYHeader.h"
#define deatiltextcolor  MYColor(109, 109, 109)

@interface MYForget2ViewController ()<UITextFieldDelegate>

@property(nonatomic,copy) NSString *phone;
@property (weak, nonatomic) UITextField *textField;
@property (nonatomic, assign) NSInteger number;

@property (weak, nonatomic) UIButton *timerBtn;
@property (copy, nonatomic) NSString *identifyCode;

@property(strong,nonatomic) NSString * superCode;

@end

@implementation MYForget2ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self step2];

}

-(void)setPhone:(NSString*)phone
{
    _phone = phone;

}

- (void)step2
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
    label.textColor = [UIColor grayColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"1输入账号>2验证身份>3设置新密码>4完成"];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0] range:NSMakeRange(6, 5)];
   	[str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,5)];
    label.attributedText = str;
    label.font = leftFont;
    [self.view addSubview:label];

    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(20, 110, self.view.width - 40, 35);
    label1.text = @"手机登录密码找回";
    label1.font = leftFont;
    label1.textColor = [UIColor grayColor];
    [self.view addSubview:label1];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(20, 150, self.view.width - 120, 35);
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:view];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(85, 0, view.width - 40, 30);
    textField.placeholder = @"请输入验证码";
    textField.font = leftFont;
    textField.secureTextEntry = YES;
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypePhonePad;
    self.textField = textField;
    [view addSubview:textField];
    
    
    UILabel *label0 = [[UILabel alloc] init];
    label0.text = @"短信验证码: ";
    label0.frame = CGRectMake(5, 0,75, textField.height);
    label0.textColor = [UIColor grayColor];
    label0.font = leftFont;
    [view addSubview:label0];

    UIButton *timerBtn = [[UIButton alloc] init];
    timerBtn.backgroundColor = subTitleColor;
    timerBtn.titleLabel.font = leftFont;
    [timerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [timerBtn addTarget:self action:@selector(getMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timerBtn];
    self.timerBtn = timerBtn;
    timerBtn.layer.cornerRadius = 5;
    timerBtn.layer.masksToBounds = YES;
    
    [timerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.equalTo(textField);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];

    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(20, 200, self.view.width - 40, 35);
    label2.text = [NSString stringWithFormat:@"您的手机号:%@",self.phone];
    label2.font = leftFont;
    label2.textColor = subTitleColor;
    [self.view addSubview:label2];

    
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

- (void)getMessage
{
    NSString* str = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"请确定您的手机号", nil),self.phone];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    
}

//发送验证码
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        //1.倒计时
        self.number = 60;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        [timer fire];
        
        //2.后台处理参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phone"] = self.phone;
        
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/user/getCode",kOuternet1] params:params success:^(id responseObject) {
            
            NSString *superCode = [responseObject objectForKey:@"musterCode"];//1420
            self.superCode = superCode;
            
            NSString *identifyCode = [responseObject objectForKey:@"code"];
            self.identifyCode = identifyCode;
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络错误"];
            
        }];
        
    }
}

//计算定时器时间
-(void)updateTime:(NSTimer *)Timer
{
    self.number--;
    
    self.timerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timerBtn.titleLabel.text = [NSString stringWithFormat:@"%lds",(long)self.number];
    self.timerBtn.userInteractionEnabled = NO;
    
    if (self.number == 0)
    {
        [Timer invalidate];
        
        self.timerBtn.titleLabel.text = @"重新发送";
        self.timerBtn.userInteractionEnabled = YES;
        
    }else{
        
    }
    
}

- (void)clickStepBtn
{
    [self.view endEditing:YES];

    
    if(self.textField.text.length != 4)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"通知"
            message:@"验证码格式错误"
            delegate:self  cancelButtonTitle:@"确定"
            otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
            if ([self.textField.text isEqualToString:self.identifyCode] || [self.textField.text isEqualToString:self.superCode]) {
                
                MYForget3ViewController *forget3VC = [[MYForget3ViewController alloc] init];
                forget3VC.phone = self.phone;
                [self.navigationController pushViewController:forget3VC animated:YES];
                
            }
            else
            {
                [MBProgressHUD showError:@"验证码错误"];
            }
    }



    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}



@end
