//
//  MYFinishViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/20.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYFinishViewController.h"
#import "MYOrderList.h"
#import "MYAliPayViewController.h"
#import "MYWeiXinZhiFuController.h"
#import "WXApi.h"
#import "UIButton+Extension.h"
#import "MYOrderCommentViewController.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYLoginViewController.h"
#import "MYHeader.h"
#define btnWidth (MYScreenW - 4 * 20) / 2
#define btnHeight 35

@interface MYFinishViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *titles;

@property (weak, nonatomic) UIButton *lastBtn;

@property (strong, nonatomic) MYOrderList *orderList;

@property(strong,nonatomic) UIButton * btn;;
@property(strong, nonatomic)NSString  *kefuid;

@property (nonatomic, assign) NSInteger isEvaluat;


/** 商品详情 */
@property (copy, nonatomic) NSString *url;
/** 服务机构链接 */
@property (copy, nonatomic) NSString *serviceUrl;
@end

@implementation MYFinishViewController

- (NSArray *)titles
{
    if (!_titles) {
        
        _titles = @[@"订单编号:",@"支付方式:",@"姓名:",@"联系电话:",@"服务机构:"];
    }
    return _titles;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *bellBtn = [[UIButton alloc]init];
    bellBtn.frame = CGRectMake(MYScreenW - 80, 100, 50, 50);
    [bellBtn setImage:[UIImage imageWithName:@"bell"] forState:UIControlStateNormal];
    [bellBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rigthItem  = [[UIBarButtonItem alloc]initWithCustomView:bellBtn];
//    self.navigationItem.rightBarButtonItem = rigthItem;
    bellBtn.imageEdgeInsets =UIEdgeInsetsMake(0, 10, 0, 0);
    
    
    [self requestOrderListData];
    [self setupTableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单列表";
    
    
  
}

- (void)requestOrderListData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.id;
    params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    params[@"signature"] = [MYStringFilterTool getSignature];
    params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    
    if ([self.type isEqualToString:@"1"]) {
        
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/reservationDes/queryResInfoById",kOuternet1] params:params success:^(id responseObject) {
            
            MYOrderList *orderList = [MYOrderList objectWithKeyValues: responseObject[@"des"]];
            
            self.orderList = orderList;
            [self setupFooter];

            [self.tableView reloadData];
            
            
        } failure:^(NSError *error) {
            
        }];
    }else if([self.type isEqualToString:@"2"])//特惠
    {
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@order/queryOrderInfoById",kOuternet1] params:params success:^(id responseObject) {
            
            MYOrderList *orderList = [MYOrderList objectWithKeyValues: responseObject[@"queryOrderInfoById"]];
            
            self.url = responseObject[@"url"];
            self.serviceUrl = responseObject[@"serviceUrl"];
            [self setupFooter];

            
            self.orderList = orderList;
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    [self.view addSubview:tableView];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 5;
    }else {
        
        if([self.status isEqualToString:@"0"])//是否是未付款
        {
            if (self.sumPrice != 0)//是否价格是0
            {
                
                if ([WXApi isWXAppInstalled]) {
                    return 3;
                }else{
                    return 2;
                    
                }
            }else
            {
                return 1;
            }
        }else
        {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        cell.textLabel.font = leftFont;
        cell.textLabel.textColor = titlecolor;
        cell.detailTextLabel.font = leftFont;
        cell.detailTextLabel.textColor = subTitleColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        
        cell.textLabel.text = self.titles[indexPath.row];
        
        if ([self.type isEqualToString:@"1"]) {
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = self.orderList.reserId;
            }else if (indexPath.row == 1){
                cell.detailTextLabel.text = @"专享优惠";
            }else if (indexPath.row == 2){
                cell.detailTextLabel.text = self.orderList.userName;
            }else if (indexPath.row == 3){
                cell.detailTextLabel.text = self.orderList.userPhone;
            }else{
                cell.detailTextLabel.text = self.orderList.designer;
            }
        }else if([self.type isEqualToString:@"2"])
        {
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = self.orderList.orderCode;
            }else if (indexPath.row == 1){
                if ([self.orderList.payBy isEqualToString:@"0"]) {
                    cell.detailTextLabel.text = @"支付宝支付";
                }else{
                    cell.detailTextLabel.text = @"微信支付";
                }
            }else if (indexPath.row == 2){
                cell.detailTextLabel.text = self.orderList.name;
            }else if (indexPath.row == 3){
                cell.detailTextLabel.text = self.orderList.phone;
            }else{
                cell.detailTextLabel.text = self.orderList.serviceAgency;
            }
            
        }
        
        
    }else if(indexPath.section == 1)// 1 组
    {
        
        if ([self.status isEqualToString:@"0"])//是否是未付款
        {
            
            if (self.sumPrice  != 0 )//是否价格是0
            {
                
                
                if (indexPath.row == 0)
                {
                    cell.textLabel.text = @"商品总额";
                    if ([self.type isEqualToString:@"1"]) {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.orderList.designerPrice];
                    }else if ([self.type isEqualToString:@"2"])
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.orderList.actualPayment];
                    }
                }else if(indexPath.row == 1){
                    
                    UIImageView *alipyimageview = [[UIImageView alloc]init];
                    [alipyimageview setImage:[UIImage imageNamed:@"alipay"]];
                    alipyimageview.frame = CGRectMake(kMargin, 10, 60, 60 / 2.6);
                    [cell.contentView addSubview:alipyimageview];
                    
                    UIButton *btn = [[UIButton alloc] init];
                    btn.frame = CGRectMake(MYScreenW - 50, 0, 30, 30);
                    [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
                    [btn addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
                    self.btn = btn;
                    btn.tag = 0;
                    [cell.contentView addSubview:btn];
                }else if (indexPath.row == 2){
                    UIImageView *weixinimageview = [[UIImageView alloc]init];
                    [weixinimageview setImage:[UIImage imageNamed:@"weixin"]];
                    weixinimageview.frame = CGRectMake(kMargin, 10, 60, 60 / 2.6);
                    [cell.contentView addSubview:weixinimageview];
                    
                    UIButton *btn = [[UIButton alloc] init];
                    btn.frame = CGRectMake(MYScreenW - 50, 0, 30, 30);
                    [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
                    [btn addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
                    self.btn = btn;
                    btn.tag = 1;
                    [cell.contentView addSubview:btn];
                }
                
            }
            else{
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"商品总额";
                    if ([self.type isEqualToString:@"1"]) {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.orderList.designerPrice];
                    }else if ([self.type isEqualToString:@"2"])
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.orderList.actualPayment];
                    }
                    
                    
                    
                }
                
                
                
            }
        }else{
            
        }
    }else
    {
        
    }
    
    
    
    
    return cell;
    
}
/*
 @brief 选择支付方式
 */

