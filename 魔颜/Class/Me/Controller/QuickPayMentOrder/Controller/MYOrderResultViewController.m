//
//  MYOrderResultViewController.m
//  魔颜
//
//  Created by Meiyue on 16/5/18.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYOrderResultViewController.h"
#import "UITableView+Extension.h"
#import "UIButton+Extension.h"
#import "UITextField+Extension.h"
#import "MYAliPayViewController.h"
#import "MYWeiXinZhiFuController.h"
#import "WXApi.h"
#import "MYHeader.h"
#define rightX 60

@interface MYOrderResultViewController ()

/** tableView */
@property (weak, nonatomic) UIScrollView *scrollView;

//数量
@property (nonatomic,retain)UILabel *numberLabel;

/** 地址 */
@property (weak, nonatomic) UILabel *addressLeft;

//显示数量
@property (assign, nonatomic) NSInteger num;

//数量
@property (nonatomic,retain) UILabel *totalLabel;

/** 记录上次选中按钮 */
@property (weak, nonatomic) UIButton *lastBtn;


@property(assign,nonatomic) NSInteger PayTypeTag;
@property(strong,nonatomic) UILabel * explainLabel;

@property(assign,nonatomic) CGFloat  actualPayment; //实付款

/** 优惠价格 */
@property (nonatomic, assign) CGFloat cutPrice;

/** 微信 */
@property (weak, nonatomic) UIView *weChatView;

/** 支付宝 */
@property (weak, nonatomic) UIView *aliPayView;


@end

@implementation MYOrderResultViewController


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.num = 1;
    [self setupUI];
    self.actualPayment = [self.discountPrice floatValue];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"订单";
    
    UIView *linetop = [[UIView alloc]initWithFrame:CGRectMake(0, 64, MYScreenW, 0.5)];
    [self.view addSubview:linetop];
    linetop.backgroundColor = UIColorFromRGB(0xcccccc);
    

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, MYScreenW, self.view.height)];
    scrollView.backgroundColor = MYBgColor;
    scrollView.contentSize = CGSizeMake(0, self.view.height+100);
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    [self setupScrollView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MYScreenH - 50, MYScreenW, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *explainLabel = [UILabel addLabelWithFrame:CGRectMake(kMargin, 0, 150, bottomView.height) title:[NSString stringWithFormat:@"已优惠:￥%.2f",self.cutPrice] titleColor:UIColorFromRGB(0x999999) font:MYFont(12)];
    [bottomView addSubview:explainLabel];
    self.explainLabel = explainLabel;
    

    UIButton *payBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 100, 0, 100, bottomView.height) title:@"付款" backgroundColor:UIColorFromRGB(0xed0381) titleColor:[UIColor whiteColor] font:MYFont(17) Target:self action:@selector(goToPay)];
    [bottomView addSubview:payBtn];
    
    
    UILabel *totalLabel = [UILabel addLabelWithFrame:CGRectMake(payBtn.x - MYScreenW / 3 - 5, 0, MYScreenW / 3, bottomView.height) title:[NSString stringWithFormat:@"合计:￥%@",self.discountPrice] titleColor:UIColorFromRGB(0xed0381) font:MYFont(15)];
    self.totalLabel = totalLabel;
    totalLabel.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:totalLabel];
    

    
}

