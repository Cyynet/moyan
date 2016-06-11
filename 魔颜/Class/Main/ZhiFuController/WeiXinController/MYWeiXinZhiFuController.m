//
//  WeiXinZhiFuController.m
//  魔颜
//
//  Created by abc on 15/11/7.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYWeiXinZhiFuController.h"
#define textfont  [UIFont systemFontOfSize:14]
#define textcolor  MYColor(80, 80, 80)
#define  alap 0.2

#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"

#import "MYHomeHospitalDeatilViewController.h"
#import "MYOrderViewController.h"
#import "MYQuickPaySuccessViewController.h"
@interface MYWeiXinZhiFuController ()<WXApiDelegate>

@end

@implementation MYWeiXinZhiFuController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //    移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *logoimgae = [[UIImageView alloc]init];
    
    logoimgae.image = [UIImage imageNamed:@"share_logo_weixin"];
    logoimgae.frame = CGRectMake((MYScreenW - 60)/2, 30, 60 , 60);
    
    [self.view addSubview:logoimgae];
    
    [self addtopview];
    [self addboomview];
    
    [MYNotificationCenter addObserver:self selector:@selector(WeixinPaystatus:) name:@"weixinPaystatusSuccess" object:nil];
    
}
//返回微信支付的状态
-(void)WeixinPaystatus:(NSNotification *)noti
{
    if ([noti.userInfo[@"status"] isEqualToString:@"success"]) {
        
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if([self.PayPath isEqualToString:@"1"]) // 订单中心的支付回跳
//            {
//                
//                if ([controller isKindOfClass:[MYOrderViewController class]]) {
//                    
//                    [self.navigationController popToViewController:controller animated:YES];
//                }
//                
//            }else{
//                if ([controller isKindOfClass:[MYHomeHospitalDeatilViewController class]]) {
//                    
//                    [self.navigationController popToViewController:controller animated:YES];
//                }
//            }
//        }

        MYQuickPaySuccessViewController *PaySuccessVc = [[MYQuickPaySuccessViewController alloc]init];
        
        PaySuccessVc.PayPath = self.PayPath;
        
        [self.navigationController pushViewController:PaySuccessVc animated:YES];
        
        
    }else
    {
        //    留在支付前的页面
        
    }
    
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
    shangpinContent.text = self.shangpingname;
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
    shangpinMaoshuContent.text = self.shangpindeatil;
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
    priceContent.text = [NSString stringWithFormat:@"¥%@",self.preice];
    NSLog(@"---self.preice-%@---",self.preice);
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
    dingdantitle.frame = CGRectMake(left, CGRectGetMaxY(line3.frame), kmargin +5, height);
    
    
    
    UILabel *dingdanContent = [[UILabel alloc]init];
    [self.view addSubview:dingdanContent];
    dingdanContent.text = self.oderid ;
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
    [view1 addTarget:self action:@selector(weixinzhifuBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *view2 = [[UIButton alloc]init];
    view2.frame = CGRectMake((MYScreenW - 200)/2, MYScreenH - 50, 200, 35);
    [self.view addSubview:view2];
    view2.backgroundColor = MYColor(109,109,109);
    [view2 setTitle:@"取消" forState:UIControlStateNormal];
    view2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view2.titleLabel.font = leftFont;
    [view2 addTarget:self action:@selector(weixinquxiaoBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

//微信支付取消
-(void)weixinquxiaoBtn
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//去微信支付页面
-(void)weixinzhifuBtn
{
    [self sendPay_demo:self.oderid];
    
}

//签名
- (void)sendPay_demo:(NSString *)odrer
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    
    //初始化支付签名对象
    [req init:@"wxee3be451dbc68260" mch_id:@"1283314201"];
    //设置密钥
    [req setKey:@"20moyanwang1511moyanwang01myw115"];
    

    
    //订单标题，展示给用户
    NSString *order_name    = @"moyanwang";

    float  pri = [self.preice floatValue]*100;
    //订单金额,单位（分）
    NSString *order_price   = [NSString stringWithFormat:@"%.0f",pri];

    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:order_price orderName:order_name oder:odrer];


    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
    }else{
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
        
    }
}
//客户端提示信息
-(void)alert:(NSString *)title msg:(NSString *)msg
{
   
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
    
}


@end
