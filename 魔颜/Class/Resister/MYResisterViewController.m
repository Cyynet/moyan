//
//  MYResignViewController.m
//  魔颜
//
//  Created by Meiyue on 15/9/30.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYResisterViewController.h"
#import "MYStringFilterTool.h"
#import "MYMeTableViewController.h"
#import "MYHeader.h"

#define deatiltextcolor  MYColor(109, 109, 109)

@interface MYResisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) UITableView *registerTableView;
@property (weak, nonatomic) UITextField *phoneNumberField;
@property (weak, nonatomic) UITextField *secretField;
@property (weak, nonatomic) UITextField *setField;
@property (weak, nonatomic) UITextField *setField1;
@property (weak, nonatomic) UITextField *setField2;

@property (weak, nonatomic) UIButton *resisterBtn;

@property (weak, nonatomic) UIButton *timerBtn;

@property (nonatomic, assign) NSInteger number;

@property (strong, nonatomic) NSMutableArray *areaArray;
@property(nonatomic,copy) NSString *str;
@property(nonatomic,copy) NSString *timeNow;
@property (copy, nonatomic) NSString *identifyCode;
@property(copy,nonatomic) NSString * superCode;

@property(strong,nonatomic) NSString * devCode;

@end

@implementation MYResisterViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xeaeaea);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}