- (void)setupScrollView
{
    self.cutPrice = [self.price floatValue] - [self.discountPrice floatValue];
    
    /** 第一栏 */
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, 45)];
    nameView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:nameView];
    
    UILabel *nameLabel = [UILabel addLabelWithFrame:CGRectMake(kMargin, 0, 100, nameView.height) title:@"收货人信息" titleColor:UIColorFromRGB(0x4c4c4c) font:MYFont(15)];
    [nameView addSubview:nameLabel];
    
    UIButton *editBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 30-15, 0, 30, nameView.height) title:@"修改" backgroundColor:nil titleColor:UIColorFromRGB(0x808080) font:MYFont(14) Target:self action:@selector(editName)];
    [nameView addSubview:editBtn];
    
    /** 第二栏 */
    CGFloat height = 160;
    if (NULLString(self.address)) {
        
            height = 80;
    }else{
            height = 160;
    }
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, nameView.bottom + 2, MYScreenW, height)];
    infoView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:infoView];
    
    /** 姓名 */
    UILabel *nameLeft = [UILabel addLabelWithFrame:CGRectMake(kMargin, 0, 50, 40) title:@"姓名" titleColor:UIColorFromRGB(0x4c4c4c) font:MYFont(15)];
    [infoView addSubview:nameLeft];
    
    UILabel *nameRight = [UILabel addLabelWithFrame:CGRectMake(rightX, 0, MYScreenW - rightX - kMargin, nameLeft.height) title:self.name titleColor:titlecolor font:MYFont(14)];
    [infoView addSubview:nameRight];
    
    /** 地址 */
    if (!NULLString(self.address)) {
        
        UILabel *addressLeft = [UILabel addLabelWithFrame:CGRectMake(kMargin, nameLeft.bottom, 50, nameLeft.height) title:@"地址" titleColor:UIColorFromRGB(0x4c4c4c) font:MYFont(15)];
        self.addressLeft = addressLeft;
        [infoView addSubview:addressLeft];
        
        UILabel *addressRight = [UILabel addLabelWithFrame:CGRectMake(rightX, addressLeft.y, MYScreenW - rightX - kMargin, nameLeft.height) title:self.address titleColor:titlecolor font:MYFont(14)];
        [infoView addSubview:addressRight];
    }
    
    /** 手机 */
    UILabel *phoneLeft = [UILabel addLabelWithFrame:CGRectMake(kMargin, nameLeft.bottom + self.addressLeft.height, 50, nameLeft.height) title:@"手机" titleColor:UIColorFromRGB(0x4c4c4c) font:MYFont(15)];
    [infoView addSubview:phoneLeft];
    
    UILabel *phoneRight = [UILabel addLabelWithFrame:CGRectMake(rightX, phoneLeft.y, MYScreenW - rightX - kMargin, nameLeft.height) title:self.phoneNumber titleColor:titlecolor font:MYFont(14)];
    [infoView addSubview:phoneRight];
    
    if ([self.FROMEVC isEqualToString:@"PRODUCT"]) {
        
        /** 收货时间 */
        UILabel *takeGoodsLeft = [UILabel addLabelWithFrame:CGRectMake(kMargin, phoneLeft.bottom, 70, nameLeft.height) title:@"收货时间" titleColor:UIColorFromRGB(0x4c4c4c) font:MYFont(15)];
        [infoView addSubview:takeGoodsLeft];
        
        NSArray *arr = @[@"任意时间",@"仅限工作日",@"仅限双休日或假期"];
        NSInteger index = [self.receiptTime integerValue];
        
        UILabel *takeGoodsRight = [UILabel addLabelWithFrame:CGRectMake(rightX + MYMargin, takeGoodsLeft.y, MYScreenW - rightX - kMargin, nameLeft.height) title:arr[index] titleColor:titlecolor font:MYFont(14)];
        [infoView addSubview:takeGoodsRight];
        
        UIImageView *descorView = [UIImageView addImaViewWithFrame:CGRectMake(0, takeGoodsLeft.bottom + 5, MYScreenW, 5) imageName:@"zhuangshi"];
        [infoView addSubview:descorView];
    }else{
        
        UIImageView *descorView = [UIImageView addImaViewWithFrame:CGRectMake(0, phoneLeft.bottom + 5, MYScreenW, 5) imageName:@"zhuangshi"];
        [infoView addSubview:descorView];
    
    }
    
    /** 第三栏 */
    UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, infoView.bottom + kMargin, MYScreenW, 110)];
    goodsView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:goodsView];
    
    UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(MYMargin, 15, 80, 80)];
    [picView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,self.listPic]]];
    [goodsView addSubview:picView];
    
    
    CGFloat width = MYScreenW - picView.right - 85;
    CGFloat titHeight = [self.goodsTitle heightWithFont:MYFont(14) withinWidth:width];
    
    UILabel *titleLabel = [UILabel addLabelWithFrame:CGRectMake(picView.right + kMargin, picView.y - 6, width, titHeight) title:self.goodsTitle titleColor:UIColorFromRGB(0x333333) font:MYFont(14)];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.backgroundColor = MYRedColor;
