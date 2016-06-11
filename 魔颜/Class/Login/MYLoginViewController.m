//
//  MYRegisterViewController.m
//  魔颜
//
//  Created by Meiyue on 15/9/30.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYLoginViewController.h"
#import "MYResisterViewController.h"
#import "MYForgerViewController.h"
#import "MYMeTableViewController.h"
#import "MYStringFilterTool.h"

#import "MYMeTableViewController.h"
#import "UMSocial.h"

#import "MYUserModel.h"
#import "MYModel.h"
#import "MYLoginUser.h"
#import "MYUserInfoTool.h"
#import "MYHeader.h"

#define margin 60
#define deatiltextcolor  MYColor(109, 109, 109)

@interface MYLoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) UITableView *loginTableView;
@property (weak, nonatomic) UITextField *accountField;
@property (weak, nonatomic) UITextField *secretField;

@property (weak, nonatomic) UIButton *otherBtn;

@end

@implementation MYLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLoginTableView];
    [self setupBtns];
//    [self setupThirdLogin];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)setupLoginTableView
{
    UITableView *loginTableView = [[UITableView alloc] init];
    loginTableView.frame = CGRectMake(0, -10, self.view.width, 200);
    loginTableView.delegate = self;
    loginTableView.dataSource = self;
    loginTableView.scrollEnabled = NO;
    loginTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.loginTableView = loginTableView;
    [self.view addSubview:loginTableView];
}