-(void)selectSex:(UIButton *)btn
{
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    self.orderList.payType  = [NSString stringWithFormat:@"%ld",(long)btn.tag + 1];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32)];
        label.textColor = subTitleColor;
        label.font = leftFont;
        label.textAlignment = NSTextAlignmentCenter;
        if ([self.type isEqualToString:@"1"]) {
            
            label.text = self.orderList.designer;
        }else
        {
            label.text = self.orderList.title;
        }
        [view addSubview:label];
        
        return view;
        
    }else{
        
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return MYRowHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 32;
    }else{
        return 0.5;
    }
}

- (void)setupFooter
{
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.width, 120);
    self.tableView.tableFooterView = view;
    
    UIView *view1= [[UIView alloc] init];
    view1.frame = CGRectMake(0, 0, self.view.width, 40);
    view1.backgroundColor  = [UIColor whiteColor];
    [view addSubview:view1];
    
    
    if ([self.status isEqualToString:@"0"])//是否未付款
    {
        
        if (self.sumPrice != 0){
            
            UILabel *lablefoot = [[UILabel alloc]init];
            lablefoot.frame = CGRectMake(5, 0, MYScreenW-10 , 40);
            NSString *username = [MYUserDefaults objectForKey:@"name"];
            lablefoot.backgroundColor = [UIColor whiteColor];
            lablefoot.numberOfLines = 0;
            if ([self.type isEqualToString:@"1"]) {
                lablefoot.text = [NSString stringWithFormat:@"尊贵的用户您好，%@ 您预约的设计师服务已经成功，请您保持手机畅通，稍后会有客服与您确认，谢谢!",username];
            }else{
                lablefoot.text = [NSString stringWithFormat:@"尊贵的用户您好，%@ 您的下单已经成功，请您保持手机畅通，稍后会有客服与您确认，谢谢!",username];
            }
            [view1 addSubview:lablefoot];
            lablefoot.textColor = titlecolor;
            lablefoot.font = leftFont;
            
            
            UIButton *quitBtn = [[UIButton alloc] init];
            quitBtn.frame =  CGRectMake(kMargin, 50 , MYScreenW-MYMargin , btnHeight);
            quitBtn.layer.masksToBounds = YES;
            quitBtn.layer.cornerRadius = 4;
            [quitBtn setTitle:@"去付款" forState:UIControlStateNormal];
            quitBtn.titleLabel.font = MYSFont(15);
            quitBtn.backgroundColor = MYColor(193, 177, 122);
            [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [quitBtn addTarget:self action:@selector(gotoPay) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:quitBtn];
            
        }else{
            
            UILabel *lablefoot = [[UILabel alloc]init];
            lablefoot.frame = CGRectMake(5, 0, MYScreenW - 10, 40);
            NSString *username = [MYUserDefaults objectForKey:@"name"];
            if ([self.type isEqualToString:@"1"]) {
                lablefoot.text = [NSString stringWithFormat:@"尊贵的用户您好，%@ 您预约的设计师服务已经成功，请您保持手机畅通，稍后会有客服与您确认，谢谢!",username];
            }else{
                lablefoot.text = [NSString stringWithFormat:@"尊贵的用户您好，%@ 您的下单已经成功，请您保持手机畅通，稍后会有客服与您确认，谢谢!",username];
            }
            
            lablefoot.numberOfLines = 0;
            
            [view addSubview:lablefoot];
            lablefoot.textColor = titlecolor;
            lablefoot.font = leftFont;
            
    
            CGFloat pointX1;
            CGFloat pointX2;
            
            if (self.url.length > 0 && self.serviceUrl.length > 0) {
                pointX1 = 20;
                pointX2 = MYScreenW / 2 + 20;
            }else{
                pointX1 = pointX2 = (self.view.width - btnWidth) / 2;
 
            }
            
            if (self.url.length > 0) {
                
                UIButton *goodsBtn = [UIButton addButtonWithFrame:CGRectMake(pointX1, lablefoot.bottom + 20, btnWidth, btnHeight) title:@"商品详情" titleColor:titlecolor font:MianFont image:@"shangpinxiangqingtubiao" highImage:@"shangpinxiangqingtubiao" backgroundColor:MYColor(193, 177, 122) Target:self action:@selector(gotoGoodsDetail)];
                goodsBtn.layer.cornerRadius = 4;
                goodsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                [view addSubview:goodsBtn];
            }
            
            if (self.serviceUrl.length > 0) {
                
                UIButton *serviceBtn = [UIButton addButtonWithFrame:CGRectMake(pointX2, lablefoot.bottom + 20, btnWidth, btnHeight) title:@"去服务机构" titleColor:MYColor(193, 177, 122) font:MianFont image:@"qufuwujigoutubiao" highImage:@"shangpinxiangqingtubiao" backgroundColor:MYColor(76, 76, 76) Target:self action:@selector(gotoService)];
                serviceBtn.layer.cornerRadius = 4;
                serviceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                [view addSubview:serviceBtn];
                
            }

        }
    }else
    {
        UILabel *lablefoot = [[UILabel alloc]init];
        lablefoot.frame = CGRectMake(5, 0, MYScreenW-10, 40);
        NSString *username = [MYUserDefaults objectForKey:@"name"];
        if ([self.type isEqualToString:@"1"]) {
            lablefoot.text = [NSString stringWithFormat:@"尊贵的用户您好，%@ 您预约的设计师服务已经成功，请您保持手机畅通，稍后会有客服与您确认，谢谢!",username];
        }else{
            lablefoot.text = [NSString stringWithFormat:@"尊贵的用户您好，%@ 您的下单已经成功，请您保持手机畅通，稍后会有客服与您确认，谢谢!",username];
        }
        lablefoot.numberOfLines = 0;
        [view addSubview:lablefoot];
        lablefoot.textColor = titlecolor;
        lablefoot.font = leftFont;
          
        
        CGFloat pointX1;
        CGFloat pointX2;
        
        if (self.url.length > 0 && self.serviceUrl.length > 0) {
            pointX1 = 20;
            pointX2 = MYScreenW / 2 + 20;
        }else{
            pointX1 = pointX2 = (self.view.width - btnWidth) / 2;
            
        }
        
        if (self.url.length > 0) {
            
            UIButton *goodsBtn = [UIButton addButtonWithFrame:CGRectMake(pointX1, lablefoot.bottom + 20, btnWidth, btnHeight) title:@"商品详情" titleColor:titlecolor font:MianFont image:@"shangpinxiangqingtubiao" highImage:@"shangpinxiangqingtubiao" backgroundColor:MYColor(193, 177, 122) Target:self action:@selector(gotoGoodsDetail)];
            goodsBtn.layer.cornerRadius = 4;
            goodsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
            [view addSubview:goodsBtn];
        }
        
        if (self.serviceUrl.length > 0) {
            
            UIButton *serviceBtn = [UIButton addButtonWithFrame:CGRectMake(pointX2, lablefoot.bottom + 20, btnWidth, btnHeight) title:@"去服务机构" titleColor:MYColor(193, 177, 122) font:MianFont image:@"qufuwujigoutubiao" highImage:@"shangpinxiangqingtubiao" backgroundColor:MYColor(76, 76, 76) Target:self action:@selector(gotoService)];
            serviceBtn.layer.cornerRadius = 4;
            serviceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
            [view addSubview:serviceBtn];
            
        }

    }
    
}