//    [titleLabel setRowSpace:4.2];
    [goodsView addSubview:titleLabel];
    
    
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBtn.frame = CGRectMake(titleLabel.x, picView.center.y + kMargin, 25, 25);
    [cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_cutBtn_nomal"] forState:UIControlStateNormal];
    [cutBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [goodsView addSubview:cutBtn];
    
    //数量显示
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.frame = CGRectMake(cutBtn.right + 1, cutBtn.y, cutBtn.width * 2, cutBtn.height);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.num];
    self.numberLabel.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    self.numberLabel.layer.borderWidth = 1.0;
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    [goodsView addSubview:self.numberLabel];
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(self.numberLabel.right + 2, cutBtn.y, cutBtn.width, cutBtn.height);
    
    [addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_nomal"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    addBtn.titleLabel.font = MYFont(14);
    [goodsView addSubview:addBtn];
    
    //特惠价
    UILabel *disPriceLabel = [UILabel addLabelWithFrame:CGRectMake(MYScreenW  - 100, titleLabel.y, 100-15, titleLabel.height) title:[NSString stringWithFormat:@"￥%@",self.discountPrice] titleColor:UIColorFromRGB(0xed0381) font:MYFont(14)];
    disPriceLabel.textAlignment = NSTextAlignmentRight;
    [goodsView addSubview:disPriceLabel];
    
    //原价
    UILabel *priceLabel = [UILabel addLabelWithFrame:CGRectMake(disPriceLabel.x, disPriceLabel.bottom + 10, 100-15, disPriceLabel.height) title:[NSString stringWithFormat:@"￥%@",self.price] titleColor:UIColorFromRGB(0x808080) font:MYFont(10)];
    [priceLabel setCenterLineWithColor:[UIColor lightGrayColor]];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [goodsView addSubview:priceLabel];
    
    
    /** 第四栏 */
    UIView *explainView = [[UIView alloc] initWithFrame:CGRectMake(0, goodsView.bottom + 2, MYScreenW, 50)];
    explainView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:explainView];

    
    UILabel *explainLabel = [UILabel addLabelWithFrame:CGRectMake(40, 0, 200, nameView.height) title:[NSString stringWithFormat:@"已优惠:￥%.2f",self.cutPrice] titleColor:UIColorFromRGB(0x808080) font:MYFont(12)];
    [explainView addSubview:explainLabel];
    
    /** 第五栏 */
    if ([WXApi isWXAppInstalled]) {
        
        UIView *weChatView =[self addViewWithY:explainView.bottom + kMargin imageName:@"weixin1" Title:@"微信支付" andBtnType:2];
        self.weChatView = weChatView;
        
        UIView *aliPayView = [self addViewWithY:explainView.bottom + kMargin + 62 imageName:@"zhifubao" Title:@"支付宝支付" andBtnType:1];
        self.aliPayView = aliPayView;
        

    }else{
        UIView *aliPayView = [self addViewWithY:explainView.bottom + kMargin  imageName:@"zhifubao" Title:@"支付宝支付" andBtnType:1];
        self.aliPayView = aliPayView;

    }

}

- (UIView *)addViewWithY:(CGFloat)y imageName:(NSString *)imageName Title:(NSString *)title andBtnType:(NSInteger)chooseBtnType;
{
 
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.frame = CGRectMake(0, y, MYScreenW, 60);
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];
    
    UIImageView *imageView = [UIImageView addImaViewWithFrame:CGRectMake(kMargin, kMargin, 40, 40) imageName:imageName];
    [view addSubview:imageView];
    
    UILabel *label = [UILabel addLabelWithFrame:CGRectMake(imageView.right + kMargin, 16, 150, 30) title:title titleColor:UIColorFromRGB(0x4c4c4c) font:MYFont(15)];
    [view addSubview:label];
    
    UIButton *btn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 34, 20, 20, 20)backgroundColor:nil Target:self action:nil];
    [btn setImage:[UIImage imageNamed:@"xiaoyuandian"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"xiaoyuandian_select"] forState:UIControlStateSelected];
    btn.tag = chooseBtnType;
    [view addSubview:btn];
    
    UIButton *lineBtn = [UIButton addButtonWithFrame:CGRectMake(0, y, MYScreenW, 60) backgroundColor:nil Target:self action:@selector(didSelectedRow:)];
    lineBtn.tag = chooseBtnType;
    [_scrollView addSubview:lineBtn];

    return view;
}

