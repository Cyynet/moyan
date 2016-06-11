//
//  MYDiscountDinggouViewController.m
//  魔颜
//
//  Created by abc on 15/10/27.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYDiscountDinggouViewController.h"
#import "MYDiscountFuWuJieSaoViewController.h"


#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"

#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"

#import "MYAliPayViewController.h"
#import "MYWeiXinZhiFuController.h"
#import "MobClick.h"

#import "MYTextView.h"
#import "MYHeader.h"
#define  titlefont  [UIFont systemFontOfSize:15]
#define   alap  0.2
#define  jianju   45
#define leftjianju 10

@interface MYDiscountDinggouViewController ()<UITextFieldDelegate,WXApiDelegate,UIScrollViewDelegate,UITextViewDelegate>


@property(strong,nonatomic) UIView  * bigVeiw;


@property(strong,nonatomic) UILabel * dingjintitle;
@property(strong,nonatomic) UILabel * dingjincontent;

@property(strong,nonatomic) UILabel * dingjinjiatitle;
@property(strong,nonatomic) UILabel * dingjinjiacontent;

@property(strong,nonatomic) UILabel * zongjiatitle;
@property(strong,nonatomic) UILabel * zongjiacontent;

@property(strong,nonatomic) UILabel * numbertitle;
@property(strong,nonatomic) UILabel * numbercontent;

@property(strong,nonatomic) UILabel * nametitle;
@property(strong,nonatomic) UITextField * namecontent;

@property(strong,nonatomic) UILabel * dianhuatitle;
@property(strong,nonatomic) UITextField * dianhuacontent;


@property(strong,nonatomic) UILabel * addresstitle;
@property(strong,nonatomic) UITextField * addresscontent;


@property(strong,nonatomic) MYTextView * messagecontent;


@property(strong,nonatomic) UIButton * qufukuanbtn;


@property(strong,nonatomic) UIButton  * jiabtn;
@property(strong,nonatomic) UIButton * jianbtn;


//支付
@property(assign, nonatomic) NSInteger tag;

@property(strong,nonatomic)UILabel *paylable;

@property(strong,nonatomic)UIView *paycontent;
@property (strong, nonatomic) NSArray *zhifutitles;
@property (weak, nonatomic) UIButton *zhifulastBtn;
@property (weak, nonatomic) UIButton *zhifubtn;
@property (strong, nonatomic) UIImageView *alipyimageview;
@property (strong, nonatomic) UIImageView *weixinimageview;
@property (strong, nonatomic) UIImageView *yinlianimageview;

// 支付上的分割线
@property(strong,nonatomic)UIView *zhifudiviview1;
@property(strong,nonatomic)UIView *zhifudiviview2;


@property(strong,nonatomic) UIView * personbackview;
@property(strong,nonatomic) UIView * yuyuebackview;
@property(strong,nonatomic) UIView * zhifubackview;

@property (strong, nonatomic) NSArray *titles;



@property(strong,nonatomic) UIScrollView * scrollerview;


@property (weak, nonatomic) UIButton *lastBtn;
@property (weak, nonatomic) UIButton *btn;


@property(strong,nonatomic) UIView * line1;
@property(strong,nonatomic) UIView * line2;
@property(strong,nonatomic) UIView * line3;
@property(strong,nonatomic) UIView * line4;

@property(strong,nonatomic) UISwitch * mianswitch;
@property(strong,nonatomic) UIView * payview;
@property(strong,nonatomic) UILabel * switchlable;

@property(assign,nonatomic) BOOL isOpen;

@property(assign,nonatomic) double  fukuanBtnHeight;

@end

@implementation MYDiscountDinggouViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;

    [MobClick beginLogPageView:@"特惠订单"];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    //    移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.view endEditing:YES];
    [MobClick endLogPageView:@"特惠订单"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor =  MYColor(224  , 224, 224);
    
    self.navigationItem.title = @"立即抢购";
    
    UIButton *rightBtn  = [[UIButton alloc]init];
    [rightBtn setTitle:@"服务介绍" forState:UIControlStateNormal];
    rightBtn.size = CGSizeMake(80, 30);
    rightBtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
    [rightBtn setTitleColor:titlecolor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickrightBtndisger) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
    self.numbercontent.text = @"1";
    UILabel *toplable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 40)];
    toplable.text = self.qianggoutitle;
    toplable.textColor = titlecolor;
    toplable.font = leftFont;
    toplable.backgroundColor = MYColor(224  , 224, 224);
    toplable.textAlignment = NSTextAlignmentCenter;
    
    
    UIScrollView *scrollerview = [[UIScrollView alloc]init];
    [self.view addSubview:scrollerview];
    scrollerview.backgroundColor = MYColor(224  , 224, 224);
    scrollerview.delegate = self;
    self.scrollerview = scrollerview;
//    if (MYScreenH <568) {
//        scrollerview.frame = CGRectMake(0, 0, MYScreenW, MYScreenH +80 );
//        self.view.frame = CGRectMake(0, 0, MYScreenW, MYScreenH + 80);
//        scrollerview.contentSize = CGSizeMake(1, MYScreenH +80);
//    }else{
        scrollerview.frame = CGRectMake(0, 0, MYScreenW, MYScreenH );
        
        scrollerview.contentSize = CGSizeMake(1, MYScreenH +100);
