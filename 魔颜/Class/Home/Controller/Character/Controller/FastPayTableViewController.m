//
//  FastPayTableViewController.m
//  魔颜
//
//  Created by abc on 16/1/28.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "FastPayTableViewController.h"
//#define RowHeight 33
#define textMargin 50
#import "MYTextView.h"
#import "WXApi.h"

#import "MYAliPayViewController.h"
#import "MYWeiXinZhiFuController.h"
#import "MYHeader.h"

@interface FastPayTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(strong,nonatomic) UITableView * tableview;
// 支付上的分割线
@property(strong,nonatomic)UIView *zhifudiviview1;
@property(strong,nonatomic)UIView *zhifudiviview2;
@property(strong,nonatomic) NSArray * titlearr;

@property (strong, nonatomic) UIImageView *alipyimageview;
@property (strong, nonatomic) UIImageView *weixinimageview;
@property (strong, nonatomic) UIImageView *yinlianimageview;

@property(strong,nonatomic) UIView * tablefooterview;
@property(strong,nonatomic) UIButton * btn;
@property(strong,nonatomic) UIButton * lastBtn;

@property(strong,nonatomic) NSString * payType;


@property(strong,nonatomic) UITextField * pricecontent;
@property(strong,nonatomic) UITextField * phonecontent;
@property(strong,nonatomic) UITextField * namecontent;

@property(strong,nonatomic) NSString * zongjiastr;
@property(strong,nonatomic) NSString * jianmianstr;
@property(strong,nonatomic) NSString * shifujia;
@property(strong,nonatomic) UILabel * realitycontent;
@property(strong,nonatomic) MYTextView * messagecontent;

@property(strong,nonatomic) NSString * str;

@end

@implementation FastPayTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快捷支付";
    [self addtableview];
    [self addpayWay];
}

//添加支付按钮
-(void)addpayWay
{
    UIButton *payway = [[UIButton alloc]initWithFrame:CGRectMake(0, MYScreenH-50, MYScreenW, 50)];
    [payway setTitle:@"去付款" forState:UIControlStateNormal];
    [payway setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payway.backgroundColor = MYColor(193, 177, 122);
    [payway addTarget:self action:@selector(fuzhifuBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payway];
}

//添加tableview
-(void)addtableview
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenH-50)];
    self.tableview = tableview;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    
    UIView *tablefooterview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 160)];
    self.tablefooterview = tablefooterview;
    self.tableview.tableFooterView = tablefooterview;
    [self addFotterView];

    
}

//添加支付方式
-(void)addFotterView
{
    CGFloat imageheight = 20;
    CGFloat imagewith = 56;
    
    UIImageView *alipyimageview = [[UIImageView alloc]init];
    self.alipyimageview = alipyimageview;
    [self.tablefooterview addSubview:alipyimageview];
    [alipyimageview setImage:[UIImage imageNamed:@"alipay"]];
    alipyimageview.frame = CGRectMake(10, 15, imagewith, imageheight);
    
    
    if ([WXApi isWXAppInstalled]) {
        UIImageView *weixinimageview = [[UIImageView alloc]init];
        self.weixinimageview = weixinimageview;
        [self.tablefooterview addSubview:weixinimageview];
        [weixinimageview setImage:[UIImage imageNamed:@"weixin"]];
        weixinimageview.frame = CGRectMake(10, CGRectGetMaxY(alipyimageview.frame) +25, imagewith, imageheight);
        
        UIView *zhifudiviview2 = [[UIView alloc]init];
        self.zhifudiviview2 = zhifudiviview2;
        [self.tablefooterview addSubview:zhifudiviview2];
        zhifudiviview2.backgroundColor = [UIColor blackColor];
        zhifudiviview2.alpha = 0.2;
        zhifudiviview2.frame  = CGRectMake(0, CGRectGetMaxY(weixinimageview.frame) +10, MYScreenW, 1);
    }
    
    //    UIImageView *yinlianimageview = [[UIImageView alloc]init];
    //    self.yinlianimageview = yinlianimageview;
    //    [paycontent addSubview:yinlianimageview];
    //    [yinlianimageview setImage:[UIImage imageNamed:@"unionpay"]];
    //    yinlianimageview.frame = CGRectMake(leftjianju, CGRectGetMaxY(weixinimageview.frame) +25, imagewith, imageheight);
    
    
    //        分割线
    UIView *zhifudiviview1 = [[UIView alloc]init];
    self.zhifudiviview1 = zhifudiviview1;
    [self.tablefooterview addSubview:zhifudiviview1];
    zhifudiviview1.backgroundColor = [UIColor blackColor];
    zhifudiviview1.alpha = 0.2;
    zhifudiviview1.frame  = CGRectMake(0, CGRectGetMaxY(alipyimageview.frame) +10, MYScreenW, 1);
    
    
    if ([WXApi isWXAppInstalled]) {
        self.titlearr = @[@"",@""];
    }else{
        self.titlearr = @[@""];
    }
    for (int i = 1; i <= self.titlearr.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake( MYScreenW - 40, (i - 1) * 45, 20, 50);
        //        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:[self.titlearr objectAtIndex:i-1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
        btn.tag = i;
        self.btn = btn;
        [btn addTarget:self action:@selector(selectse:) forControlEvents:UIControlEventTouchUpInside];
        [self.tablefooterview addSubview:btn];
    }

}

