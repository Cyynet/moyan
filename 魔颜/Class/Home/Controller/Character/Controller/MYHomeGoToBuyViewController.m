//
//  MYHomeGoToBuyViewController.m
//  魔颜
//
//  Created by abc on 16/4/18.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYHomeGoToBuyViewController.h"
#import "MYTitleMenuView.h"
#import "MYHomeHospitalTableViewController.h"
#import "MYDiscountTableViewController.h"
#import "MYHeader.h"


@interface MYHomeGoToBuyViewController ()<UIScrollViewDelegate>

@property(strong,nonatomic) UIButton * searchBtn;
@property (nonatomic,weak) MYTitleMenuView *menuView;
@property (nonatomic,weak) UIScrollView *scrollView;
@property(strong,nonatomic) UIButton * tehuiBtn;
@property(strong,nonatomic) UIButton * hospitalBtn;
@end

@implementation MYHomeGoToBuyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"去整形"];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"去整形"];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    //    添加MenuView
    [self setupHeadMenu];
    
    [self addScrollView];
    
    self.title = @"美容院";
    
    [self addbell];
    
}
//上面切换按钮
- (void)setupHeadMenu
{
    UIView *navMenu = [[UIView alloc] init];
    navMenu.frame = CGRectMake(self.view.width - 170, 10, 145, 23);
    self.navigationItem.titleView = navMenu;
    navMenu.layer.masksToBounds = YES;
    navMenu.layer.cornerRadius = 12;
    navMenu.layer.borderWidth = 1;
    navMenu.layer.borderColor = UIColorFromRGB(0xb5a653).CGColor;
    
    
    MYMenuBtn *womenBtn = [[MYMenuBtn alloc] init];
    womenBtn.frame = CGRectMake(0, 0, 75, 23);
    [womenBtn setTitle:@"特惠"];
    [womenBtn addTarget:self action:@selector(clickWomenBtn1:)];
    womenBtn.selected = YES;
    self.tehuiBtn = womenBtn;
    [navMenu addSubview:womenBtn];
    
    
    MYMenuBtn *manBtn = [[MYMenuBtn alloc] init];
    manBtn.frame = CGRectMake(74, 0, 75, 23);;
    [manBtn setTitle:@"医院"];
    [manBtn addTarget:self action:@selector(clickManBtn1:)];
    self.hospitalBtn = manBtn;
    [navMenu addSubview:manBtn];
    
}

//选择医院
- (void)clickManBtn1:(UIButton *)manBtn
{
    manBtn.selected = YES;
    self.tehuiBtn.selected = NO;
    self.scrollView.contentOffset = CGPointMake(MYScreenW, -64);
}

//选择特惠
- (void)clickWomenBtn1:(UIButton *)womenBtn
{
    womenBtn.selected = YES;
    self.hospitalBtn.selected = NO;
    [self.menuView sliderMoveToOffsetX:0];
    self.scrollView.contentOffset = CGPointMake(0, -64);
}

-(void)addScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenH)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.y = CGRectGetMaxY(self.menuView.frame);
    scrollView.contentSize = CGSizeMake(MYScreenW *2 , 1);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    MYDiscountTableViewController *activityVC = [[MYDiscountTableViewController alloc]init];
    activityVC.tagVC = @"1";
    [self addChildViewController:activityVC];
    [scrollView addSubview:activityVC.view];
    
    MYHomeHospitalTableViewController *charaVC = [[MYHomeHospitalTableViewController alloc]init];
    charaVC.view.x = MYScreenW;
    [self addChildViewController:charaVC];
    [scrollView addSubview:charaVC.view];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.menuView sliderMoveToOffsetX:scrollView.contentOffset.x];
}
-(void)addbell
{
    UIButton *rightBtn = [[UIButton alloc]init];
    self.searchBtn =rightBtn;
    rightBtn.frame = CGRectMake(MYScreenW - 40, 30, 25, 25);
    [rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

//小铃铛
-(void)clickBell
{
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
@end