#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRegisterTableView];
    [self setupBtns];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addalerviewlable];
    self.title = @"手机注册";

}
-(void)addalerviewlable
{
    UILabel *alerlable = [[UILabel alloc]init];
    [self.view addSubview:alerlable];
    alerlable.numberOfLines=0;
    alerlable.frame = CGRectMake(MYMargin, 305, MYScreenW - MYMargin*2, 60);
    alerlable.text = @" *密码必须为6-20位字符 \n[优惠码] 输入好友的推荐码,您可在护肤品专区享受更低价格。或者输入魔颜官方优惠码:160159";
    alerlable.textColor = subTitleColor;
    alerlable.font = MianFont;
    
}
- (void)setupBtns
{
    //注册按钮
    UIButton *resisterBtn = [[UIButton alloc]init];
    resisterBtn.x = (self.view.width - 200) / 2;
    resisterBtn.frame = CGRectMake(resisterBtn.x, 285+35 + 50, 200, 35);
    [resisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resisterBtn.layer.cornerRadius = 4;
    resisterBtn.layer.masksToBounds = YES;
    resisterBtn.backgroundColor = deatiltextcolor;
    [resisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    resisterBtn.titleLabel.font = MianFont;
    [resisterBtn addTarget:self action:@selector(gotoResignStep) forControlEvents:UIControlEventTouchUpInside];
    self.resisterBtn = resisterBtn;
    [self.view addSubview:resisterBtn];
}

- (void)setupRegisterTableView
{
    UITableView *registerTableView = [[UITableView alloc] init];
    registerTableView.frame = CGRectMake(-20, 0, self.view.width + 20, 300);
    registerTableView.delegate = self;
    registerTableView.dataSource = self;
    registerTableView.scrollEnabled = NO;
    registerTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.registerTableView = registerTableView;
    
    
//    UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 100)];
//    footerview.backgroundColor = [UIColor redColor];
//    registerTableView.tableFooterView = footerview;
    
    
    [self.view addSubview:registerTableView];
}


#pragma mark UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str_Identifier = @"Cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str_Identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_Identifier];
    }
    //去掉点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        UILabel *accountLabel = [[UILabel alloc] init];
        accountLabel.frame = CGRectMake(35, 0, 100, 50);
        accountLabel.text = @"输入您的手机号";
        accountLabel.font = MianFont;
        accountLabel.textColor = titlecolor;
        [cell.contentView addSubview:accountLabel];
        
        UITextField *phoneNumberField = [[UITextField alloc] init];
        phoneNumberField.frame = CGRectMake(145, 0, self.view.width - 160, accountLabel.height);
        phoneNumberField.delegate = self;
        phoneNumberField.placeholder = @"请输入11位的手机号";
        phoneNumberField.font = MianFont;
        phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.contentView addSubview:phoneNumberField];
        self.phoneNumberField = phoneNumberField;
        [self.phoneNumberField becomeFirstResponder];
    }
    else if(indexPath.row == 1)
    {
        UILabel *secretLabel = [[UILabel alloc] init];
        secretLabel.frame = CGRectMake(50, 0, 100, 50);
        secretLabel.text = @"验证码";
        secretLabel.textColor = titlecolor;
        secretLabel.font = MianFont;
        [cell.contentView addSubview:secretLabel];
        
        UITextField *secretField = [[UITextField alloc] init];
        secretField.frame = CGRectMake(145, 0, self.view.width - 160, secretLabel.height);
        secretField.placeholder = @"请输入验证码";
        secretField.font = MianFont;
        secretField.delegate = self;
        self.secretField = secretField;
        secretField.keyboardType = UIKeyboardTypeNumberPad;
        
        [cell.contentView addSubview:secretField];
        
        UIButton *timerBtn = [[UIButton alloc] init];
        timerBtn.titleLabel.font = MianFont;
        timerBtn.backgroundColor = [UIColor lightGrayColor];
        timerBtn.layer.cornerRadius = 4;
        timerBtn.layer.masksToBounds = YES;
        [timerBtn setTitle:@"获取验证" forState:UIControlStateNormal];
        [cell.contentView addSubview:timerBtn];
        self.timerBtn = timerBtn;
        [timerBtn addTarget:self action:@selector(clickTimerBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [timerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        
    }
    else if (indexPath.row == 2){
        
        UILabel *accountLabel = [[UILabel alloc] init];
        accountLabel.frame = CGRectMake(45, 0, 100, 50);
        accountLabel.text = @"设置密码";
        accountLabel.font = MianFont;
        accountLabel.textColor = titlecolor;
        [cell.contentView addSubview:accountLabel];
        
        UITextField *setField = [[UITextField alloc] init];
        setField.frame = CGRectMake(145, 0, self.view.width - 160, accountLabel.height);
        setField.font = MianFont;
        setField.textColor = titlecolor;
        setField.delegate = self;
        setField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.setField = setField;
        setField.secureTextEntry = YES;
        setField.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:setField];
        
    }
    else if(indexPath.row == 3){
        
        UILabel *accountLabel = [[UILabel alloc] init];
        accountLabel.frame = CGRectMake(45, 0, 100, 50);
        accountLabel.text = @"确认密码";
        accountLabel.textColor = titlecolor;
        accountLabel.font = MianFont;
        [cell.contentView addSubview:accountLabel];
        
        UITextField *setField1 = [[UITextField alloc] init];
        setField1.frame = CGRectMake(145, 0, self.view.width - 160, accountLabel.height);
        setField1.font = MianFont;
        setField1.textColor = titlecolor;
        self.setField1 = setField1;
        setField1.secureTextEntry = YES;
        setField1.delegate = self;
        setField1.clearButtonMode = UITextFieldViewModeWhileEditing;
        setField1.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:setField1];
    }else if(indexPath.row == 4)
    {
        UILabel *accountLabel = [[UILabel alloc] init];
        accountLabel.frame = CGRectMake(45, 0, 100, 50);
        accountLabel.text = @"优惠码";
        accountLabel.textColor = titlecolor;
        accountLabel.font = MianFont;
        [cell.contentView addSubview:accountLabel];
        
        UITextField *setField2 = [[UITextField alloc] init];
        setField2.frame = CGRectMake(145, 0, self.view.width - 160, accountLabel.height);
        setField2.font = MianFont;
        setField2.textColor = titlecolor;
        self.setField2 = setField2;
        setField2.delegate = self;
        setField2.clearButtonMode = UITextFieldViewModeWhileEditing;
        setField2.keyboardType = UIKeyboardAppearanceDark;
        [cell.contentView addSubview:setField2];

        
    }else
    {
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

#pragma mark - 点击倒计时按钮方法
- (void)clickTimerBtn
{
    if ([self checkInput]){
        
        //获取验证码
        NSString* str = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"我们将会发送验证码到手机", nil),self.phoneNumberField.text];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        
    }
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
        
        //2.把数据传给后台
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phone"] = self.phoneNumberField.text;
        
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/user/getCode",kOuternet1] params:params success:^(id responseObject) {
            NSString *status = responseObject[@"status"];
            
            if ([status isEqualToString:@"error"]) {
                
                [MBProgressHUD showSuccess:@"服务器错误"];
            }
            
            NSString *superCode = responseObject[@"musterCode"];
            self.superCode = superCode;
            NSString *identifyCode = [responseObject objectForKey:@"code"];
            self.identifyCode = identifyCode;
            
        } failure:^(NSError *error) {

            [MBProgressHUD showError:@"验证码获取失败"];
            
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

/*
 @brief 注册账号
 */
- (void)gotoResignStep
{
    //1.手机
    if ([self checkInput]) {
        
        if(self.secretField.text.length == 0){
            [MBProgressHUD showError:@"验证码不能为空"];
        }else if (self.secretField.text.length != 4){
            [MBProgressHUD showError:@"验证码格式有误"];
        }else if([self.secretField.text isEqualToString:self.identifyCode] || [self.secretField.text isEqualToString:self.superCode])
        {
            [self makeSurePassWord];
        }else{
            
            [MBProgressHUD showError:@"验证码验证失败"];
        }
    }
}
/*
 @brief 注册加密MD5
 */
- (void)makeSurePassWord
{
    //2.验证密码
    if ([self checkInput1]) {
        
        // 进行MD5加密 // 每次都是一样的！例如：黑客拦截了路由器中的数据
        // 就能够获得到加密后的密码！

//        先预注册 －完成后 －注册
        AFHTTPRequestOperationManager *maager = [[AFHTTPRequestOperationManager alloc]init];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"devCode"] = [MYStringFilterTool getUDID];
        param[@"devType"] = [MYStringFilterTool getDeviceType];
        param[@"channel"] = @"0";
    
        [maager GET:[NSString stringWithFormat:@"%@/kefu/preUser",kOuternet1] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

            
            self.devCode = responseObject[@"devCode"];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"code"] = self.phoneNumberField.text;
            params[@"password"] = [MYStringFilterTool getmd5WithString:self.setField.text];
            params[@"deviceCode"] = self.devCode;
            params[@"inviteCode"] = self.setField2.text;      //邀请码
            
            MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在注册"];
            
            [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@user/addUser",kOuternet1]  params:params success:^(id responseObject) {
                
                NSString *status = [responseObject objectForKey:@"status"];
                
                if ([status isEqualToString:@"-203"]) {
                    [hud hide:YES];
                    [MBProgressHUD showError:@"该用户名已存在"];
                }else if([status isEqualToString:@"-99"])
                {
                    [hud hide:YES];
                    [MBProgressHUD showError:@"该优惠码不存在"];
                }else if([status isEqualToString:@"success"]) {
                    [hud hide:YES];
                    [MBProgressHUD showSuccess:@"注册成功"];
                    
                    if (self.loginBLock) {
                        self.loginBLock(self.phoneNumberField.text);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else if([status isEqualToString:@"-107"])
                {
                    [hud hide:YES];
                    [MBProgressHUD showSuccess:@"错误码：-107"];
                }
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD showError:@"注册失败"];
            }];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               [MBProgressHUD showError:@"预注册失败"];
        }];
        
    
        
    }
}