/*
 @brief 选择支付方式
 */
-(void)selectse:(UIButton *)btn
{
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    self.payType = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pricecontent resignFirstResponder];
    [self.namecontent resignFirstResponder];
    [self.messagecontent resignFirstResponder];
    [self.view endEditing:NO];
    [self.view resignFirstResponder];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.discountPrice isEqualToString:@"0"]) {
        return 7;
    }else{
    return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *str_Identifier = [NSString stringWithFormat:@"zhifu%ld",(long)[indexPath row]];
    
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
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        
        UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(0, 0, self.view.width, MYRowHeight) text:@"填写个人信息"];
        cell.backgroundColor = MYColor(230, 230, 230);
        titleLabel.text = self.vctittle;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
        
    }else if(indexPath.row ==1)
    {
        UILabel *paricetitle = [self addLabelWithFrame:CGRectMake(kMargin, 0, 100, MYRowHeight) text:@"金额"];
        [cell.contentView addSubview:paricetitle];
        
        if (!self.zongjiastr ||[self.zongjiastr isEqualToString:@""]|| self.zongjiastr == 0 ) {
            self.zongjiastr = @"";
        }else{
        
        }
        UITextField *pricecontent = [self addFieldWithFrame:CGRectMake(MYScreenW/2, 0, MYScreenW/2-kMargin, MYRowHeight) text:[NSString stringWithFormat:@"%@",self.zongjiastr]];
        pricecontent.textAlignment = NSTextAlignmentRight;
        pricecontent.keyboardType =  UIKeyboardTypeDecimalPad;
        self.pricecontent = pricecontent;
        pricecontent.placeholder = @"询问后,请输入金额";
//        pricestr = self.pricecontent.text;
        [cell.contentView addSubview:pricecontent];
        
  
    }else if(indexPath.row == 2)
    {
        if ([self.discountPrice isEqualToString:@"0"]) {
            
            UILabel *realitytitle = [self addLabelWithFrame:CGRectMake(kMargin, 0, 100, MYRowHeight) text:@"实付款"];
            [cell.contentView addSubview:realitytitle];
            
            if (!self.shifujia || [self.shifujia isEqualToString:@""]|| self.shifujia == 0) {
                 self.shifujia = @"¥0";
            }else{
           
            }
            UILabel *realitycontent = [self addLabelWithFrame:CGRectMake(MYScreenW/2, 0, MYScreenW/2-kMargin, MYRowHeight) text:[NSString stringWithFormat:@"%@",self.shifujia]];
            realitycontent.textAlignment = NSTextAlignmentRight;
            self.realitycontent = realitycontent;
            realitycontent.textColor = [UIColor redColor];
            [cell.contentView addSubview:realitycontent];

            
        }else{
        
            UILabel *youhuititle = [self addLabelWithFrame:CGRectMake(kMargin, 0, 100, MYRowHeight) text:@"优惠减免"];
            [cell.contentView addSubview:youhuititle];
            
            if (self.jianmianstr) {
                
            }else{
                self.jianmianstr = @"0";
            }
            UILabel *youhuicontent = [self addLabelWithFrame:CGRectMake(MYScreenW/2, 0, MYScreenW/2-kMargin, MYRowHeight) text:[NSString stringWithFormat:@"¥-%@",self.jianmianstr]];
            youhuicontent.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:youhuicontent];
            
        }
       
        
    }else if(indexPath.row==3)
    {
        if ([self.discountPrice isEqualToString:@"0"]) {
            UILabel *nametitle = [self addLabelWithFrame:CGRectMake(kMargin, 0, 100, MYRowHeight) text:@"姓名"];
            [cell.contentView addSubview:nametitle];
            
            UITextField *namecontent = [self addFieldWithFrame:CGRectMake(MYScreenW/2, 0, MYScreenW/2-kMargin, MYRowHeight) text:[NSString stringWithFormat:@"%@",@""]];
            self.namecontent = namecontent;
            namecontent.textAlignment = NSTextAlignmentRight;
            namecontent.placeholder = @"（请填写您的真实姓名）";
            [cell.contentView addSubview:namecontent];

        }else
        {
        
            UILabel *realitytitle = [self addLabelWithFrame:CGRectMake(kMargin, 0, 100, MYRowHeight) text:@"实付款"];
            [cell.contentView addSubview:realitytitle];
            if (!self.shifujia || [self.shifujia isEqualToString:@""]|| self.shifujia == 0) {
                self.shifujia = @"¥0";
            }else{
                
            }
            UILabel *realitycontent = [self addLabelWithFrame:CGRectMake(MYScreenW/2, 0, MYScreenW/2-kMargin, MYRowHeight) text:[NSString stringWithFormat:@"%@",self.shifujia]];
            realitycontent.textAlignment = NSTextAlignmentRight;
            self.realitycontent = realitycontent;
            realitycontent.textColor = [UIColor redColor];
            [cell.contentView addSubview:realitycontent];

        }
    
    }else if(indexPath.row == 4)
    {
        if ([self.discountPrice isEqualToString:@"0"]) {
            UILabel *phonetitle = [self addLabelWithFrame:CGRectMake(kMargin, 0, 100, MYRowHeight) text:@"联系电话"];
            [cell.contentView addSubview:phonetitle];
            
            
            UITextField *phonecontent = [self addFieldWithFrame:CGRectMake(MYScreenW/2, 0, MYScreenW/2-kMargin, MYRowHeight) text:[NSString stringWithFormat:@"%@",[MYUserDefaults objectForKey:@"code"]]];
            self.phonecontent = phonecontent;
            phonecontent.textColor = [UIColor blackColor];
            phonecontent.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:phonecontent];
            
        }else{
        UILabel *nametitle = [self addLabelWithFrame:CGRectMake(kMargin, 0, 100, MYRowHeight) text:@"姓名"];
        [cell.contentView addSubview:nametitle];
        
        UITextField *namecontent = [self addFieldWithFrame:CGRectMake(MYScreenW/2, 0, MYScreenW/2-kMargin, MYRowHeight) text:[NSString stringWithFormat:@"%@",@""]];
        self.namecontent = namecontent;
        namecontent.textAlignment = NSTextAlignmentRight;
        namecontent.placeholder = @"（请填写您的真实姓名）";
        [cell.contentView addSubview:namecontent];
        }
    }else if(indexPath.row ==5)
    {
        if ([self.discountPrice isEqualToString:@"0"]) {
            UILabel *titlelable = [self addLabelWithFrame:CGRectMake(kMargin, -4, self.view.width, MYRowHeight) text:@"备注:"];
            [cell.contentView addSubview:titlelable];
            
            
            MYTextView *message = [[MYTextView alloc]initWithFrame:CGRectMake(kMargin + 25, 2, self.view.width -kMargin*2 -52, 57)];
             self.messagecontent = message;
            [cell.contentView addSubview:message];
            message.placeHoledr = @"可备注您的需求";
            message.font = leftFont;
            message.alwaysBounceVertical = NO;
        }else
        {
        UILabel *phonetitle = [self addLabelWithFrame:CGRectMake(kMargin, 0, 100, MYRowHeight) text:@"联系电话"];
        [cell.contentView addSubview:phonetitle];
        
        
        UITextField *phonecontent = [self addFieldWithFrame:CGRectMake(MYScreenW/2, 0, MYScreenW/2-kMargin, MYRowHeight) text:[NSString stringWithFormat:@"%@",[MYUserDefaults objectForKey:@"code"]]];
        self.phonecontent = phonecontent;
        phonecontent.textColor = [UIColor blackColor];
        phonecontent.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:phonecontent];
        }
        
    }else if(indexPath.row == 6)
    {
        if ([self.discountPrice isEqualToString:@"0"]) {
            UILabel *zhifuway = [self addLabelWithFrame:CGRectMake(kMargin, 0, MYScreenW, MYRowHeight) text:@"选择支付方式"];
            cell.backgroundColor = MYColor(230, 230, 230);
            [cell.contentView addSubview:zhifuway];

        }else{
        UILabel *titlelable = [self addLabelWithFrame:CGRectMake(kMargin, -4, self.view.width, MYRowHeight) text:@"备注:"];
        [cell.contentView addSubview:titlelable];
        
        
        MYTextView *message = [[MYTextView alloc]initWithFrame:CGRectMake(kMargin + 25, 2, self.view.width -kMargin*2 -52, 57)];
            self.messagecontent = message;
        [cell.contentView addSubview:message];
        message.placeHoledr = @"可备注您的需求";
        message.font = leftFont;
        message.alwaysBounceVertical = NO;
        }
    }else if(indexPath.row == 7)
    {
        if ([self.discountPrice isEqualToString:@"0"]) {
            
        }else{
        UILabel *zhifuway = [self addLabelWithFrame:CGRectMake(kMargin, 0, MYScreenW, MYRowHeight) text:@"选择支付方式"];
        cell.backgroundColor = MYColor(230, 230, 230);
        [cell.contentView addSubview:zhifuway];
       }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.discountPrice isEqualToString:@"0"]) {
        if (indexPath.row == 5) {
            return 70;
        }else{
            
            return MYRowHeight;
        }
    }else
    {
    if (indexPath.row == 6) {
        return 70;
    }else{
        
        return MYRowHeight;
    }
   }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

    
    if ([self.discountPrice isEqualToString:@"0"] || self.discountPrice == nil) {

        float zongpri = [self.pricecontent.text floatValue];
        
        if(_str &&![self.pricecontent.text isEqualToString:@""]&&self.pricecontent.text !=nil)
        {
            if([self.pricecontent.text rangeOfString:@"¥"].location != NSNotFound)
            {
                self.zongjiastr =  [NSString stringWithFormat:@"%.2f",zongpri];
                self.shifujia = [NSString stringWithFormat:@"%.2f",zongpri];
            }else
            {
                self.zongjiastr =  [NSString stringWithFormat:@"¥%.2f",zongpri];
                self.shifujia = [NSString stringWithFormat:@"¥%.2f",zongpri ];
            }
        
        }else if ([self.pricecontent.text isEqualToString:@""] || self.pricecontent.text == nil)
        {
            
        self.zongjiastr =  @"";
        self.shifujia =  [NSString stringWithFormat:@"¥%.2f",zongpri];

        }else
        {
            self.zongjiastr =  [NSString stringWithFormat:@"¥%.2f",zongpri];
            self.shifujia =  [NSString stringWithFormat:@"¥%.2f",zongpri];
        }
        
        if ([self.pricecontent resignFirstResponder]) {
            
            [self.tableview reloadData];
        }

        
    }else{
    
        if ([self.pricecontent resignFirstResponder]) {
        
            NSString *zongpri;
            if ([self.pricecontent.text rangeOfString:@"¥"].location != NSNotFound) {
                    zongpri = [self.pricecontent.text substringFromIndex:1];
            }else{
                    zongpri = self.pricecontent.text;
            }
        float allprice = [zongpri  floatValue];
        
        int jianmian = [self.youhuiPrice floatValue];//减免条件
        int disc = [self.discountPrice floatValue];

            if (allprice >= jianmian) {
            int discont =  (int)allprice/jianmian*disc;
            
            self.jianmianstr = [NSString stringWithFormat:@"%d",discont];
            float shifu = allprice -discont;
            
           if(_str &&![self.pricecontent.text isEqualToString:@""]&&self.pricecontent.text !=nil)
            {
                self.zongjiastr = [NSString stringWithFormat:@"¥%.2f",allprice];
                 self.shifujia = [NSString stringWithFormat:@"¥%.2f",shifu];
                
            }else if([self.pricecontent.text isEqualToString:@""] || self.pricecontent.text == nil)
            {
                self.zongjiastr = @"";
                 self.shifujia = [NSString stringWithFormat:@"¥%.2f",shifu];
            }
            else{
                self.zongjiastr = [NSString stringWithFormat:@"¥%.2f",allprice];
                self.shifujia = [NSString stringWithFormat:@"¥%.2f",shifu];

            }
            
        }else
        {
            self.jianmianstr = @"0";
            if(_str &&![self.pricecontent.text isEqualToString:@""]&&self.pricecontent.text !=nil)
            {
            self.shifujia = [NSString stringWithFormat:@"¥%.2f",allprice];
            self.zongjiastr = [NSString stringWithFormat:@"¥%.2f",allprice];
                
            }else if( [self.pricecontent.text isEqualToString:@""] || self.pricecontent.text == nil)
            {
                self.zongjiastr = @"";
                self.shifujia = [NSString stringWithFormat:@"¥%.2f",allprice];
            }
            else{
                self.zongjiastr = [NSString stringWithFormat:@"¥%.2f",allprice];
                self.shifujia = [NSString stringWithFormat:@"¥%.2f",allprice];
                
            }
        }
            
         [self.tableview reloadData];
            
    }else{
        
          }
    }
   
      _str = @"1";
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
//手机号判断
- (BOOL)checkInput
{
    BOOL accountNumGood = [MYStringFilterTool filterByPhoneNumber:self.phonecontent.text];
    
    if (!accountNumGood) {
        
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return NO;
        
    }else{
        return YES;
    }
}