//添加供能按钮
- (void)setupBtns
{
    UIButton *rememberBtn = [[UIButton alloc]init];
    rememberBtn.frame = CGRectMake(MYMargin, CGRectGetMaxY(self.loginTableView.frame) + kMargin, 13, 13);
    [rememberBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [rememberBtn setBackgroundImage:[UIImage imageNamed:@"checkx"] forState:UIControlStateSelected];
    [rememberBtn addTarget:self action:@selector(clickRemember:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberBtn];

    
//    [MYUserInfoTool saveLoginStatus:@"记住密码"];
    [MYUserDefaults setBool:YES forKey:@"loginStatus"];
    [MYUserDefaults synchronize];

    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.frame = CGRectMake(CGRectGetMaxX(rememberBtn.frame) + 5, rememberBtn.y, 150, 15);
    desLabel.textColor = titlecolor;
    desLabel.font = MianFont;
    desLabel.text = @"记住密码";
    [self.view addSubview:desLabel];
    
    
    //登陆按钮
    UIButton *loginBtn = [[UIButton alloc]init];
    loginBtn.x = (self.view.width - 230) / 2;
    loginBtn.frame = CGRectMake(loginBtn.x, CGRectGetMaxY(self.loginTableView.frame) + 2 * MYMargin, 230, 40);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = MianFont;
    loginBtn.layer.cornerRadius = 3;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = deatiltextcolor;
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //快速注册
    UIButton *resignBtn = [[UIButton alloc]init];
    resignBtn.frame = CGRectMake(20, CGRectGetMaxY(loginBtn.frame) + 15, 100, 30);
    resignBtn.titleLabel.font = MianFont;
    [resignBtn setTitleColor:titlecolor forState:UIControlStateNormal];
    [resignBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [resignBtn addTarget:self action:@selector(clickResignBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignBtn];
    
    //忘记密码
    UIButton *forgerBtn = [[UIButton alloc]init];
    //    forgerBtn.frame = CGRectMake(270, 280, 100, 30);
    forgerBtn.titleLabel.font = MianFont;
    [forgerBtn setTitleColor:titlecolor forState:UIControlStateNormal];
    [forgerBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgerBtn addTarget:self action:@selector(clickForgetBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgerBtn];
    
    [forgerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.equalTo(loginBtn.mas_bottom).with.offset(15);;
        make.width.mas_equalTo(resignBtn.width);
        make.height.mas_equalTo(resignBtn.height);
        
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 300, self.view.width, 0.8);
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.4;
//    [self.view addSubview:lineView];
    
    //其它账号登陆
    UIButton *otherBtn = [[UIButton alloc]init];
    otherBtn.enabled = NO;
    otherBtn.frame = CGRectMake((self.view.width - 100)/ 2, 285, 100, 30);
    otherBtn.titleLabel.font = MianFont;
    [otherBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [otherBtn setTitle:@"其他账号登录" forState:UIControlStateNormal];
    [otherBtn setBackgroundImage:[UIImage imageNamed:@"login1"] forState:UIControlStateNormal];
    self.otherBtn = otherBtn;
//    [self.view addSubview:otherBtn];
    
}

/*
 @brief 记住用户密码
 */
- (void)clickRemember:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [MYUserDefaults setBool:NO forKey:@"loginStatus"];
        [MYUserDefaults synchronize];
    }else{
        [MYUserDefaults setBool:YES forKey:@"loginStatus"];
        [MYUserDefaults synchronize];
    }
 }

//键盘退出
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}

/*
 @brief 登陆
 */
- (void)clickLoginBtn
{
    if ([self checkInput]) {
        
        NSString *pwd = [MYStringFilterTool getmd5WithString:self.secretField.text];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"code"] = self.accountField.text;
        params[@"password"] = pwd;
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在登陆"];
        
        [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/user/loadUser",kOuternet1] params:params success:^(id responseObject) {
            
            MYModel *model = [MYModel objectWithKeyValues:responseObject];
            
            if (model.status == -205) {
                
                [hud hide:YES];
                [MBProgressHUD showError:@"用户名不存在,请重新输入"];
                
            }else if (model.status == -204){
                
                [hud hide:YES];
                [MBProgressHUD showError:@"登陆密码错误,请重新输入"];
              }
            else{
                
                NSString *str = [NSString stringWithFormat:@"%@%@",kOuternet1,[responseObject[@"user"] objectForKey:@"pic"]];
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
                
                /**
                             *   *    *   *    *   *   *   *
                                        *   *
                                           *
                 */
                       [MYUserDefaults setBool:YES forKey:@"hasLogin"];//已经登陆
                /**
                                           *
                                    *   *    *   *
                            *   *    *   *   *   *    *   *
    

                 */
                //保存默认用户
                [MYUserDefaults setObject:model.user.sex forKey:@"sex"];
                [MYUserDefaults setObject:model.user.pic forKey:@"userPic"];
                [MYUserDefaults setObject:model.user.region forKey:@"region"];
                [MYUserDefaults setObject:self.accountField.text forKey:@"code"];
                [MYUserDefaults setObject:model.user.ID forKey:@"id"];
                [MYUserDefaults setObject:model.user.password forKey:@"password"];
                [MYUserDefaults setObject:model.user.name forKey:@"name"];
                [MYUserDefaults setObject:model.user.token forKey:@"token"];
                [MYUserDefaults setObject:data forKey:@"data"];
                [MYUserDefaults synchronize];
                
                [hud hide:YES];
                [self.view endEditing:YES];
                [MBProgressHUD showSuccess:@"登陆成功"];
                MYAppDelegate.isLogin = YES;
                [self.navigationController popViewControllerAnimated: YES];
            }
            
        } failure:^(NSError *error) {
            [hud hide:YES];
            [MBProgressHUD showError:@"网络错误"];
            
        }];
    }
}

//快速注册
- (void)clickResignBtn
{
    MYResisterViewController *resisterVC = [[MYResisterViewController alloc] init];
    resisterVC.loginBLock = ^(NSString *codeNum){
        self.accountField.text = codeNum;
    };
    [self.navigationController pushViewController:resisterVC animated:YES];
}

//忘记密码
- (void)clickForgetBtn
{
    MYForgerViewController *forgetVC = [[MYForgerViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
    
}

//组数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str_Identifier = @"Cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str_Identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_Identifier];   
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//去掉点击效果
    
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        
        //添加返回按钮
        UIImageView *imageView = [UIImageView addImaViewWithFrame:CGRectMake(15, 40, 10, 15) imageName:@"back-1"];
        [self.view addSubview:imageView];
        
        UIButton *backBtn = [[UIButton alloc]init];
        backBtn.frame = CGRectMake(kMargin, MYMargin, 40, 40);
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
    
        
        UILabel *loginLable = [[UILabel alloc] init];
        loginLable.frame = CGRectMake(0, 10, self.view.width, margin);
        loginLable.text = @"账号登陆";
        loginLable.font = MYFont(15);
        loginLable.textColor = titlecolor;
        loginLable.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:loginLable];
    }
    else if(indexPath.row == 1) {
        
        UILabel *accountLabel = [[UILabel alloc] init];
        accountLabel.frame = CGRectMake(30, 0, 80, margin);
        accountLabel.text = @"账户";
        accountLabel.font = MianFont;
        accountLabel.textColor = titlecolor;
        [cell.contentView addSubview:accountLabel];
        
        UITextField *accountField = [[UITextField alloc] init];
        accountField.frame = CGRectMake(100, 0, self.view.width - 120, margin);
        accountField.delegate = self;
        self.accountField = accountField;
        accountField.font = MianFont;
        accountLabel.textColor = titlecolor;
        accountField.keyboardType = UIKeyboardTypePhonePad;
        accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        accountField.placeholder = @"手机/会员名";
        accountField.adjustsFontSizeToFitWidth = YES;
        accountField.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:accountField];
        
    }
    else
    {
        UILabel *secretLabel = [[UILabel alloc] init];
        secretLabel.frame = CGRectMake(30, 0, 100, margin);
        secretLabel.text = @"密码";
        secretLabel.font = MianFont;
        secretLabel.textColor = titlecolor;
        [cell.contentView addSubview:secretLabel];
        
        UITextField *secretField = [[UITextField alloc] init];
        secretField.frame = CGRectMake(100, 0, self.view.width - 120, margin);
        secretField.placeholder = @"请输入密码";
        secretField.delegate = self;
        secretField.font = MianFont;
        secretLabel.textColor = titlecolor;
        secretField.secureTextEntry = YES;
        secretField.clearButtonMode = UITextFieldViewModeWhileEditing;
        secretField.returnKeyType = UIReturnKeyDone;
        secretField.adjustsFontSizeToFitWidth = YES;
        self.secretField = secretField;
        [cell.contentView addSubview:secretField];
        
    }
    return cell;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }else {
        return margin;
    }
}