//    }
    scrollerview.scrollEnabled = YES;
    scrollerview.bounces = YES;
    
    scrollerview.showsHorizontalScrollIndicator = YES;
    scrollerview.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollerview.showsVerticalScrollIndicator = NO;
    [self.scrollerview addSubview:toplable];
    
    if ([self.Vctage isEqualToString:@"0"]) {
        
//        self.navigationItem.rightBarButtonItem = rightBtnItem;
        
    }else
    {
        self.isOpen = YES;
        if ([self.LABLE isEqualToString:@"1"]) {
            self.mianswitch.hidden = YES;
            self.switchlable.hidden = YES;
        }
    }
    
    [self setupBigView];
    
    [self addViewTobigView];
    if ([self.Vctage isEqualToString:@"0"]) {
        
        self.mianswitch.hidden = YES;
        self.switchlable.hidden = YES;
        
    }else
    {
        self.mianswitch.hidden = NO;
        if ([self.LABLE isEqualToString:@"1"]) {
            self.mianswitch.hidden = YES;
            self.switchlable.hidden = YES;
        }
    }
    
    [self addboomView];
    [self.namecontent becomeFirstResponder];
    
}

- (void)setupBigView
{
    UIView *bigView = [[UIView alloc]init];
    bigView.frame = CGRectMake(0, 40, MYScreenW, MYScreenH+100 );
    bigView.backgroundColor =[ UIColor whiteColor];
    [self.scrollerview addSubview:bigView];
    self.bigVeiw = bigView;
}

-(void)clickrightBtndisger
{
    MYDiscountFuWuJieSaoViewController *jiesaoVC = [[MYDiscountFuWuJieSaoViewController alloc]init];
    
    [self.navigationController pushViewController:jiesaoVC animated:YES];
}

//添加手势
-(void)clickshoushi
{
    [self.namecontent resignFirstResponder];
    [self.dianhuacontent resignFirstResponder];
    
    [self.view endEditing:YES];
}

