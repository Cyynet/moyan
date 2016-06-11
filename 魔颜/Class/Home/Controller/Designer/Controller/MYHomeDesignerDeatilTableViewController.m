//
//  MYHomeDesignerDeatilTableViewController.m
//  魔颜
//
//  Created by abc on 15/9/29.
//  Copyright (c) 2015年 abc. All rights reserved.
//

//在viewcontroler上放一个scrollview

#import "MYHomeDesignerDeatilTableViewController.h"

#import "MYHomeDesignerDeatilView.h"
#import "MYLoginViewController.h"
#import "MYHomeDesignerDeatilAppointmentViewController.h"
#import "designerdeatilModel.h"

#import "LOLShareView.h"
#import "UMSocial.h"
#import "LOLShareBtn.h"
#import "MYHeader.h"
#define MaxScrollViewHight 667


@interface MYHomeDesignerDeatilTableViewController ()<UIScrollViewDelegate,MYHomeDesignerScrollViewHightDelegate,LOLShareViewDelegate,UMSocialUIDelegate>

@property(strong,nonatomic) UIScrollView * scrollerview;


@property(strong,nonatomic) NSArray * designerdeatildata;

@property(strong,nonatomic) NSString * desigerkefuID;//设计客服id

@end

@implementation MYHomeDesignerDeatilTableViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self requestdesignerdeatildata];
    
    UIScrollView *scrollerView =[[ UIScrollView alloc]init];
    scrollerView.frame =  CGRectMake(0, 0, MYScreenW ,MYScreenH );
    self.scrollerview = scrollerView;
    
    scrollerView.backgroundColor = [UIColor whiteColor];
    scrollerView.delegate = self;
    scrollerView.scrollEnabled = YES;
    
    scrollerView.showsHorizontalScrollIndicator = YES;
    scrollerView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollerView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    scrollerView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollerView];
    
    
    
    //    导航条
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self setupAddTopViewBar];
    //    添加下面的viewbar
    [self setupAddBoomView];
    
}


//代理传值高度
-(void)designerScrollViewHight:(double)scrollviewhight
{
    self.scrollerview.contentSize = CGSizeMake(1, scrollviewhight);
}

//请求数据
-(void)requestdesignerdeatildata
{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.id;
    [manager GET:[NSString stringWithFormat:@"%@designers/queryDesignersInfoById",kOuternet1] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.desigerkefuID = responseObject[@"csad_id"];
        
        designerdeatilModel * model = [designerdeatilModel objectWithKeyValues:responseObject[@"queryDesignersInfoById"]];
        
        self.designerdeatildata = model;
        
        NSString * desigerprice = (NSString *)responseObject[@"queryDesignersInfoById"][@"price"];
        self.price = [NSString stringWithFormat:@"%@",desigerprice];
        
        //        加载详情视图
        MYHomeDesignerDeatilView *sif = [[MYHomeDesignerDeatilView alloc]init];
        sif.ScrollViewhight = self;
        sif.designerdeatilmodel = model;
        
        [self.scrollerview addSubview:sif];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        
    }];
    
}



-(void)setupAddTopViewBar
{
    UIView *topview = [[UIView alloc]init];
    topview.frame = CGRectMake(0, 0, MYScreenW, 64);
    [self.view addSubview:topview];
    
    UIImageView *topbackimage = [[UIImageView alloc]initWithFrame:topview.frame];
    topbackimage.image = [UIImage imageNamed:@"topshadow.9"];
    [topview addSubview:topbackimage];
    
    
    UIButton *designerdeatilbackbtn = [[UIButton alloc]init];
    [designerdeatilbackbtn setImage:[UIImage imageNamed:@"back-1"] forState:UIControlStateNormal];
    designerdeatilbackbtn.frame = CGRectMake(15, 35, 10, 15);
    [designerdeatilbackbtn addTarget:self action:@selector(clickdesignerdeatilbackbtn) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:designerdeatilbackbtn];
    UIButton *btn = [[UIButton alloc]init];
    [topview addSubview:btn];
    btn.frame = CGRectMake(15, 20, 50, 50);
    [btn addTarget:self action:@selector(clickdesignerdeatilbackbtn) forControlEvents:UIControlEventTouchUpInside];
       
    UILabel *titlelable = [[UILabel alloc]initWithFrame:CGRectMake((MYScreenW - 100)/2, 30, 100, 30)];
    titlelable.text = @"";
    titlelable.textColor = [UIColor whiteColor];
    titlelable.font = [UIFont systemFontOfSize:14];
    [topview addSubview:titlelable];
    titlelable.textAlignment = NSTextAlignmentCenter;
    
}

-(void)setupAddBoomView
{
    UIView *BoomView = [[UIView alloc]initWithFrame:CGRectMake(0, MYScreenH - 40, MYScreenW, 40)];
    BoomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:BoomView];
    
    UIButton *adviceBtn = [[UIButton alloc]init];
    adviceBtn.frame = CGRectMake(0, 0, MYScreenW/2, 40);
    [adviceBtn setTitle:@"免费咨询" forState:UIControlStateNormal];
    adviceBtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:13.0];
    adviceBtn.backgroundColor = MYColor(238, 238, 238);
    [adviceBtn setTitleColor:MYColor(66, 66, 66) forState:UIControlStateNormal];
    [adviceBtn addTarget:self action:@selector(clickaddvicebtn) forControlEvents:UIControlEventTouchUpInside];
    [BoomView addSubview:adviceBtn];
    
    
    //   预约
    UIButton *appointmentBtn = [[UIButton alloc]init];
    appointmentBtn.frame = CGRectMake(MYScreenW/2 , 0, MYScreenW/2, 40);
    [appointmentBtn setTitle:@"我要预约" forState:UIControlStateNormal];
    appointmentBtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:13.0];
    appointmentBtn.backgroundColor = MYColor(193, 177, 122);
    [appointmentBtn setTitleColor:MYColor(247, 245, 237) forState:UIControlStateNormal];
    [appointmentBtn addTarget:self action:@selector(clickappointmentbtn) forControlEvents:UIControlEventTouchUpInside];
    [BoomView addSubview:appointmentBtn];
    
    
}

-(void)clickdesignerdeatilbackbtn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)clickappointmentbtn
{
  
    if (MYAppDelegate.isLogin) {
        
        MYHomeDesignerDeatilAppointmentViewController *oppointmentDesignerVC = [[MYHomeDesignerDeatilAppointmentViewController alloc]init];
        
        [self.navigationController pushViewController:oppointmentDesignerVC animated:YES];
        
        //    向下个控制器传递参数
        designerdeatilModel *desigermodel = self.designerdeatildata;
        oppointmentDesignerVC.desigerId = desigermodel.id;
        oppointmentDesignerVC.desigerPrice = self.price;
        oppointmentDesignerVC.name = desigermodel.name;
        oppointmentDesignerVC.desigerzhizi = desigermodel.qualification;
        oppointmentDesignerVC.originalPrice = desigermodel.originalPrice;
        oppointmentDesignerVC.VCtag = @"0";
    }else
    {
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc]init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
    
}


// 咨询客服
-(void)clickaddvicebtn
{
}
    




@end






