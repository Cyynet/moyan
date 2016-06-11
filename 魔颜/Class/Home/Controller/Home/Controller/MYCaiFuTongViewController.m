//
//  MYCaiFuTongViewController.m
//  魔颜
//
//  Created by abc on 16/3/16.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYCaiFuTongViewController.h"
#import "MYAliPayViewController.h"
#import "MYWeiXinZhiFuController.h"
#define RowHeight 35
#import "WXApi.h"
#import "WXApiObject.h"
@interface MYCaiFuTongViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextFieldDelegate>
@property(strong,nonatomic) UITableView * tableView;
@property(strong,nonatomic) UIView * tableviewHeader;
@property(strong,nonatomic) UIView * tableviewFooter;

@property(strong,nonatomic) UIView * footrview;

@property(strong,nonatomic) NSArray * titlearr;

@property(strong,nonatomic) UITextField * namefield;
@property(strong,nonatomic) UITextField * phonefield;
@property(strong,nonatomic) UITextField * storenamefield;
@property(strong,nonatomic) UITextField * storeadressfield;
@property(strong,nonatomic) UITextField * beizhufield;


@property(strong,nonatomic) UIButton * btn;
@property(strong,nonatomic) UIButton * lastBtn;
@property(strong,nonatomic) NSString * paystyletag;



@end

@implementation MYCaiFuTongViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor =  [UIColor whiteColor];
    self.title = @"确认订单";
    [self setupTableView];

//    [self addtopbar];
    
    [self addBoomView];
    
    
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, MYScreenH-40)];
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView = tableView;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    

       [self addheaderview];
        [self addfootview];


    
}
-(void)addheaderview
{
    
    UIView *tableviewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 60)];
    self.tableviewHeader = tableviewHeader;
    self.tableView.tableHeaderView = tableviewHeader;


    UIImageView *iconimage = [[UIImageView alloc]init];
    [iconimage setImage:[UIImage imageNamed:@"icon1"]];
    iconimage.frame = CGRectMake(10, 10, 44, 40);
    [self.tableviewHeader addSubview:iconimage];

    
    UILabel *headertitle = [[UILabel alloc]init];
    headertitle.text = @"魔颜通会员费";
    headertitle.frame = CGRectMake(70, 10, 120, 20);
    [self.tableviewHeader addSubview:headertitle];
    headertitle.font = [UIFont systemFontOfSize:13];
    
    
    UILabel *headerSubtitle = [[UILabel alloc]init];
    headerSubtitle.frame = CGRectMake(70, 32, 120, 20);
    
    [self.tableviewHeader addSubview:headerSubtitle];
    headerSubtitle.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0];
   
    NSString * str = [NSString stringWithFormat:@"¥%@/年",self.price];
    NSMutableAttributedString *strpri = [[NSMutableAttributedString alloc]initWithString:str];
    [strpri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0] range:NSMakeRange(0, 1)];
   	[strpri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    headerSubtitle.textColor = [UIColor redColor];
    headerSubtitle.attributedText = strpri;
}