- (BOOL)checkInput
{
    BOOL accountNumGood =[MYStringFilterTool filterByPhoneNumber:self.accountField.text];
    BOOL passWordNumGood = [MYStringFilterTool filterByLoginPassWord:self.secretField.text];
    
    if (!accountNumGood) {
        
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return NO;
    }
    else if (accountNumGood && !passWordNumGood) {
        [MBProgressHUD showError:@"密码错误,请重新输入"];
        return NO;
    }
    else if (!accountNumGood && !passWordNumGood) {
        [MBProgressHUD showError:@"手机号和密码格式输入有误"];
        return NO;
    }
    return YES;
}

#pragma mark /*************第三方登陆 ***************/

/*
 @brief 第三方登陆按钮
 */
- (void)setupThirdLogin
{
    UIButton *qqBtn = [[UIButton alloc] init];
    [qqBtn setImage:[UIImage imageNamed:@"share_logo_qq"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(clickQQBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqBtn];
    
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.equalTo(self.otherBtn.mas_bottom).with.offset(12);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    
    UIButton *weiXinBtn = [[UIButton alloc] init];
    [weiXinBtn setImage:[UIImage imageNamed:@"share_logo_weixin"] forState:UIControlStateNormal];
    [weiXinBtn addTarget:self action:@selector(clickWeiXinBtn)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiXinBtn];
    
    [weiXinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherBtn.mas_bottom).with.offset(12);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(48);
        make.left.mas_equalTo(MYScreenW /2 - 27);
        
    }];
    
    UIButton *weiBoBtn = [[UIButton alloc] init];
    weiBoBtn.frame = CGRectMake(270, 370, 60, 60);
    [weiBoBtn setImage:[UIImage imageNamed:@"share_logo_weibo"] forState:UIControlStateNormal];
    [weiBoBtn addTarget:self action:@selector(clickWeiboBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiBoBtn];
    
    [weiBoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-35);
        make.top.equalTo(self.otherBtn.mas_bottom).with.offset(12);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(48);
    }];
    
}

/**
 *  QQ登陆
 */
- (void)clickQQBtn
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@\n, uid is %@\n, token is %@\n url is %@\n",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [MBProgressHUD showSuccess:@"登陆成功"];
        }});
    
    //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        
        NSLog(@"SnsInformation is %@",response.data);
    }];
    
}

/**
 *  微信登陆
 */
- (void)clickWeiXinBtn
{
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [MBProgressHUD showSuccess:@"登陆成功"];
            
        }
        
    });
    
    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        
        NSLog(@"SnsInformation is %@",response.data);
        
        
    }];
}

/**
 *  微博登陆
 */
- (void)clickWeiboBtn
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [MBProgressHUD showSuccess:@"登陆成功"];
            
        }});
    
    //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_accountField resignFirstResponder];
    [_secretField resignFirstResponder];
}
/*
 @brief 分割线左对齐
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //按照作者最后的意思还要加上下面这一段
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
@end
