//
//  MYHomeHospitalDeatilViewController.m
//  魔颜
//
//  Created by abc on 15/11/2.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYHomeHospitalDeatilViewController.h"
#import "MYHomeDoctorTableViewController.h"
#import "MYHomeDiscountListTableViewController.h"

#import "MYHomeDoctorDeatilTableViewController.h"
#import "MYDiscountDinggouViewController.h"
#import "LOLShareBtn.h"
#import "LOLShareView.h"
#import "WXApi.h"
#import "MYSalonModel.h"
#import "MYLoginViewController.h"

#import "MYHomeDesignerDeatilAppointmentViewController.h"
#import "FastPayTableViewController.h"

#import "UIButton+Extension.h"
#import "MYDiscountStoreViewController.h"
#import "MYLifeSecondViewController.h"
#import "MYCaiFuTongViewController.h"
#import "MYHomeCharacterTableViewController.h"
#import "MYMasterOrderViewController.h"
#import "LOLScanViewController.h"
#import "MYQuickWriteToOrderForServiceViewController.h"
#import "MYQuickWriteToOrderForProductViewController.h"

#import "MYHeader.h"
/**
 *  根据不同控制器跳转转H5(MYHomeHospitalDeatilViewController)页面。
 依据tag:
 
 if tag = 0  医院详情
 if tag = 1  特惠详情
 if tag = 2  轮播图详情
 if tag = 3  视频详情
 if tag = 4  美容院详情
 if tag = 5  设计师招募
    tag = 7  体验详情
 tag = 100 订单中心 商品详情
 */

@interface MYHomeHospitalDeatilViewController () <UIWebViewDelegate,UIAlertViewDelegate,LOLShareViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) UIWebView *webView;
@property(strong,nonatomic) UIButton * backbtn;

@property(assign,nonatomic) CGFloat lat;//维度
@property(assign,nonatomic) CGFloat  lon;//经度

@property(assign,nonatomic) int  disc;  //医院的距离
@property(assign,nonatomic) int  dic;  //美容院距离

@property(strong,nonatomic) NSString * disct;

@property(strong,nonatomic) NSString * discount;

@property(strong,nonatomic) NSString * doctorkefuID;

@property (nonatomic, assign) NSInteger index;

@property (strong, nonatomic) NSString *titlename;

@property(strong,nonatomic) NSString * webviewtitleName;
@property(strong,nonatomic) NSString * webviewcurrentURL;
@property (copy, nonatomic) NSString *webviewcurrentImage;

/**当前页面的url*/
@property (copy, nonatomic) NSString *currentURL;
/**当前页面的标题*/
@property (copy, nonatomic) NSString *currentTitle;
//*当前页面的第一张图片  进入到webView第二页时用到


@property(strong,nonatomic) UIButton * topview;

@property(strong,nonatomic) NSString * ProductID;

@property(strong,nonatomic) NSString * denglu;



@end

@implementation MYHomeHospitalDeatilViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick endLogPageView:@"医院详情"];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [MobClick beginLogPageView:@"医院详情"];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    //清除UIWebView的缓存x
    [[NSURLCache  sharedURLCache] removeAllCachedResponses];
    
    if([self.denglu isEqualToString:@"denglu"])
    {
        if (MYAppDelegate.isLogin) {
            
            self.url = [NSString stringWithFormat:@"%@/experience/queryExperInfo?id=%@&uId=%@",kOuternet1,self.id,[MYUserDefaults objectForKey:@"id"]];
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }

        
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    
    // 计算距离
    self.lat =  [[MYUserDefaults objectForKey:@"latitude"]  floatValue]  ;
    self.lon =  [[MYUserDefaults objectForKey:@"longitude"]  floatValue]  ;
    
    if(self.lat == 0)
    {
        self.discount = @"0";
        self.disct = @"未知";
    }
    else{
        self.discount = @"1";
        //第一个坐标
        CLLocation *current=[[CLLocation alloc] initWithLatitude: self.lat longitude:self.lon];
        
        double str11 = self.latitude;
        double str22 = self.longitude;
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:str11 longitude:str22];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before];
        double distance = meters/1000;
        self.disc = (int )distance;
        self.dic = (int)distance;
    }
    
    [self loadWebView];

    [self setupNav];
    
    