//支付方式的view
-(void)addfootview
{
    UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 220)];
    self.tableView.tableFooterView = footerview;
    self.footrview = footerview;
    
    UILabel *paystyle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, MYScreenW, 10)];
    paystyle.text = @"选择支付方式";
    paystyle.font = [UIFont systemFontOfSize:12];
    [footerview addSubview:paystyle];
    paystyle.textColor = titlecolor;
    
        UIImageView *weixinimageview = [[UIImageView alloc]init];
        [footerview addSubview:weixinimageview];
        [weixinimageview setImage:[UIImage imageNamed:@"icon2"]];
        weixinimageview.frame = CGRectMake(10, CGRectGetMaxY(paystyle.frame)+10, 40, 40);
    
    
        UILabel *titlepay = [[UILabel alloc]initWithFrame:CGRectMake(55, weixinimageview.y , 100, 20)];
        [footerview addSubview:titlepay];
        titlepay.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
        titlepay.textColor = titlecolor;
        titlepay.text =@"支付宝支付";
        titlepay.textAlignment = NSTextAlignmentLeft;
    
        UILabel *subtitlepay = [[UILabel alloc]initWithFrame:CGRectMake(55, CGRectGetMaxY(titlepay.frame) , 180, 20)];
        [footerview addSubview:subtitlepay];
        subtitlepay.font = DeatilContentFont;
        subtitlepay.textColor = titlecolor;
        subtitlepay.text =@"推荐开通支付宝支付的用户使用";
        subtitlepay.textAlignment = NSTextAlignmentLeft;

    UIImageView *alipayimageview = [[UIImageView alloc]init];
    [alipayimageview setImage:[UIImage imageNamed:@"icon3"]];
    alipayimageview.frame = CGRectMake(10, CGRectGetMaxY(weixinimageview.frame)+10, 40, 40);

    UILabel *titlepay1 = [[UILabel alloc]initWithFrame:CGRectMake(55,  alipayimageview.y, 100, 20)];
    titlepay1.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
    titlepay1.textColor = titlecolor;
    titlepay1.text =@"微信支付";
    titlepay1.textAlignment = NSTextAlignmentLeft;
    
    UILabel *subtitlepay1 = [[UILabel alloc]initWithFrame:CGRectMake(55, CGRectGetMaxY(titlepay1.frame) , 180, 20)];
    subtitlepay1.font = DeatilContentFont;
    subtitlepay1.textColor = titlecolor;
    subtitlepay1.text =@"推荐开通微信支付的用户使用";
    subtitlepay1.textAlignment = NSTextAlignmentLeft;

    if([WXApi isWXAppInstalled])
    {
        [footerview addSubview:alipayimageview];
        [footerview addSubview:titlepay1];
        [footerview addSubview:subtitlepay1];
        
     self.titlearr = @[@"",@""];
    }else
    {
     self.titlearr = @[@""];
    }
    
    
    
    for (int i = 1; i <= self.titlearr.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        
        btn.frame = CGRectMake( MYScreenW - 40, (i - 1) * 50+40, 15, 15);

        [btn setTitle:[self.titlearr objectAtIndex:i-1] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon5"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon6"] forState:UIControlStateSelected];
        btn.tag = i;
        self.btn = btn;
        [btn addTarget:self action:@selector(caifutongselectse:) forControlEvents:UIControlEventTouchUpInside];
        [self.footrview addSubview:btn];
    }
    
}

//组数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
    
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str_Identifier = [NSString stringWithFormat:@"Tiezi%ld",(long)[indexPath row]];
    
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str_Identifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_Identifier];
    }else
    {
        for (UIView *subview in cell.contentView.subviews)
        {
            [subview removeFromSuperview];
        }
    }
    
    //去掉点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, 50, RowHeight) text:@"姓名"];
        [cell.contentView addSubview:titleLabel];
        
        UITextField *textField = [self addFieldWithFrame:CGRectMake(MYScreenW-105, 0, 100, RowHeight) text:self.namefield.text];
        self.namefield = textField;
        self.namefield.textAlignment = NSTextAlignmentRight;
        self.namefield.placeholder = @"(请填写真实姓名)";
        [cell.contentView addSubview:textField];
        
        
    }else if(indexPath.row == 1)
    {
        UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, 50, RowHeight) text:@"联系电话"];
        [cell.contentView addSubview:titleLabel];
        
        
        UITextField *textField = [self addFieldWithFrame:CGRectMake(MYScreenW-125, 0, 120, RowHeight) text:self.phonefield.text];
        self.phonefield = textField;
        self.phonefield.text = [MYUserDefaults objectForKey:@"code"];
        self.phonefield.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:textField];
    }else if(indexPath.row == 2)
    {
        UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, 50, RowHeight) text:@"店铺名称"];
        [cell.contentView addSubview:titleLabel];
        
        
        UITextField *textField = [self addFieldWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 0, MYScreenW-titleLabel.width-25, RowHeight) text:self.storenamefield.text];
        self.storenamefield = textField;