//  整体视图内容
-(void)addViewTobigView
{

    CGFloat height = MYRowHeight;
    if ([self.Vctage isEqualToString:@"0"]) {
        if (![self.dingjin isEqualToString:@"0"]) {
            //第一行   定金
            UILabel *dingjintitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, 0, 70, height)];
            [self.bigVeiw addSubview:dingjintitle];
            dingjintitle.text = @"定金";
            dingjintitle.font = leftFont;
            dingjintitle.textColor = titlecolor;
            self.dingjintitle = dingjintitle;
            
            UILabel *dingjincontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, 0, 70, height)];
            [self.bigVeiw addSubview:dingjincontent];
            dingjincontent.text = [NSString stringWithFormat:@"¥%@",self.dingjin];
            dingjincontent.font = leftFont;
            dingjincontent.textColor = titlecolor;
            dingjincontent.textAlignment = NSTextAlignmentRight;
            self.dingjincontent = dingjincontent;
            
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dingjintitle.frame), MYScreenW, 1)];
            line1.backgroundColor = [UIColor blackColor];
            line1.alpha = alap;
            self.line1 = line1;
            [self.bigVeiw addSubview:line1];
            
            
            
            
            //    第2行   预约特惠价
            UILabel *dingjinjiatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(_line1.frame) , 70, height)];
            [self.bigVeiw addSubview:dingjinjiatitle];
            dingjinjiatitle.text = @"预约特惠价";
            dingjinjiatitle.font = leftFont;
            dingjinjiatitle.textColor = titlecolor;
            self.dingjinjiatitle = dingjinjiatitle;
            
            UILabel *dingjinjiacontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, CGRectGetMaxY(_line1.frame), 70, height)];
            [self.bigVeiw addSubview:dingjinjiacontent];
            self.dingjinjiacontent = dingjinjiacontent;
            dingjinjiacontent.text = [NSString stringWithFormat:@"¥%@",self.yuyuejia];
            dingjinjiacontent.font = leftFont;
            dingjinjiacontent.textColor = titlecolor;
            dingjinjiacontent.textAlignment = NSTextAlignmentRight;
            
            
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dingjinjiatitle.frame) , MYScreenW, 1)];
            line2.backgroundColor = [UIColor blackColor];
            line2.alpha = alap;
            self.line2 = line2;
            [self.bigVeiw addSubview:line2];
            
            //    第3行   实付款
            UILabel *zongjiatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(self.dingjinjiacontent.frame)+1, 70, height)];
            [self.bigVeiw addSubview:zongjiatitle];
            zongjiatitle.text = @"实付款";
            zongjiatitle.font = leftFont;
            zongjiatitle.textColor = titlecolor;
            
            
            UILabel *zongjiacontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, zongjiatitle.y, 70, height)];
            [self.bigVeiw addSubview:zongjiacontent];
            self.zongjiacontent = zongjiacontent;
            zongjiacontent.font = leftFont;
            zongjiacontent.textColor = titlecolor;
            zongjiacontent.textAlignment = NSTextAlignmentRight;
            self.zongjiacontent.text = [NSString stringWithFormat:@"%@",self.dingjin];
            
            
            UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(zongjiatitle.frame), MYScreenW, 1)];
            line3.backgroundColor = [UIColor blackColor];
            line3.alpha = alap;
            self.line3 = line3;
            [self.bigVeiw addSubview:line3];
            
            
            
        }else//定金为0 隐藏定金
        {
            

            
            //    第2行  预约特惠价
            UILabel *dingjinjiatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, 0, 70, height)];
            [self.bigVeiw addSubview:dingjinjiatitle];
            dingjinjiatitle.text = @"预约特惠价";
            dingjinjiatitle.font = leftFont;
            dingjinjiatitle.textColor = titlecolor;
            
            UILabel *dingjinjiacontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, 0, 70, height)];
            [self.bigVeiw addSubview:dingjinjiacontent];
            self.dingjinjiacontent = dingjinjiacontent;
            dingjinjiacontent.text = [NSString stringWithFormat:@"¥%@",self.yuyuejia];
            dingjinjiacontent.font = leftFont;
            dingjinjiacontent.textColor = titlecolor;
            dingjinjiacontent.textAlignment = NSTextAlignmentRight;
            
            
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, height+1 , MYScreenW, 1)];
            line2.backgroundColor = [UIColor blackColor];
            line2.alpha = alap;
            self.line2 = line2;
            [self.bigVeiw addSubview:line2];
            
            
            //    第3行  实付款
            UILabel *zongjiatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(self.dingjinjiacontent.frame)+1, 70, height)];
            [self.bigVeiw addSubview:zongjiatitle];
            zongjiatitle.text = @"总价";
            zongjiatitle.font = leftFont;
            zongjiatitle.textColor = titlecolor;
            
            UILabel *zongjiacontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, zongjiatitle.y, 70, height)];
            [self.bigVeiw addSubview:zongjiacontent];
            self.zongjiacontent = zongjiacontent;
            zongjiacontent.font = leftFont;
            zongjiacontent.textColor = titlecolor;
            zongjiacontent.textAlignment = NSTextAlignmentRight;
            zongjiacontent.text = self.yuyuejia;
            
            
            UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(zongjiatitle.frame), MYScreenW, 1)];
            line3.backgroundColor = [UIColor blackColor];
            line3.alpha = alap;
            self.line3 = line3;
            [self.bigVeiw addSubview:line3];
            
        }
        
    }
    else{
        if (![self.dingjin isEqualToString:@"0"]) {
            if (!self.isOpen) {
                
                //第一行   定金
                UILabel *dingjintitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, 0, 70, height)];
                [self.bigVeiw addSubview:dingjintitle];
                dingjintitle.text = @"定金";
                dingjintitle.font = leftFont;
                dingjintitle.textColor = titlecolor;
                self.dingjintitle = dingjintitle;
                
                UILabel *dingjincontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, 0, 70, height)];
                [self.bigVeiw addSubview:dingjincontent];
                dingjincontent.text = [NSString stringWithFormat:@"¥%@",self.dingjin];
                dingjincontent.font = leftFont;
                dingjincontent.textColor = titlecolor;
                dingjincontent.textAlignment = NSTextAlignmentRight;
                self.dingjincontent = dingjincontent;
                
                UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dingjintitle.frame), MYScreenW, 1)];
                line1.backgroundColor = [UIColor blackColor];
                line1.alpha = alap;
                self.line1 = line1;
                [self.bigVeiw addSubview:line1];
                
                
                
                
                //    第2行   预约特惠价
                UILabel *dingjinjiatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(_line1.frame) , 70, height)];
                [self.bigVeiw addSubview:dingjinjiatitle];
                dingjinjiatitle.text = @"预约特惠价";
                dingjinjiatitle.font = leftFont;
                dingjinjiatitle.textColor = titlecolor;
                self.dingjinjiatitle = dingjinjiatitle;
                
                UILabel *dingjinjiacontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, CGRectGetMaxY(_line1.frame), 70, height)];
                [self.bigVeiw addSubview:dingjinjiacontent];
                self.dingjinjiacontent = dingjinjiacontent;
                dingjinjiacontent.text = [NSString stringWithFormat:@"¥%@",self.yuyuejia];
                dingjinjiacontent.font = leftFont;
                dingjinjiacontent.textColor = titlecolor;
                dingjinjiacontent.textAlignment = NSTextAlignmentRight;
                
                
                UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dingjinjiatitle.frame) , MYScreenW, 1)];
                line2.backgroundColor = [UIColor blackColor];
                line2.alpha = alap;
                self.line2 = line2;
                [self.bigVeiw addSubview:line2];
                
                //    第3行   实付款
                UILabel *zongjiatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(self.dingjinjiacontent.frame)+1, 70, height)];
                [self.bigVeiw addSubview:zongjiatitle];
                zongjiatitle.text = @"实付款";
                zongjiatitle.font = leftFont;
                zongjiatitle.textColor = titlecolor;
                
                
                UILabel *zongjiacontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, zongjiatitle.y, 70, height)];
                [self.bigVeiw addSubview:zongjiacontent];
                self.zongjiacontent = zongjiacontent;
                zongjiacontent.font = leftFont;
                zongjiacontent.textColor = titlecolor;
                zongjiacontent.textAlignment = NSTextAlignmentRight;
                self.zongjiacontent.text = [NSString stringWithFormat:@"%@",self.dingjin];
                
                
                UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(zongjiatitle.frame), MYScreenW, 1)];
                line3.backgroundColor = [UIColor blackColor];
                line3.alpha = alap;
                self.line3 = line3;
                [self.bigVeiw addSubview:line3];
                
                
                
            }else//定金为0 隐藏定金
            {
                //    第2行  预约特惠价
                UILabel *dingjinjiatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, 0, 70, height)];
                [self.bigVeiw addSubview:dingjinjiatitle];
                dingjinjiatitle.text = @"预约特惠价";
                dingjinjiatitle.font = leftFont;
                dingjinjiatitle.textColor = titlecolor;
                
                UILabel *dingjinjiacontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, 0, 70, height)];
                [self.bigVeiw addSubview:dingjinjiacontent];
                self.dingjinjiacontent = dingjinjiacontent;
                dingjinjiacontent.text = [NSString stringWithFormat:@"¥%@",self.yuyuejia];
                dingjinjiacontent.font = leftFont;
                dingjinjiacontent.textColor = titlecolor;
                dingjinjiacontent.textAlignment = NSTextAlignmentRight;
                
                
                UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, height+1 , MYScreenW, 1)];
                line2.backgroundColor = [UIColor blackColor];
                line2.alpha = alap;
                self.line2 = line2;
                [self.bigVeiw addSubview:line2];
                
                
        
                //    第3行  实付款
                UILabel *zongjiatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(self.dingjinjiacontent.frame)+1, 70, height)];
                [self.bigVeiw addSubview:zongjiatitle];
                zongjiatitle.text = @"总价";
                zongjiatitle.font = leftFont;
                zongjiatitle.textColor = titlecolor;
                
                UILabel *zongjiacontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, zongjiatitle.y, 70, height)];
                [self.bigVeiw addSubview:zongjiacontent];
                zongjiacontent.font = leftFont;
                zongjiacontent.textColor = titlecolor;
                zongjiacontent.textAlignment = NSTextAlignmentRight;
                zongjiacontent.text = self.yuyuejia;
               
                 self.zongjiacontent = zongjiacontent;
                
                UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(zongjiatitle.frame), MYScreenW, 1)];
                line3.backgroundColor = [UIColor blackColor];
                line3.alpha = alap;
                self.line3 = line3;
                [self.bigVeiw addSubview:line3];
                
            }
        }else
        {
            //    第2行  预约特惠价
            UILabel *dingjinjiatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, 0, 70, height)];
            [self.bigVeiw addSubview:dingjinjiatitle];
            dingjinjiatitle.text = @"预约特惠价";
            dingjinjiatitle.font = leftFont;
            dingjinjiatitle.textColor = titlecolor;
            
            UILabel *dingjinjiacontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, 0, 70, height)];
            [self.bigVeiw addSubview:dingjinjiacontent];
            self.dingjinjiacontent = dingjinjiacontent;
            dingjinjiacontent.text = [NSString stringWithFormat:@"¥%@",self.yuyuejia];
            dingjinjiacontent.font = leftFont;
            dingjinjiacontent.textColor = titlecolor;
            dingjinjiacontent.textAlignment = NSTextAlignmentRight;
            
            
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, height+1 , MYScreenW, 1)];
            line2.backgroundColor = [UIColor blackColor];
            line2.alpha = alap;
            self.line2 = line2;
            [self.bigVeiw addSubview:line2];
            
            
            //    第3行  实付款
            UILabel *zongjiatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(self.dingjinjiacontent.frame)+1, 70, height)];
            [self.bigVeiw addSubview:zongjiatitle];
            zongjiatitle.text = @"总价";
            zongjiatitle.font = leftFont;
            zongjiatitle.textColor = titlecolor;
            
            UILabel *zongjiacontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 80, zongjiatitle.y, 70, height)];
            [self.bigVeiw addSubview:zongjiacontent];
            self.zongjiacontent = zongjiacontent;
            zongjiacontent.font = leftFont;
            zongjiacontent.textColor = titlecolor;
            zongjiacontent.textAlignment = NSTextAlignmentRight;
            zongjiacontent.text = self.yuyuejia;
            
            
            UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(zongjiatitle.frame), MYScreenW, 1)];
            line3.backgroundColor = [UIColor blackColor];
            line3.alpha = alap;
            self.line3 = line3;
            [self.bigVeiw addSubview:line3];
            
        }
    }
    //    第4行 数量
    UILabel *numbertitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju,  CGRectGetMaxY(_line3.frame), 70, height)];
    [self.bigVeiw addSubview:numbertitle];
    numbertitle.text = @"数量";
    numbertitle.font = leftFont;
    numbertitle.textColor = titlecolor;
    
    
    UIButton *jianbtn = [[UIButton alloc]init];
    [jianbtn setImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    [self.bigVeiw addSubview:jianbtn];
    jianbtn.frame = CGRectMake(MYScreenW - 90, CGRectGetMaxY(_line3.frame) +10 , 20, 20);
    [jianbtn addTarget:self action:@selector(jianqu) forControlEvents:UIControlEventTouchUpInside];
    self.jianbtn = jianbtn;
    
    
    UILabel *numbercontent = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW - 75, CGRectGetMaxY(_line3.frame), 50, height)];
    numbercontent.text = @"1";
    [self.bigVeiw addSubview:numbercontent];
    self.numbercontent = numbercontent;
    numbercontent.textAlignment = NSTextAlignmentCenter;
    [numbercontent endEditing:YES];
    UIImageView *coverimgeview = [[UIImageView alloc]initWithFrame:numbercontent.bounds];
    coverimgeview.image = [UIImage imageNamed:@"deleteorder"];
    [numbercontent addSubview:coverimgeview];
    numbercontent.textColor = titlecolor;
    numbercontent.font = leftFont;
    
    int mout = [self.numbercontent.text intValue];
    double danjia = [self.zongjiacontent.text doubleValue];
    
    _zongjiacontent.text = [NSString stringWithFormat:@"¥%.2f",mout*danjia];
    
    
    
    UIButton *addbtn = [[UIButton alloc]init];
    [addbtn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [self.bigVeiw addSubview:addbtn];
    addbtn.frame = CGRectMake(MYScreenW -30, CGRectGetMaxY(_line3.frame)+10, 20, 20);
    [addbtn addTarget:self action:@selector(addnumber) forControlEvents:UIControlEventTouchUpInside];
    self.jiabtn = addbtn;
    
    
    
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numbertitle.frame) , MYScreenW, 1)];
    line4.backgroundColor = [UIColor blackColor];
    line4.alpha = alap;
    self.line4 = line4;
    [self.bigVeiw addSubview:line4];
    
    
    
    //    第5行 姓名
    UILabel *nametitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(line4.frame), 150, height)];
    [self.bigVeiw addSubview:nametitle];
    //    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"姓名  (请填写真实姓名)"];
    //    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:9.0] range:NSMakeRange(2, 9)];
    //    [str addAttribute:NSForegroundColorAttributeName value:subtitlecolor range:NSMakeRange(2,9)];
    nametitle.text = @"姓名";
    nametitle.font = leftFont;
    nametitle.textColor = titlecolor;
    
    
    UITextField *namecontent = [[UITextField alloc]initWithFrame:CGRectMake(nametitle.width + 20,CGRectGetMaxY(line4.frame), MYScreenW - nametitle.width - 30, height)];
    [self.bigVeiw addSubview:namecontent];
    namecontent.placeholder = @"(请您填写真实姓名)";
    namecontent.font = leftFont;
    namecontent.textColor = titlecolor;
    
    namecontent.textAlignment = NSTextAlignmentRight;
    self.namecontent.text = namecontent.text;
    self.namecontent = namecontent;
    namecontent.delegate  = self;
    
    
    
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nametitle.frame) , MYScreenW, 1)];
    line5.backgroundColor = [UIColor blackColor];
    line5.alpha = alap;
    [self.bigVeiw addSubview:line5];
    
    
    //    第6行  电话
    UILabel *dianhuatitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(line5.frame), 70, height)];
    [self.bigVeiw addSubview:dianhuatitle];
    dianhuatitle.text = @"联系电话";
    dianhuatitle.font = leftFont;
    dianhuatitle.textColor = titlecolor;
    
    
    UITextField *dianhuacontent = [[UITextField alloc]initWithFrame:CGRectMake(dianhuatitle.width + 20, CGRectGetMaxY(line5.frame), MYScreenW - dianhuatitle.width - 30 , height)];
    [self.bigVeiw addSubview:dianhuacontent];
    dianhuacontent.font = leftFont;
    dianhuacontent.textColor = titlecolor;
    self.dianhuacontent = dianhuacontent;
    dianhuacontent.text = [MYUserDefaults objectForKey:@"code"];
    dianhuacontent.textAlignment = NSTextAlignmentRight;
    dianhuacontent.keyboardType = UIKeyboardTypeNumberPad;
    self.dianhuacontent.text = dianhuacontent.text;
    
    
    UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dianhuatitle.frame), MYScreenW, 1)];
    line6.backgroundColor = [UIColor blackColor];
    line6.alpha = alap;
    [self.bigVeiw addSubview:line6];
    
    
    //    第7行  收货地址
    UILabel *addresstitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(line6.frame), 70, height)];
    [self.bigVeiw addSubview:addresstitle];
    addresstitle.text = @"地址";
    addresstitle.font = leftFont;
    addresstitle.textColor = titlecolor;
    
    
    UITextField *addresscontent = [[UITextField alloc]initWithFrame:CGRectMake(addresstitle.width + 20, CGRectGetMaxY(line6.frame), MYScreenW - addresstitle.width - 30 , height)];
    [self.bigVeiw addSubview:addresscontent];
    addresscontent.font = leftFont;
    addresscontent.textColor = titlecolor;
    self.addresscontent = addresscontent;
    addresscontent.placeholder = @"(请您填写地址)";
    addresscontent.text = [MYUserDefaults objectForKey:@"region"];
    addresscontent.textAlignment = NSTextAlignmentRight;
    self.addresscontent.text = addresscontent.text;
    
    
    UIView *line7 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(addresstitle.frame), MYScreenW, 1)];
    line7.backgroundColor = [UIColor blackColor];
    line7.alpha = alap;
    [self.bigVeiw addSubview:line7];
    
    //    第8行 留言备注
    UILabel *messagetitle = [[UILabel alloc]initWithFrame:CGRectMake(leftjianju, CGRectGetMaxY(line7.frame) , 50, 30)];
    [self.bigVeiw addSubview:messagetitle];
    messagetitle.text = @"备注";
    messagetitle.font = leftFont;
    messagetitle.textColor = titlecolor;
    
    
    UIView *line8 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(messagetitle.frame), MYScreenW, 1)];
    line8.backgroundColor = [UIColor blackColor];
    line8.alpha = alap;
    [self.bigVeiw addSubview:line8];
    
    
    MYTextView *messagecontent = [[MYTextView alloc]initWithFrame:CGRectMake(kMargin/2, CGRectGetMaxY(line8.frame), MYScreenW - kMargin , 60)];
    messagecontent.delegate = self;
    [self.bigVeiw addSubview:messagecontent];
    //    messagecontent.backgroundColor = [UIColor grayColor];
    messagecontent.font = leftFont;
    messagecontent.textColor = titlecolor;
    self.messagecontent = messagecontent;
    messagecontent.placeHoledr = @"如有特殊需求请您在这里备注，限50个字";
    self.messagecontent.text = messagecontent.text;
    
    
    
    //     支付方式
    
    UIView *payview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(messagecontent.frame)  , MYScreenW, height)];
    [self.bigVeiw addSubview:payview];
    payview.backgroundColor =  MYColor(224  , 224, 224);
    self.payview = payview;
    
    
    
    UILabel *paylable = [[UILabel alloc]init];
    self.paylable = paylable;
    [payview addSubview:paylable];
    paylable.text = @"选择支付的方式";
    paylable.textAlignment = NSTextAlignmentLeft;
    paylable.textColor = MYColor(118, 118, 118);
    //    paylable.backgroundColor = MYColor(224  , 224, 224);
    paylable.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:13.0];
    paylable.frame = CGRectMake(kMargin,0, 100, height);
    
    
    UISwitch * mianswitch = [[UISwitch alloc]initWithFrame:CGRectMake(paylable.width +5, 5, 20, 10)];
    self.mianswitch = mianswitch;
    [payview addSubview:self.mianswitch];
    self.mianswitch.hidden = YES;
    
    [self.mianswitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];


    UILabel *switchlable = [[UILabel alloc]initWithFrame:CGRectMake(paylable.width + self.mianswitch.width +10, 0, 50, height)];
    switchlable.text = @"全款";
    switchlable.textColor = MYColor(118, 118, 118);
    switchlable.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
    [self.payview addSubview:switchlable];
    self.switchlable = switchlable;
    
    if (self.isOpen) {
        [self.mianswitch setOn:YES];
        self.switchlable.hidden = NO;
    }else{
        [self.mianswitch setOn:NO];
        self.switchlable.hidden = YES;
    }
    
    if ([self.LABLE isEqualToString:@"1"]) {
        self.mianswitch.hidden = YES;
        self.switchlable.hidden = YES;
    }
    
    UIView *paycontent = [[UIView alloc]init];
    self.paycontent = paycontent;
    [self.bigVeiw addSubview:paycontent];
    paycontent.frame = CGRectMake(0, CGRectGetMaxY(payview.frame), MYScreenW, 165);
    
    
    CGFloat imageheight = 20;
    CGFloat imagewith = 56;
    
    UIImageView *alipyimageview = [[UIImageView alloc]init];
    self.alipyimageview = alipyimageview;
    [paycontent addSubview:alipyimageview];
    [alipyimageview setImage:[UIImage imageNamed:@"alipay"]];
    alipyimageview.frame = CGRectMake(leftjianju, 15, imagewith, imageheight);
    
    
    if ([WXApi isWXAppInstalled]) {
        
        UIImageView *weixinimageview = [[UIImageView alloc]init];
        self.weixinimageview = weixinimageview;
        [paycontent addSubview:weixinimageview];
        [weixinimageview setImage:[UIImage imageNamed:@"weixin"]];
        weixinimageview.frame = CGRectMake(leftjianju, CGRectGetMaxY(alipyimageview.frame) +25, imagewith, imageheight);
        
        UIView *zhifudiviview2 = [[UIView alloc]init];
        self.zhifudiviview2 = zhifudiviview2;
        [paycontent addSubview:zhifudiviview2];
        zhifudiviview2.backgroundColor = [UIColor blackColor];
        zhifudiviview2.alpha = alap;
        zhifudiviview2.frame  = CGRectMake(0, CGRectGetMaxY(weixinimageview.frame) +10, MYScreenW, 1);
        
        self.fukuanBtnHeight = CGRectGetMaxY(payview.frame) + 120;
    }else{
    
    
    self.fukuanBtnHeight = CGRectGetMaxY(payview.frame) + 70;
        
    }
    
    
    //    UIImageView *yinlianimageview = [[UIImageView alloc]init];
    //    self.yinlianimageview = yinlianimageview;
    //    [paycontent addSubview:yinlianimageview];
    //    [yinlianimageview setImage:[UIImage imageNamed:@"unionpay"]];
    //    yinlianimageview.frame = CGRectMake(leftjianju, CGRectGetMaxY(weixinimageview.frame) +25, imagewith, imageheight);
    
    
    
    //        分割线
    UIView *zhifudiviview1 = [[UIView alloc]init];
    self.zhifudiviview1 = zhifudiviview1;
    [paycontent addSubview:zhifudiviview1];
    zhifudiviview1.backgroundColor = [UIColor blackColor];
    zhifudiviview1.alpha = alap;
    zhifudiviview1.frame  = CGRectMake(0, CGRectGetMaxY(alipyimageview.frame) +10, MYScreenW, 1);
    
    
    if ([WXApi isWXAppInstalled]) {
        self.titles = @[@"",@""];
    }else{
        self.titles = @[@""];
    }
    for (int i = 1; i <= self.titles.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake( MYScreenW - 40, (i - 1) * 45, 20, 50);
        // btn.backgroundColor = [UIColor redColor];
        [btn setTitle:[self.titles objectAtIndex:i-1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
        btn.tag = i;
        self.btn = btn;
        [btn addTarget:self action:@selector(selectSe:) forControlEvents:UIControlEventTouchUpInside];
        [paycontent addSubview:btn];
        
        
        // 监听键盘的弹出的隐藏
        // 监听键盘弹出和退下
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
}

//开关按钮
- (void) switchIsChanged:(UISwitch *)paramSender
{
    if ([paramSender isOn])
    {
        
        self.isOpen = YES;
        self.switchlable.hidden = NO;
        
        [self.bigVeiw removeFromSuperview];
        [self setupBigView];
        [self  addViewTobigView];
        [self addboomView];
        
        
    }else
    {
        self.switchlable.hidden = YES;
        self.isOpen = NO;
        [self.bigVeiw removeFromSuperview];
        [self setupBigView];
        [self  addViewTobigView];
        [self addboomView];
        
        self.dingjincontent.text = [NSString stringWithFormat:@"¥%@",self.dingjin];
        self.zongjiacontent.text = [NSString stringWithFormat:@"¥%@",self.dingjin];
        
//        int mout = [self.numbercontent.text intValue];
//        int danjia = [self.zongjiacontent.text intValue];
//        self.zongjiacontent.text = [NSString stringWithFormat:@"¥%d",mout*danjia];
        
    }
    
}


-(void)selectSe:(UIButton *)btn
{
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    self.tag = btn.tag;
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self clickshoushi];
    
}

//键盘弹出
-(void)keyboardWillShow:(NSNotification *)noti
{
    //
    //    // 取出键盘弹出的时间
    //    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    // 取出键盘高度
    //    CGRect keyBoardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGFloat keyBoardHeight = keyBoardRect.size.height;
    //
    //    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
    //
    //        self.view.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight +170);
    //
    //    } completion:^(BOOL finished) {
    //
    //    }];
}
//键盘推出
-(void)keyboardWillHide:(NSNotification *)noti
{
    
    //    // 取出键盘隐藏的时间
    //    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    // 清空transform
    //    [UIView animateWithDuration:duration animations:^{
    //        self.view.transform = CGAffineTransformIdentity;
    //    }];
    //
    //    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
    //        self.view.transform = CGAffineTransformIdentity;
    //
    //    } completion:^(BOOL finished) {
    //
    //    }];
    //
}

//添加 支付按钮
-(void)addboomView
{
    
    UIButton *qufukuanbtn = [[UIButton alloc]init];

    CGFloat with = 200;
    CGFloat height = 30;
    CGFloat x = (MYScreenW - with)/2;
    CGFloat y = self.fukuanBtnHeight +20;
    qufukuanbtn.frame = CGRectMake(x, y, with, height);
    qufukuanbtn.backgroundColor = MYColor(193, 177, 122);
    [qufukuanbtn setTitle:@"去付款" forState:UIControlStateNormal];
    qufukuanbtn.titleLabel.font = leftFont;
    [qufukuanbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bigVeiw addSubview:qufukuanbtn];
    [qufukuanbtn addTarget:self action:@selector(clickQufukuanBtn) forControlEvents:UIControlEventTouchUpInside];
    self.qufukuanbtn = qufukuanbtn;
    
    
}

//减号
-(void)jianqu
{
    int intString = [self.numbercontent.text intValue];
    if (intString == 1) {
        return;
        
        //        [self.jianbtn setUserInteractionEnabled:NO];
    }else{
        
        intString --;
        
        NSString *stringInt = [NSString stringWithFormat:@"%d",intString];
        self.numbercontent.text = stringInt;
    }
    if ([self.dingjin isEqualToString:@"0"]) {
        int mout = [self.numbercontent.text intValue];
        double danjia = [self.yuyuejia doubleValue];
        self.zongjiacontent.text = [NSString stringWithFormat:@"¥%.2f",mout*danjia];
    }
    else
    {
        if ([self.Vctage isEqualToString:@"0"]) {
            int mout = [self.numbercontent.text intValue];
            double danjia = [self.dingjin doubleValue];
            self.zongjiacontent.text = [NSString stringWithFormat:@"¥%.2f",mout*danjia];
        }else
        {
            if (self.isOpen) {
                int mout = [self.numbercontent.text intValue];
                double danjia = [self.yuyuejia doubleValue];
                self.zongjiacontent.text = [NSString stringWithFormat:@"¥%.2f",mout*danjia];
            }else{
                int mout = [self.numbercontent.text intValue];
                double danjia = [self.dingjin doubleValue];
                self.zongjiacontent.text = [NSString stringWithFormat:@"¥%.2f",mout*danjia];
            
            }
            

        }
        
    }
    
}
//加好
-(void)addnumber
{
    int intString = [self.numbercontent.text intValue];
    if (intString > 999) {
        return;
    }else{
        
        intString ++;
        NSString *stringInt = [NSString stringWithFormat:@"%d",intString];
        self.numbercontent.text = stringInt;
        
    }
    if ([self.dingjin isEqualToString:@"0"]) {
        
        int mout = [_numbercontent.text intValue];
        double danjia = [self.yuyuejia doubleValue];
        _zongjiacontent.text = [NSString stringWithFormat:@"¥%.2f",mout*danjia];
        
        
    }else
    {
        if ([self.Vctage isEqualToString:@"0"]) {
            
            int mout = [_numbercontent.text intValue];
            double danjia = [self.dingjin doubleValue];
            _zongjiacontent.text = [NSString stringWithFormat:@"¥%.2f",mout*danjia];
            
            
        }else{
            if (self.isOpen) {
                int mout = [_numbercontent.text intValue];
                double danjia = [self.yuyuejia doubleValue];
                double zongjia = mout*danjia;
                _zongjiacontent.text = [NSString stringWithFormat:@"¥%.2f",zongjia];
            }else{
                int mout = [_numbercontent.text intValue];
                double danjia = [self.dingjin doubleValue];
                _zongjiacontent.text = [NSString stringWithFormat:@"¥%.2f",mout*danjia];
            }
            

        }
        
 
        
    }
    //    [self.view setNeedsLayout];
    //    [self.view layoutIfNeeded];
    
}


//手机号判断
- (BOOL)checkInput
{
    BOOL accountNumGood = [MYStringFilterTool filterByPhoneNumber:self.dianhuacontent.text];
    
    if (!accountNumGood) {
        
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return NO;
        
    }else{
        return YES;
    }
}

//  去付款
-(void)clickQufukuanBtn
{
    if ([self.addresscontent.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请填写地址"];
    }else{
    //    手机号判断
    if ([self checkInput]) {
        
        if ([self.namecontent.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请填写真实姓名"];
        }else {
            
            if (!self.tag) {
                [MBProgressHUD showError:@"请选择支付方式"];
            }else{
                
                
                AFHTTPRequestOperationManager *marager = [[AFHTTPRequestOperationManager alloc]init];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                if ([self.dingjin isEqualToString:@"0"]) {
                    
                }else{
                    if(self.isOpen)
                    {
                    
                    }else
                    {
                      params[@"earnest"] = self.dingjin;   //定金
                    }
                }
                
                params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
                //单价
                params[@"number"] =  self.numbercontent.text ;                         //数量
                params[@"payBy"] = [NSString stringWithFormat:@"%ld",(long)self.tag - 1];//支付方式
                
                params[@"price"] = self.yuyuejia;                  //原价
                params[@"actualPayment"] =  [self.zongjiacontent.text  substringFromIndex:1];                                 //实际付款
                params[@"specialdealsId"] = self.id;                                //特惠ID
                params[@"signature"] = [MYStringFilterTool getSignature];       //签名
                params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];       //毫秒值
                params[@"name"] = self.namecontent.text;
                params[@"phone"] = self.dianhuacontent.text;
                params[@"sysType"] = @"2";                                      //是后台对ios的判断
                params[@"approver"] = self.addresscontent.text;         //收货地址
                params[@"evaluate"] = self.messagecontent.text;                 //买家留言
                params[@"serviceAgency"] = self.jigoustr;    //机构名称
                if ([self.Vctage isEqualToString:@"1"]) {
                params[@"lable"] = self.Vctage;
                }

                
                [marager POST:[NSString stringWithFormat:@"%@/order/addOrder",kOuternet1] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    if ([responseObject[@"status"] isEqualToString:@"success"]) {
                        
                        NSString *stringInt = [NSString stringWithFormat:@"%@",responseObject[@"type"]];
                        
                        //        支付宝
                        if ([stringInt isEqualToString:@"0"]) {
                            
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
                            NSString * result = [self.zongjiacontent.text substringFromIndex:1]; //截取字符串
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
                        [MBProgressHUD showError:@"亲，下单失败"];
                        
                    }else{
                        
                        [MBProgressHUD showError:@"系统数据异常"];
                    }
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    
                    //            [MBProgressHUD showError:@"亲，提交失败"];
                }];
            }
        }
        
     }
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.scrollerview setContentOffset:CGPointMake(0, 100) animated:YES];
    return YES;
}


@end