- (BOOL)checkInput
{
    BOOL accountNumGood = [MYStringFilterTool filterByPhoneNumber:self.phoneNumberField.text];
    
    if (!accountNumGood) {
        
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)checkInput1
{
    BOOL passWordNumGood = [MYStringFilterTool filterByLoginPassWord:self.setField.text];
    BOOL repassWordNumGood = [MYStringFilterTool filterByLoginPassWord:self.setField1.text];
    
    if (!passWordNumGood) {
        [MBProgressHUD showError:@"密码格式有误,请重新输入"];
        return NO;
    }else if (passWordNumGood &&  self.setField1.text.length == 0) {
        [MBProgressHUD showError:@"请输入确认密码"];
        return NO;
    }else if (passWordNumGood && !repassWordNumGood) {
        [MBProgressHUD showError:@"确认密码有误,请重新输入"];
        return NO;
    }else if (passWordNumGood && repassWordNumGood) {
        
        if ([self.setField.text isEqualToString:self.setField1.text] ) {
            return YES;
        }else{
            [MBProgressHUD showError:@"确认密码有误,请重新输入"];
            return NO;
        }
    }
    
    return NO;
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [_phoneNumberField resignFirstResponder];
//    [_secretField resignFirstResponder];
//    [_setField  resignFirstResponder];
//    [_setField1  resignFirstResponder];
//    
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        [_secretField resignFirstResponder];
        [_setField  resignFirstResponder];
        [_setField1  resignFirstResponder];
        [_setField2  resignFirstResponder];
        self.view.y = 0;

    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (MYScreenW==320) {
        
    if (textField == self.setField2) {
        
        self.view.y = -50;
    }else if (textField==self.setField1)
    {
        self.view.y = -30;

    }
    }
    return YES;
}

@end
