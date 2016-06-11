//
//  AliPayViewController.m
//  魔颜
//
//  Created by abc on 15/11/5.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYAliPayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Order.h"
#define textfont  [UIFont systemFontOfSize:14]
#define textcolor  MYColor(80, 80, 80)
#define  alap 0.2
#import "MYHomeDesignerDeatilAppointmentViewController.h"
#import "MYOrderViewController.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYQuickPaySuccessViewController.h"

@interface MYAliPayViewController ()<WXApiDelegate>

@property(strong,nonatomic) UILabel *shangpinName;
@property(strong,nonatomic) UILabel * shangpinContent;

@property(strong,nonatomic) UILabel * shangpinMaoshutitle;
@property(strong,nonatomic) UILabel * shangpinMaoshuContent;

@property(strong,nonatomic) UILabel *pricetitle;
@property(strong,nonatomic) UILabel * priceContent;

@property(strong,nonatomic) UILabel * dingdantitle;
@property(strong,nonatomic) UILabel * dingdanContent;



@end

@implementation MYAliPayViewController

-(void)viewWillAppear:(BOOL)animated
{[super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoimgae = [[UIImageView alloc]init];
    
    logoimgae.image = [UIImage imageNamed:@"alipay"];
    logoimgae.frame = CGRectMake((MYScreenW -100)/2, 40, 100, 40);
    
    
    
    
    [self.view addSubview:logoimgae];
    
    [self addtopview];
    [self addboomview];
    

    
}
-(void)addshoushi
{
    [self.navigationController popViewControllerAnimated:YES];
}
//上面视图
-(void)addtopview
{
    
    CGFloat magrin = 130;
    CGFloat kmargin = 70;
    CGFloat height = 40;
    CGFloat left = 15;
    CGFloat top = 3;
     CGFloat right = 20;

    //    商品名称
    UILabel *shangpinName = [[UILabel alloc]init];
    [self.view addSubview:shangpinName];
    shangpinName.text = @"商品名称：";
    shangpinName.font = leftFont;
    shangpinName.textColor = titlecolor;
    shangpinName.frame = CGRectMake(left,magrin , kmargin , height);
    
    
    UILabel *shangpinContent = [[UILabel alloc]init];
    [self.view addSubview:shangpinContent];
    shangpinContent.text = self.productName;
    shangpinContent.font = leftFont;
    shangpinContent.textColor = titlecolor;
    shangpinContent.frame = CGRectMake(left + shangpinName.width ,magrin  , MYScreenW - shangpinName.width - left- right, height);
    shangpinContent.textAlignment = NSTextAlignmentRight;
    
    UIView *line1 = [[UIView alloc]init];
    line1.frame = CGRectMake(0, CGRectGetMaxY(shangpinContent.frame) +top, MYScreenW, 1);
    [self.view addSubview:line1];
    line1.backgroundColor =[ UIColor blackColor];
    line1.alpha = alap;
    
    
    //    商品描述
    UILabel *shangpinMaoshutitle = [[UILabel alloc]init];
    [self.view addSubview:shangpinMaoshutitle];
    shangpinMaoshutitle.text = @"商品描述：";
    shangpinMaoshutitle.font = leftFont;
    shangpinMaoshutitle.textColor = titlecolor;
    shangpinMaoshutitle.frame = CGRectMake(left, CGRectGetMaxY(line1.frame), kmargin, height);
    
    
    UILabel *shangpinMaoshuContent = [[UILabel alloc]init];
    [self.view addSubview:shangpinMaoshuContent];
    shangpinMaoshuContent.text = self.productDescription;
    shangpinMaoshuContent.font = leftFont;
    shangpinMaoshuContent.textColor = titlecolor;
    shangpinMaoshuContent.frame = CGRectMake(left + shangpinMaoshutitle.width, CGRectGetMaxY(line1.frame) , MYScreenW - shangpinMaoshutitle.width -left- right, height);
    shangpinMaoshuContent.textAlignment = NSTextAlignmentRight;
    
    UIView *line2 = [[UIView alloc]init];
    line2.frame = CGRectMake(0, CGRectGetMaxY(shangpinMaoshutitle.frame) +top, MYScreenW, 1);
    [self.view addSubview:line2];
    line2.backgroundColor =[ UIColor blackColor];
    line2.alpha = alap;
    
    
    //    价格
    UILabel *pricetitle = [[UILabel alloc]init];
    [self.view addSubview:pricetitle];
    pricetitle.text = @"价       格：";
    pricetitle.font = leftFont;
    pricetitle.textColor = titlecolor;
    pricetitle.frame = CGRectMake(left, CGRectGetMaxY(line2.frame), kmargin, height);
    
    
    UILabel *priceContent = [[UILabel alloc]init];
    [self.view addSubview:priceContent];
    priceContent.text = [NSString stringWithFormat:@"¥%@",self.amount];
    priceContent.font = leftFont;
    priceContent.textColor = titlecolor;
    priceContent.frame = CGRectMake(left + pricetitle.width, CGRectGetMaxY(line2.frame), MYScreenW - pricetitle.width - left- right, height);
    priceContent.textAlignment = NSTextAlignmentRight;
    
    UIView *line3 = [[UIView alloc]init];
    line3.frame = CGRectMake(0, CGRectGetMaxY(pricetitle.frame) +top, MYScreenW, 1);
    [self.view addSubview:line3];
    line3.backgroundColor =[ UIColor blackColor];
    line3.alpha = alap;
    
    
    //    订单
    UILabel *dingdantitle = [[UILabel alloc]init];
    [self.view addSubview:dingdantitle];
    dingdantitle.text = @"订  单  号：";
    dingdantitle.font = leftFont;
    dingdantitle.textColor = titlecolor;
    dingdantitle.frame = CGRectMake(left, CGRectGetMaxY(line3.frame), kmargin , height);
    
    
    
    UILabel *dingdanContent = [[UILabel alloc]init];
    [self.view addSubview:dingdanContent];
    dingdanContent.text = self.tradeNO;
    dingdanContent.font = leftFont;
    dingdanContent.textColor = titlecolor;
    dingdanContent.frame = CGRectMake(left + dingdantitle.width, CGRectGetMaxY(line3.frame), MYScreenW - dingdantitle.width - left- right, height);
    dingdanContent.textAlignment = NSTextAlignmentRight;
    
    
    UIView *line4 = [[UIView alloc]init];
    line4.frame = CGRectMake(0, CGRectGetMaxY(dingdantitle.frame) +top, MYScreenW, 1);
    [self.view addSubview:line4];
    line4.backgroundColor =[ UIColor blackColor];
    line4.alpha = alap;
}

-(void)addboomview
{
    
    UIButton *view1 = [[UIButton alloc]init];
    view1.frame = CGRectMake((MYScreenW - 200)/2, MYScreenH - 100, 200, 35);
    [self.view addSubview:view1];
    view1.backgroundColor = MYColor(193, 177, 122);
    [view1 setTitle:@"支付" forState:UIControlStateNormal];
    view1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view1.titleLabel.font = leftFont;
    [view1 addTarget:self action:@selector(zhifuBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *view2 = [[UIButton alloc]init];
    view2.frame = CGRectMake((MYScreenW - 200)/2, MYScreenH - 50, 200, 35);
    [self.view addSubview:view2];
    view2.backgroundColor = MYColor(109,109,109);
    [view2 setTitle:@"取消" forState:UIControlStateNormal];
    view2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view2.titleLabel.font = leftFont;
    [view2 addTarget:self action:@selector(quxiaoBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

//支付
-(void)zhifuBtn
{
    //                支付宝
    NSString *partner = self.partner;
    NSString *seller = self.seller;
    NSString *privateKey = self.privateKey;
    
    //.封装订单模型
    Order *order = [[Order alloc] init];
    
    order.service = self.serviece;
    order.partner =  partner;
    order.inputCharset = self.inputCharset;
    order.notifyURL = self.notifyURL;
    order.tradeNO = self.tradeNO;       //订单号
    order.productName = self.productName;       //商品名
    order.paymentType = self.paymentType;     //
    order.seller =  seller;                                 //卖家支付宝
    //          order.amount = [NSString stringWithFormat:@"%@.00",responseObject[@"pay_price"]];
    order.amount = self.amount;

    order.productDescription = self.productDescription;     //商品详情
    
    order.itBPay = @"30m";
    
    NSString *appScheme = @"alisdkdemo";
    
    
    //将商品信息拼接成字符串  // 生成订单描述
    NSString *orderSpec = [order description];
    
    //    获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //2.签名
    
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    // 传入订单描述 进行 签名
    NSString *signedString = [signer signString:orderSpec];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types // appScheme：商户自己的协议头
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    
    
    NSString *orderString = nil;
    if (signedString != nil) {orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSString * strTitle = [NSString stringWithFormat:@"支付结果"];
            NSString *strMsg;
            
            //【callback处理支付结果】
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                
              strMsg = @"恭喜您，支付成功!";
//
//                for (UIViewController *controller in self.navigationController.viewControllers) {
//                    
//                    if([self.PayPath isEqualToString:@"1"]){
//                        
//                        if ([controller isKindOfClass:[MYOrderViewController class]]) {
//                            
//                            [self.navigationController popToViewController:controller animated:YES];
//                        }
//                        
//                    }else{
//                        if ([controller isKindOfClass:[MYHomeHospitalDeatilViewController class]]) {
//                            
//                            [self.navigationController popToViewController:controller animated:YES];
//                        }
//                    }
//                }
                
                MYQuickPaySuccessViewController *PaySuccessVc = [[MYQuickPaySuccessViewController alloc]init];
                PaySuccessVc.PayPath = self.PayPath;
                
                [self.navigationController pushViewController:PaySuccessVc animated:YES];
                
                
                
                
                
            }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"])
            {
                strMsg = @"已取消支付!";

            }else{
                
                 strMsg = @"支付失败!";
            }
         
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
        }];
    }
 }

//取消
-(void)quxiaoBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