//点击支付按钮
-(void)fuzhifuBtn
{

    if (![self checkInput])
    {
        [MBProgressHUD showError:@"电话号码有误"];
    }else
    {
        if ([self.namecontent.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请填写真实姓名"];
        }else
        {
            if ([self.payType isEqualToString:@"0"] || [self.payType isEqualToString:@""]|| self.payType == nil) {
                [MBProgressHUD showError:@"请选择支付方式"];
            }else
            {
                if (self.pricecontent.text == nil || [self.pricecontent.text isEqualToString:@""]) {
                    
                    [MBProgressHUD showSuccess:@"请输入金额"];
                }else{
                    
                AFHTTPRequestOperationManager *marager = [[AFHTTPRequestOperationManager alloc]init];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                
                int paytag = [self.payType intValue];
                params[@"payBy"] = [NSString stringWithFormat:@"%d",paytag - 1];//支付方式
                params[@"actualPayment"] =  [self.realitycontent.text  substringFromIndex:1];                                                           //实际付款
                params[@"specialdealsId"] = @"0";                                //特惠ID
                params[@"signature"] = [MYStringFilterTool getSignature];       //签名
                params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];       //毫秒值
                params[@"name"] = self.namecontent.text;        //姓名
                params[@"phone"] = self.phonecontent.text;      //电话
                params[@"sysType"] = @"2";                      //iOS标示
                params[@"evaluate"] = self.messagecontent.text; //买家留言
                params[@"serviceAgency"] = self.vctittle;       //机构名称
                params[@"hospitalId"] = self.solanID;           //美容院id
                params[@"price"] = [self.pricecontent.text substringFromIndex:1];      //输入的金额
                params[@"title"] = self.vctittle;               //美容院名称
                params[@"number"] = @"1";
                params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
                
                if ([self.Vctag isEqualToString:@"1"]) { // Vctag == 1
                    
                    // 医院不传 lable
                    
                }else{
                          params[@"lable"] = @"1";                        //美容院标示
                }
                    
                    [marager POST:[NSString stringWithFormat:@"%@/order/addOrder",kOuternet1] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        if ([responseObject[@"status"] isEqualToString:@"success"]) {
                            
                            NSString *stringInt = [NSString stringWithFormat:@"%@",responseObject[@"type"]];
                            
                            //        支付宝
                            if ([stringInt isEqualToString:@"0"]) {
                
                                MYAliPayViewController *alipayVC = [[MYAliPayViewController alloc]init];
                                [self.navigationController pushViewController:alipayVC animated:YES];

                                alipayVC.partner = responseObject[@"PARTNER"];
                                alipayVC.seller = responseObject[@"SELLER"];
                                alipayVC.privateKey = responseObject[@"privateKey"];
                                alipayVC.tradeNO = responseObject[@"out_trade_no"];
                                alipayVC.serviece = responseObject[@"serviceALI"];
                                alipayVC.inputCharset = responseObject[@"inputCharset"];
                                alipayVC.notifyURL = responseObject[@"notifyURL"];
                                alipayVC.productName = responseObject[@"pay_title"];
                                alipayVC.paymentType = responseObject[@"paymentType"];
                                NSString * result = [self.realitycontent.text substringFromIndex:1]; //截取字符串
                                alipayVC.amount = result;
                                alipayVC.productDescription = responseObject[@"pay_body"];
                                alipayVC.itBPay = responseObject[@"30m"];
                                alipayVC.sign_type = responseObject[@"sign_type"];
                                
                            }
                            
                            //        微信支付
                            else if ([stringInt isEqualToString:@"1"])
                            {
                                
                                MYWeiXinZhiFuController *weixinVC = [[MYWeiXinZhiFuController alloc]init];
                                [self.navigationController pushViewController:weixinVC animated:YES];
                                
                                
                                weixinVC.shangpingname =  responseObject[@"pay_body"];
                                weixinVC.shangpindeatil =  responseObject[@"pay_detail"];
                                
                                NSString * result = [self.realitycontent.text substringFromIndex:1]; //截取字符串
                                weixinVC.preice =  result;
                                
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

//点击键盘上的完成按钮，退出键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.pricecontent resignFirstResponder];
    [self.namecontent resignFirstResponder];
    [self.messagecontent resignFirstResponder];
    return YES;
}
@end