/**
 *  选择支付方式
 */
- (void)didSelectedRow:(UIButton *)btn
{
        
        UIView *view;
    
        if (btn.tag == 2) {
            view = self.weChatView;
        }else{
            view = self.aliPayView;
        }
    
        for (UIView *subView in view.subviews) {
            
            if ([subView isKindOfClass:[UIButton class]]) {
                
                UIButton *btn = (UIButton *)subView;
                self.lastBtn.selected = NO;
                btn.selected = YES;
                self.lastBtn = btn;
                self.PayTypeTag = btn.tag;
                
                
            }
        }

}

// 数量加按钮
-(void)addBtnClick
{
    if (self.num >= 10 ) {
        
          [MBProgressHUD showHUDWithTitle:@"超出范围" andImage:nil andTime:1.0];
    }else{

        self.num ++;
        CGFloat totalPrice = [self.discountPrice floatValue] * self.num;
        CGFloat cutprice = self.cutPrice *self.num;
        self.actualPayment = totalPrice;
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.num];
        self.totalLabel.text = [NSString stringWithFormat:@"合计:￥%.2f",totalPrice];
        self.explainLabel.text = [NSString stringWithFormat:@"已优惠:￥%.2f",cutprice];
    }
}

//数量减按钮
-(void)cutBtnClick
{
    if ((self.num - 1) <= 0 || self.num == 0) {
        
        [MBProgressHUD showHUDWithTitle:@"超出范围" andImage:nil andTime:1.0];
        
    }else{
    
        self.num --;
        CGFloat totalPrice = [self.discountPrice floatValue] * self.num;
        CGFloat cutprice = self.cutPrice *self.num;
        self.actualPayment = totalPrice;
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.num];
        self.totalLabel.text = [NSString stringWithFormat:@"合计:￥%.2f",totalPrice];
        self.explainLabel.text = [NSString stringWithFormat:@"已优惠:￥%.2f",cutprice];
    }
}