//        self.storenamefield.text = @"上好佳美容院";
        self.storenamefield.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:textField];
    }else if(indexPath.row == 3)
    {
        UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, 50, RowHeight) text:@"店铺地址"];
        [cell.contentView addSubview:titleLabel];
        
        
        UITextField *textField = [self addFieldWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 0, MYScreenW-titleLabel.width-25, RowHeight) text:self.storeadressfield.text];
        self.storeadressfield = textField;
//        self.storeadressfield.text = @"朝阳区建外soho 7号楼1003";
        self.storeadressfield.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:textField];
    }else if(indexPath.row == 4)
    {
        UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, 50, RowHeight) text:@"备注"];
        [cell.contentView addSubview:titleLabel];
        
        UITextField *textField = [self addFieldWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 0, MYScreenW-titleLabel.width-25, RowHeight) text:self.beizhufield.text];
        self.beizhufield = textField;
        textField.delegate = self;
        textField.tag = 6;
        self.beizhufield.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:textField];
    }else
    {
        cell.backgroundColor  =  MYColor(230, 230, 230);
        cell.alpha = 0.5;
    }
    
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==5) {
        return 7;
    }else{
    return 35;
    }
}


//底部视图
-(void)addBoomView
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, MYScreenH-39, MYScreenW, 0.5)];
    [self.view addSubview:line];
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.5;
    
    UIButton *paybtn  = [[UIButton alloc]initWithFrame:CGRectMake(MYScreenW*7/10, MYScreenH-40, MYScreenW*3/10, 40)];
    [self.view addSubview:paybtn];
    paybtn.backgroundColor  = MYColor(177, 158, 90);
    [paybtn setTitle:@"确认" forState:UIControlStateNormal];
    [paybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    paybtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [paybtn addTarget:self action:@selector(submitfrom) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(paybtn.x-110-5,MYScreenH-40, 70+40, 40)];
    price.textColor = [UIColor redColor];
    [self.view addSubview:price];
    price.font  = [UIFont systemFontOfSize:14];
    NSString *pricestr = [NSString stringWithFormat:@"价格： ¥%@",self.price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:pricestr];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0] range:NSMakeRange(0, 3)];
   	[str addAttribute:NSForegroundColorAttributeName value:titlecolor range:NSMakeRange(0,3)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0] range:NSMakeRange(4, 1)];
   	[str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,1)];
    price.attributedText = str;
    price.textAlignment  = NSTextAlignmentRight;
    
    
}


// 选择支付方式
-(void)caifutongselectse:(UIButton *)btn
{
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    self.paystyletag = [NSString stringWithFormat:@"%ld",(long)btn.tag-1];
    
}