//    置顶控件
    [self addGotoTopView];
}

//置顶控件
-(void)addGotoTopView
{
    UIButton *topview = [[UIButton alloc]initWithFrame:CGRectMake(MYScreenW-60, MYScreenH - 90, 40, 40)];
    self.topview = topview;
    [self.view addSubview:topview];
    [topview setImage:[UIImage imageNamed:@"totop"] forState:UIControlStateNormal];
    [topview addTarget:self action:@selector(clickTopbtn) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickTopbtn
{
    
    if ([self.webView subviews]) {
        
        UIScrollView* scrollView = [[self.webView subviews] objectAtIndex:0];
        
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
    
}

- (void)setupUI
{
    // 分享的文字
    if (self.titleName == nil || [self.titleName isEqualToString:@""]||[self.titleName isEqualToString:@"魔颜网最强推荐"]) {
        
//        self.titleName = @"魔颜网最强推荐";
        //self.titlename = self.currentTitle;
        self.titleName = self.webviewtitleName;

    }else{
        
        if (self.index) {
            
        }else
        {
            if (NULLString(self.webviewtitleName)) {
            self.titleName = [NSString stringWithFormat:@"   %@",self.titleName];
            }else{
            self.titleName = [NSString stringWithFormat:@"   %@",self.webviewtitleName];
            }
        }
        
    }
    
}

/**导航条上的分享和返回*/
- (void)setupNav
{
    //添加返回按钮
    UIImageView *imageView = [UIImageView addImaViewWithFrame:CGRectMake(15, 30, 12, 18) imageName:@"back"];
    [self.view addSubview:imageView];
    
    self.backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backbtn.frame = CGRectMake(kMargin, MYMargin, 40, 40);
    [self.backbtn addTarget:self action:@selector(clickBackbtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backbtn];
    
    
    if ([WXApi isWXAppInstalled]) {
        
//        if (self.tag != 3) { /**视频暂时不让分享*/
        
            UIImageView *imgView = [UIImageView addImaViewWithFrame:CGRectMake(MYScreenW - 36, 32, 18, 18) imageName:@"share"];
            [self.view addSubview:imgView];
            
            //分享按钮
            UIButton *shareBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 50, 20, 50, 50) image:nil highImage:nil backgroundColor:nil Target:self action:@selector(sharedBtnClick)];
            [self.view addSubview:shareBtn];
//        }
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
}

//加载网页A
- (void)loadWebView
{
   
    UIWebView *webview = [[UIWebView alloc]init];
    webview.delegate = self;
    self.webView = webview;
    webview.backgroundColor = [UIColor whiteColor];

    webview.frame = CGRectMake(0, 0, MYScreenW, MYScreenH );
    
    [webview setScalesPageToFit:YES];
    [self.view addSubview:webview];
    webview.userInteractionEnabled = YES;
  
    
    /**医院详情*/
    if (self.tag == 0) {
        
        if ([self.discount isEqualToString:@"0"]) {
            self.url = [NSString stringWithFormat:@"%@hospital/queryHospitalInfoIndex?id=%@",kOuternet1,self.id];
        }else{
            self.url = [NSString stringWithFormat:@"%@hospital/queryHospitalInfoIndex?id=%@&disc=%d",kOuternet1,self.id,self.disc];
        }
    }
    
    /**特惠详情*/
    if (self.tag == 1) {
        if ([self.classify isEqualToString:@"2"]) {

            self.url = [NSString stringWithFormat:@"%@/newSalonSpe/querySalonNewSpeIndex?id=%@",kOuternet1,self.id];
        }else
        {
            self.url = [NSString stringWithFormat:@"%@specialdeals/querySpecialdealsIndex?id=%@",kOuternet1,self.id];
        }
        
    }
     //美容院
    if(self.tag == 4)
    {
        if ([self.discount isEqualToString:@"0"] || self.discount ==nil) {
            
            self.url = [NSString stringWithFormat:@"%@salon/querySalonInfoIndex?id=%@&dic=%@",kOuternet1,self.id,@"-1"];
        }else{
            
            self.url = [NSString stringWithFormat:@"%@salon/querySalonInfoIndex?id=%@&dic=%d",kOuternet1,self.id,self.dic];
        }
    }
//    新版美容院
    if (self.tag == 5) {
        
        if ([self.discount isEqualToString:@"0"] || self.discount ==nil) {
            
            self.url = [NSString stringWithFormat:@"%@/newSalon/queryNewSalonInfoIndex?id=%@&dic=%@",kOuternet1,self.id,@"-1"];
        }else{
            
            self.url = [NSString stringWithFormat:@"%@/newSalon/queryNewSalonInfoIndex?id=%@&dic=%d",kOuternet1,self.id,self.dic];
        }
    }
    
//    美容院活动页
    if (self.tag == 6) {
        
        self.url = [NSString stringWithFormat:@"%@/newSalonSpe/querySalonNewSpeIndex?id=%@",kOuternet1,self.id];
    }
    
    if (self.tag ==7)//体验详情
    {
        
        if (MYAppDelegate.isLogin) {

            self.url = [NSString stringWithFormat:@"%@/experience/queryExperInfo?id=%@&uId=%@",kOuternet1,self.id,[MYUserDefaults objectForKey:@"id"]];
            
        }else{
            
        self.url = [NSString stringWithFormat:@"%@/experience/queryExperInfo?id=%@",kOuternet1,self.id];
        }
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    
}

/**
 @breif 与js交互
 */
- (BOOL)webView: (UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"myapp"] )
    {
        NSString *type = [url host];
        
        if ([type isEqualToString:@"hospital"])//医生
        {
            
            MYHomeDoctorTableViewController *doctorVC = [[MYHomeDoctorTableViewController alloc] init];
            doctorVC.hospitalId = [url query];
            [self.navigationController pushViewController:doctorVC animated:YES];
            
        }else if ([type isEqualToString:@"totalSale"])//特惠列表
        {
            
            MYHomeDiscountListTableViewController *discountVC = [[MYHomeDiscountListTableViewController alloc] init];
            discountVC.hospitalId = [url query];
            [self.navigationController pushViewController:discountVC animated:YES];
            
        }else if ([type isEqualToString:@"buy"])//润白颜产品跟医院服务跟美容服务
        {
           
            NSString *str = [url query];
            NSArray *array = [str componentsSeparatedByString:@"?"];
            NSString *str1 = [array[0] substringFromIndex:11];
            NSString *str2 = [array[1] substringFromIndex:3];
            NSString *str3 = [array[2] substringFromIndex:14];
            NSString *str4 = [array[3] substringFromIndex:5];
            NSString *str5 = [array[4] substringFromIndex:5];
            NSString *str6 = [array[5] substringFromIndex:6];
            
            NSString *str7 = [str5 stringByAppendingString:str6];
            NSString *string = [str7 stringByRemovingPercentEncoding];
            NSString *jigoustr = [str5 stringByRemovingPercentEncoding];
            
          
            self.ProductID = str2;
          

            if (MYAppDelegate.isLogin) {

                NSMutableDictionary *param = [NSMutableDictionary dictionary];

                param[@"specialdealsId"] = self.ProductID;
                param[@"ver"] = MYVersion;
                param[@"userId"] = [MYUserDefaults objectForKey:@"id"];

                NSString *url;
                if (array.count >6) {
                    url = [NSString stringWithFormat:@"%@/salonSpe/queryUserDiscount",kOuternet1];//美容院

                }else{

                    url = [NSString stringWithFormat:@"%@/specialdeals/queryUserDiscount",kOuternet1];//医院和润白颜(包括MDSUN)
                }
                
                [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@",url] params:param success:^(id responseObject) {
                    
                    if ([responseObject[@"status"] isEqualToString:@"success"]) {
                        if ([responseObject[@"isDiscount"] isEqualToString:@"1"]) // 打折
                        {
                            MYMasterOrderViewController * dinggouVC = [[MYMasterOrderViewController alloc]init];
                            NSString *lablestr ;
                            NSString *number;
                            if (array.count > 6) {
                                
                              dinggouVC.Vctage = @"1";
                                
                                lablestr = [array[6] substringFromIndex:6];
                                number = @"1";
                                
                            }else{
                                
                                dinggouVC.Vctage = @"0";
                            }

                            dinggouVC.hospotalId = str1;
                            dinggouVC.id = str2;
                            dinggouVC.yuyuejia = str3;
                            dinggouVC.dingjin = str4;
                            dinggouVC.qianggoutitle = string;
                            dinggouVC.jigoustr = jigoustr;
                            dinggouVC.LABLE = lablestr;
                            dinggouVC.depict = responseObject[@"depict"];
                            dinggouVC.bindDiscount = responseObject[@"bindDiscount"];
                            dinggouVC.number = number;
                            [self.navigationController pushViewController:dinggouVC animated:YES];
                            
                        }else // 不打折
                        {
                            MYDiscountDinggouViewController*dinggouVC = [[MYDiscountDinggouViewController alloc] init];

                            NSString *lablestr ;
                            if (array.count > 6) {
                                
                                dinggouVC.Vctage = @"1";
                                lablestr = [array[6] substringFromIndex:6];
                                
                            }else{
                                
                                dinggouVC.Vctage = @"0";
                            }
                            dinggouVC.hospotalId = str1;
                            dinggouVC.id = str2;
                            dinggouVC.yuyuejia = str3;
                            dinggouVC.dingjin = str4;
                            dinggouVC.qianggoutitle = string;
                            dinggouVC.jigoustr = jigoustr;
                            dinggouVC.LABLE = lablestr;
                            
                            [self.navigationController pushViewController:dinggouVC animated:YES];
                        }
                    }
                    if ([responseObject[@"status"] isEqualToString:@"-110"]) {
                        
                        [MBProgressHUD showError:@"请登录后重试"];
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
        
            }else{
                
                if (array.count>6) {
                    
                    MYQuickWriteToOrderForServiceViewController *serviceVC = [[MYQuickWriteToOrderForServiceViewController alloc] init];
                    serviceVC.id = str2;
                    serviceVC.discountPrice = str3;
                    serviceVC.goodsTitle = [str6 stringByRemovingPercentEncoding];
                    serviceVC.jigoustr = jigoustr;
                    serviceVC.vctag = @"1";//判断美容院和医院
                    [self.navigationController pushViewController:serviceVC animated:YES];
                    
                }else{
                     /**
                     返回值 type
                     0 润百颜/MDSUN系列产品   1 医院服务
                     status  success 正常   -110 参数错误
                     */
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    
                    param[@"specialdealsId"] = self.ProductID;
                    
                    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/specialdeals/querySpecialdeals",kOuternet1] params:param success:^(id responseObject) {
                        
                        if ([responseObject[@"status"] isEqualToString:@"success"]) {
                            
                            NSString *type = responseObject[@"type"];
                            NSString *listPic = responseObject[@"listPic"];

                            if ([type isEqualToString:@"1"]) {
                                
                              MYQuickWriteToOrderForServiceViewController *serviceVC = [[MYQuickWriteToOrderForServiceViewController alloc] init];
                                serviceVC.id = str2;
                                serviceVC.discountPrice = str3;
                                serviceVC.price = responseObject[@"price"];
                                serviceVC.goodsTitle = [str6 stringByRemovingPercentEncoding];
                                serviceVC.jigoustr = jigoustr;
                                serviceVC.listPic = listPic;
                                serviceVC.vctag = @"0";
                                [self.navigationController pushViewController:serviceVC animated:YES];
                                
                            }else{
                                
                                MYQuickWriteToOrderForProductViewController *serviceVC = [[MYQuickWriteToOrderForProductViewController alloc] init];
                                serviceVC.jigoustr = jigoustr;
                                serviceVC.id = str2;
                                serviceVC.discountPrice = str3;
                                serviceVC.price = responseObject[@"price"];
                                serviceVC.goodsTitle = [str6 stringByRemovingPercentEncoding];
                                serviceVC.vctag = @"0";
                                serviceVC.listPic = listPic;
                                [self.navigationController pushViewController:serviceVC animated:YES];
                            }
                            
                        }else{
                            
                            
                        }
                        
                    } failure:^(NSError *error) {
                        
                        MYLog(@"####%@",error);
                        
                    }];
                
                }
                
            }
                
               
                 
                 

            
        }else if([type isEqualToString:@"Appoint"]) //名医预约
        {
            
            MYHomeDesignerDeatilAppointmentViewController *DesigerAppiontmentVC = [[MYHomeDesignerDeatilAppointmentViewController alloc]init];
            
            NSString *str = [url query];
            NSArray *array = [str componentsSeparatedByString:@"?"];
            NSString *str1 = [array[0] substringFromIndex:5];
            NSString *str2 = [array[1] substringFromIndex:6];
            NSString *str3 = [str1 stringByRemovingPercentEncoding];
            
            DesigerAppiontmentVC.name = str3;
            DesigerAppiontmentVC.desigerPrice = str2;
            
            if (MYAppDelegate.isLogin) {
                [self.navigationController pushViewController:DesigerAppiontmentVC animated:YES];
            }else{
                
                MYLoginViewController *loginVC  = [[MYLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
        }else if([type isEqualToString:@"kefu"])  //名医客服
        {
            NSString *str = [url query];
            NSArray *array = [str componentsSeparatedByString:@"?"];
            NSString *str1 = [array[0]  substringFromIndex:5];
            NSString *namestr = [str1 stringByRemovingPercentEncoding];
            
            
            
            if (MYAppDelegate.isLogin) {
                [self PushKeFuVC:namestr];
            }else{
                
                MYLoginViewController *loginVC  = [[MYLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
        }else if([type isEqualToString:@"salon"]) //后支付
        {

            NSString *str = [url query];
            NSArray  *array = [str componentsSeparatedByString:@"?"];
            NSString *str1 = [array[0]  substringFromIndex:5];
            NSString *namestr = [str1 stringByRemovingPercentEncoding];
            NSString *str2 = [array[1] substringFromIndex:5];
            NSString *str3 = [array[2] substringFromIndex:7];
            NSString *IDstr = [array[3] substringFromIndex:3];
//name=%E9%AD%94%E9%A2%9C%E7%BD%91?full=100?reduce=0?id=25 魔颜通 ／ 美容院
//name=%E5%8C%97%E4%BA%AC%E5%9F%BA%E6%81%A9%E5%8C%BB%E9%99%A2?full=100?reduce=0?id=29?status=1 医院
            NSString *status;
            if (self.tag == 0) {
                status = [array[4] substringFromIndex:7];
            }else{
            
            }
            
            FastPayTableViewController *fastVC = [[FastPayTableViewController alloc]init];
            fastVC.vctittle = namestr;
            fastVC.youhuiPrice = str2;
            fastVC.discountPrice = str3;
            fastVC.solanID = IDstr;
            fastVC.Vctag = status;
            
            if (MYAppDelegate.isLogin) {
                
                [self.navigationController pushViewController:fastVC animated:YES];
                
            }else{
                
                MYLoginViewController *loginVC  = [[MYLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
        }else if([type isEqualToString:@"list"])
        {
            
            MYDiscountStoreViewController *lifeVC = [[MYDiscountStoreViewController alloc]init];
            lifeVC.scrollPoint = MYScreenW;
            lifeVC.TAG = @"1";
            [self.navigationController pushViewController:lifeVC animated:YES];
            
        }else if([type isEqualToString:@"generalPay"]) //财付通付款页面
        {
            NSString *str = [url query];
            NSArray  *array = [str componentsSeparatedByString:@"?"];
            NSString *price = [array[0] substringFromIndex:6];
            NSString *id = [array[1] substringFromIndex:3];
            NSString *name = [array[2] substringFromIndex:5];
            NSString *namestr = [name stringByRemovingPercentEncoding];
            
            MYCaiFuTongViewController *caifutongVC = [[MYCaiFuTongViewController alloc]init];
            caifutongVC.solanID = id;
            caifutongVC.price = price;
            caifutongVC.titlestr = namestr;
            
            if (MYAppDelegate.isLogin) {
                
                [self.navigationController pushViewController:caifutongVC animated:YES];

            }else{
                
                MYLoginViewController *loginVC  = [[MYLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }

        }else if([type isEqualToString:@"secondLife"])
        {
            NSString *str = [url query];
            NSArray *array = [str componentsSeparatedByString:@"?"];
            NSString *id = [array[0] substringFromIndex:5];
            NSString *name = [array[1] substringFromIndex:9];
            NSString *typeName = [name stringByRemovingPercentEncoding];
            
            MYLifeSecondViewController *secondVC = [[MYLifeSecondViewController alloc] init];
            secondVC.type = id;
            secondVC.titlename = typeName;
            [self.navigationController pushViewController:secondVC animated:YES];
         }else if([type isEqualToString:@"doctor"])
        {

            MYHomeDoctorDeatilTableViewController *doctorDetailVC = [[MYHomeDoctorDeatilTableViewController alloc] init];
            doctorDetailVC.id = [url query];
            doctorDetailVC.hospitalId = [[url path] substringFromIndex:1];
            [self.navigationController pushViewController:doctorDetailVC animated:YES];
        }else if([type isEqualToString:@"denglu"]){
            
            MYLoginViewController *dengluVC = [[MYLoginViewController alloc]init];
            
            [self.navigationController pushViewController:dengluVC animated:YES];
            
            self.denglu = @"denglu";
        }

        
        [self.webView stopLoading];
        
        return NO;
    }
    return YES;
}

/**
 *  返回
 */
-(void)clickBackbtn
{
    
    if ([self.webView canGoBack]) {
     
        if ([self.denglu isEqualToString:@"denglu"]) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                if ([controller isKindOfClass:[LOLScanViewController class]]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
           [self.webView goBack];
            }
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
           
            if ([controller isKindOfClass:[LOLScanViewController class]]) {
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
        
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
 @brief 分享
 */
-(void)sharedBtnClick
{

        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.webviewcurrentImage]]]];

        LOLShareView *shareView = [[LOLShareView alloc] init];
        shareView.delegate = self;
        
        self.titleName = [NSString stringWithFormat:@"      %@",self.webviewtitleName];

        [shareView startShareWithText:self.titleName image:image];
        
    
}

//分享
- (void)shareViewDidClickShareBtn:(LOLShareView *)shareView selBtn:(LOLShareBtn *)shareBtn
{
    [[UMSocialControllerService defaultControllerService] setShareText:shareView.shareText shareImage:shareView.shareImage socialUIDelegate:nil];
    
    if ((shareBtn.socalSnsType == UMSocialSnsTypeWechatTimeline) || (shareBtn.socalSnsType == UMSocialSnsTypeWechatSession) || (shareBtn.socalSnsType == UMSocialSnsTypeMobileQQ)) {
        if ((shareView.shareImage != nil) && (shareView.shareText != nil)) {
        
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"魔颜网";
//                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"魔颜网";
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@&qrc=1",self.webviewcurrentURL];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@&qrc=1",self.webviewcurrentURL];

        
        }
        else
        {
         
                [MBProgressHUD showError:@"请重试"];
                return;
        }
    }
    
    UMSocialSnsPlatform *platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[UMSocialSnsPlatformManager getSnsPlatformString:(shareBtn.socalSnsType)]];
    
    platform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}


// 咨询客服
-(void)PushKeFuVC:(NSString *)name
{
}

/**
 *  @param webView <#webView description#>
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        
        self.webviewtitleName = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.webviewcurrentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
             self.webviewcurrentImage = [webView stringByEvaluatingJavaScriptFromString: @"document.getElementsByTagName(\"img\")[0].src"];
//        NSLog(@"============%@\n==========%@\n===========%@",self.webviewtitleName,self.webviewcurrentURL,self.webviewcurrentImage);
//        [self setupUI];
    });
    
    
   
    
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{

//    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationLandscapeRight;
    
}
// 进入全屏
-(void)begainFullScreen
{
    MYAppDelegate.allowRotation = YES;
}
// 退出全屏
-(void)endFullScreen
{
    MYAppDelegate.allowRotation = NO;
    
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}



@end