#pragma mark--修改信息
-(void)editName
{
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark--点击付款
-(void)goToPay
{

    if (!self.PayTypeTag)
    {
        
        [MBProgressHUD showError:@"请选择支付方式"];
        
    }else
    {
        
        AFHTTPRequestOperationManager *marager = [[AFHTTPRequestOperationManager alloc]init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];

        params[@"userId"] = self.userId;
        //单价
        params[@"number"] =  self.numberLabel.text ;                         //数量
        params[@"payBy"] = [NSString stringWithFormat:@"%ld",(long)self.PayTypeTag - 1];//支付方式
//                params[@"payBy"] =@(2);//支付方式
        params[@"price"] = self.discountPrice;                  //原价
        params[@"actualPayment"] =  [NSString stringWithFormat:@"%.2f",self.actualPayment];                      //实际付款
        params[@"specialdealsId"] = self.id;                                //特惠ID
        params[@"signature"] = [MYStringFilterTool getSignature];       //签名
        params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];       //毫秒值
        params[@"name"] = self.name;
        params[@"phone"] = self.phoneNumber;
        params[@"sysType"] = @"2";                                      //是后台对ios的判断
        params[@"evaluate"] = self.beizhu;                 //买家留言
        params[@"approver"] = self.address;         //收货地址
        params[@"receiptTime"] =  self.receiptTime;
        params[@"serviceAgency"] = self.jigoustr;    //机构名称
        
        if ([self.Vctage isEqualToString:@"1"]) {
            params[@"lable"] = self.Vctage;
        }
        
   
        [marager POST:[NSString stringWithFormat:@"%@/order/addOrder",kOuternet1] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"status"] isEqualToString:@"success"]) {
                
//                NSString *stringInt = [NSString stringWithFormat:@"%@",responseObject[@"type"]];
                
                //        支付宝
                if (self.PayTypeTag == 1) {
                    
                    MYAliPayViewController *alipayVC = [[MYAliPayViewController alloc]init];
                    [self.navigationController pushViewController:alipayVC animated:YES];
                    //                            productDescription
                    alipayVC.partner = responseObject[@"PARTNER"];
                    alipayVC.seller = responseObject[@"SELLER"];
                    alipayVC.privateKey = responseObject[@"privateKey"];
                    alipayVC.tradeNO = responseObject[@"out_trade_no"];
                    alipayVC.serviece = responseObject[@"serviceALI"];
                    alipayVC.inputCharset = responseObject[@"inputCharset"];
                    alipayVC.notifyURL = responseObject[@"notifyURL"];
                    alipayVC.productName = responseObject[@"pay_title"];
                    alipayVC.paymentType = responseObject[@"paymentType"];
//                    NSString * result = ; //截取字符串
                    alipayVC.amount = [NSString stringWithFormat:@"%.2f",self.actualPayment];
                    alipayVC.productDescription = responseObject[@"pay_body"];
                    alipayVC.itBPay = responseObject[@"30m"];
                    alipayVC.sign_type = responseObject[@"sign_type"];
                    
                }
                
                //        微信支付
                else if ( self.PayTypeTag == 2)
                {
                    
                    MYWeiXinZhiFuController *weixinVC = [[MYWeiXinZhiFuController alloc]init];
                    [self.navigationController pushViewController:weixinVC animated:YES];
                    
                    weixinVC.shangpingname =  responseObject[@"pay_body"];
                    weixinVC.shangpindeatil =  responseObject[@"pay_detail"];
                    
                    //                            NSString * result = [self.zongjiacontent.text substringFromIndex:1]; //截取字符串
                    //                            weixinVC.preice =  result;
                    
                    NSString * pricea = responseObject[@"pay_price"];
                    double yuan = [pricea doubleValue]/100;
                    weixinVC.preice  = [NSString stringWithFormat:@"%.2f",yuan];
                    
                    weixinVC.oderid = responseObject[@"out_trade_no"];
                    
                    
                }else
                {
                    return ;
                }
                
            }
            else if([responseObject[@"status"] isEqualToString:@"-104"])
            {
                [MBProgressHUD showError:@"商品已过期"];
                
            }else if ([responseObject[@"status"] isEqualToString:@"-108"])
            {
                
                [MBProgressHUD showError:@"参数错误 －108"];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            //            [MBProgressHUD showError:@"亲，提交失败"];
        }];
    }

    

}

/**
 
 {
	serviceAgency = "美约(深圳)网络技术有限公司",
	payBy = "1",
	phone = "18801040890",
	specialdealsId = "82",
	userId = "206",
	price = "178",
	signature = "f5e28a03ffe91394999c3ccdad600284",
	number = "1",
	msecs = "1463650948",
	sysType = "2",
	evaluate = "",
	actualPayment = "178.00",
	approver = "河南周口",
	name = "测试数据",
	receiptTime = "1",
 }

// 支付宝
 pay_detail = "优惠仅在魔颜",
	appId = "wxee3be451dbc68260",
	type = 1,
	pay_body = "玻尿酸原液7支  润百颜蜂巢玻尿酸原液7支",
	privateKey = "20moyanwang1511moyanwang01myw115",
	out_trade_no = "1463657712752_2",
	WX_URL = "https://api.mch.weixin.qq.com/pay/unifiedorder",
	backage = "Sign=WXPay",
	mchId = "1283314201",
	trade_type = "APP",
	orderId = "1463657712752_2",
	backUrl = "http://121.43.229.113:8081/shaping/payBack/wx_pay_callback",
	appSecret = "8a40ec694c49b9c0e9b6ee282cc97880",
	status = "success",
	pay_price = "13900",

 
 
 */
@end