-(void)addtopbar
{
    UIButton *rightBtn  = [[UIButton alloc]init];
    [rightBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    rightBtn.size = CGSizeMake(15, 15);
    rightBtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
    [rightBtn setTitleColor:titlecolor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickrightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

//  分享
-(void)clickrightBtn
{
    
    
}

// 将要拖拽的时候调一次
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


//确定
-(void)submitfrom
{
    if ([self.namefield.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入姓名"];
    }else{
        if ([self.phonefield.text isEqualToString:@""]) {
             [MBProgressHUD showError:@"请输入联系电话"];
        }else
        {
            if ([self.storenamefield.text isEqualToString:@""]) {
                      [MBProgressHUD showError:@"请输入店铺名称"];
            }else
            {
                if ([self.storeadressfield.text isEqualToString:@""]) {
                      [MBProgressHUD showError:@"请输入店铺地址"];
                }else
                {
                
                    AFHTTPRequestOperationManager *marager = [[AFHTTPRequestOperationManager alloc]init];
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    
                    params[@"payBy"] = self.paystyletag;
                    params[@"actualPayment"] =  self.price;                 //实际付款
                    params[@"specialdealsId"] = @"0";                                //特惠ID
                    params[@"signature"] = [MYStringFilterTool getSignature];       //签名
                    params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];       //毫秒值
                    params[@"name"] = self.namefield.text;        //姓名
                    params[@"phone"] = self.phonefield.text;      //电话
                    params[@"sysType"] = @"2";                      //iOS标示
                    params[@"evaluate"] = self.beizhufield.text; //买家留言
                    params[@"serviceAgency"] = self.storenamefield.text;       //机构名称
                    params[@"lable"] = @"1";                        //美容院标示
                    params[@"hospitalId"] = self.solanID;           //美容院id H5传回来
                    params[@"price"] = self.price;                  //输入的金额 H5传回来
                    params[@"title"] = self.titlestr;               // H5传回来
                    params[@"number"] = @"1";
                    params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
                    params[@"approver"] = self.storeadressfield.text;
                    
                    [marager POST:[NSString stringWithFormat:@"%@/order/addOrder",kOuternet1] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

                        if ([responseObject[@"status"] isEqualToString:@"success"]) {
                            
                            //        支付宝
                            if ([self.paystyletag isEqualToString:@"0"]) {
                                
                                MYAliPayViewController *alipayVC = [[MYAliPayViewController alloc]init];
                                [self.navigationController pushViewController:alipayVC animated:YES];
                                
                                alipayVC.partner = responseObject[@"PARTNER"];
                                alipayVC.seller = responseObject[@"SELLER"];
                                alipayVC.privateKey = responseObject[@"privateKey"];
                                alipayVC.tradeNO = responseObject[@"out_trade_no"];
                                alipayVC.serviece = responseObject[@"serviceALI"];//
                                alipayVC.inputCharset = responseObject[@"inputCharset"];
                                alipayVC.notifyURL = responseObject[@"notifyURL"];
                                alipayVC.productName = responseObject[@"pay_title"];
                                alipayVC.paymentType = responseObject[@"paymentType"];
                                alipayVC.amount = self.price;
                                alipayVC.productDescription = responseObject[@"pay_body"];
                                alipayVC.itBPay = responseObject[@"30m"];
                                alipayVC.sign_type = responseObject[@"sign_type"];
                                
                            }
                            
                            //        微信支付
                            else if ([self.paystyletag isEqualToString:@"1"])
                            {
                                
                                MYWeiXinZhiFuController *weixinVC = [[MYWeiXinZhiFuController alloc]init];
                                [self.navigationController pushViewController:weixinVC animated:YES];
                                
                                weixinVC.shangpingname =  responseObject[@"pay_body"];
                                weixinVC.shangpindeatil =  responseObject[@"pay_detail"];
                                weixinVC.preice =  self.price;
                                
                                weixinVC.oderid = responseObject[@"out_trade_no"];

                            }else
                            {
                                return ;
                            }
                            
                        }
                        else
                        {
                            //   [MBProgressHUD showError:@"亲，提交失败"];
                            
                        }
                        
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        
                        //    [MBProgressHUD showError:@"亲，提交失败"];
                    }];
                    
                    
                }
            }
            
        }
    }
    
    
    
}

/*
 @brief textField
 */
- (UITextField *)addFieldWithFrame:(CGRect)frame text:(NSString *)text
{
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = frame;
    textField.delegate = self;
    textField.placeholder = @"点击可编辑";
    textField.font = leftFont;
    textField.text = text;
    textField.textColor = subTitleColor;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return textField;
}

/*
 @brief 左边Label
 */
- (UILabel *)addLabelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = frame;
    leftLabel.text = text;
    leftLabel.textColor = titlecolor;
    leftLabel.font = leftFont;
    
    return leftLabel;
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 6) {

        [self.tableView setContentOffset:CGPointMake(0, 5) animated:YES];
    }else{
        
//        NSLog(@"---------");

    }
    
}

@end