- (void)gotoGoodsDetail
{
    MYHomeHospitalDeatilViewController  *hospitaleDeatilVC = [[MYHomeHospitalDeatilViewController alloc]init];
    hospitaleDeatilVC.tag = 100;
    hospitaleDeatilVC.url = self.url;
    [self.navigationController pushViewController: hospitaleDeatilVC animated:YES];
    
}

- (void)gotoService
{
    MYHomeHospitalDeatilViewController  *hospitaleDeatilVC = [[MYHomeHospitalDeatilViewController alloc]init];
     hospitaleDeatilVC.tag = 100;
    hospitaleDeatilVC.url = self.serviceUrl;
    [self.navigationController pushViewController: hospitaleDeatilVC animated:YES];

    
}

- (void)gotoPay
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"sysType"] = @"2";//iOS
    params[@"type"] = self.type; //订单类型
    params[@"orderId"] = self.id; //ID
    
    if (self.orderList.payType == nil || [self.orderList.payType isEqualToString:@"0"]) {
        
        [MBProgressHUD showError:@"请选择支付方式"];
    }else{
        int paytye = [self.orderList.payType intValue];
        params[@"payType"] = [ NSString stringWithFormat:@"%d",paytye -1];// 支付方式
        
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/reservationDes/rePay",kOuternet1] params:params success:^(id responseObject) {
            
            if ([responseObject[@"status"] isEqualToString:@"success"]) {
                
                if ([self.orderList.payType isEqualToString:@"1"]) {
                    
                    MYAliPayViewController *zhifubaoVC= [[MYAliPayViewController alloc]init];
                    [self.navigationController pushViewController:zhifubaoVC animated:YES];
                    
                    zhifubaoVC.productName = responseObject[@"pay_title"];
                    zhifubaoVC.productDescription = responseObject[@"pay_body"];
                    zhifubaoVC.amount = responseObject[@"pay_price"];
                    zhifubaoVC.tradeNO = responseObject[@"out_trade_no"];
                    
                    zhifubaoVC.seller = responseObject[@"SELLER"];
                    zhifubaoVC.privateKey = responseObject[@"privateKey"];
                    zhifubaoVC.serviece = responseObject[@"serviceALI"];
                    zhifubaoVC.partner = responseObject[@"PARTNER"];
                    zhifubaoVC.inputCharset = responseObject[@"inputCharset"];
                    zhifubaoVC.notifyURL = responseObject[@"notifyURL"];
                    zhifubaoVC.paymentType = responseObject[@"paymentType"];
                    zhifubaoVC.itBPay = responseObject[@"itBPay"];
                    zhifubaoVC.PayPath = @"1";// 用来支付后回跳判断标示
                    
                }else if ([self.orderList.payType isEqualToString:@"2"])
                {
                    MYWeiXinZhiFuController *weixinzgufuVC = [[MYWeiXinZhiFuController alloc]init];
                    [self.navigationController pushViewController:weixinzgufuVC animated:YES];
                    weixinzgufuVC.shangpingname = responseObject[@"pay_body"];
                    weixinzgufuVC.shangpindeatil = responseObject[@"pay_detail"];
                    NSString * pricea = responseObject[@"pay_price"];
                    double yuan = [pricea doubleValue]/100;
                    
                    weixinzgufuVC.preice  = [NSString stringWithFormat:@"%.2f",yuan];
                    weixinzgufuVC.oderid = responseObject[@"out_trade_no"];
                    weixinzgufuVC.PayPath = @"1";// 用来支付后回跳判断标示
                    
                }else
                {
                    
                }
            }
            
            if ([responseObject[@"status"] isEqualToString:@"-104"]) {
                [MBProgressHUD showHUDWithTitle:@"您已享受此服务" andImage:nil andTime:1.0];
            }

      
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}

//小铃铛
-(void)clickBell
{
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
