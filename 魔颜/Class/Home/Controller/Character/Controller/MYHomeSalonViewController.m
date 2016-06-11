//
//  MYHomeSalonViewController.m
//  魔颜
//
//  Created by abc on 16/2/24.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYHomeSalonViewController.h"

#import "MYHomeCharacterTableViewController.h"

#import "MYTitleMenuView.h"

#import "MYLifeViewController.h"
#import "MYHeader.h"

@interface MYHomeSalonViewController ()<UIScrollViewDelegate>

@property(strong,nonatomic) MYHomeCharacterTableViewController *salonVC;
@property(strong,nonatomic) MYLifeViewController * activityVC;
@property (nonatomic,weak) MYTitleMenuView *menuView;
@property (nonatomic,weak) UIScrollView *scrollView;
@property(strong,nonatomic) UIButton * searchBtn;

@property(strong,nonatomic) UIButton * huodongBtn;
@property(strong,nonatomic) UIButton * salonBtn;

@end

@implementation MYHomeSalonViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"美容院总列表"];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"美容院总列表"];
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
    [womenBtn setTitle:@"项目"];
    [womenBtn addTarget:self action:@selector(clickWomenBtna:)];
    womenBtn.selected = YES;
    self.salonBtn = womenBtn;
    [navMenu addSubview:womenBtn];
    
    
    MYMenuBtn *manBtn = [[MYMenuBtn alloc] init];
    manBtn.frame = CGRectMake(74, 0, 75, 23);;
    [manBtn setTitle:@"美容院"];
    [manBtn addTarget:self action:@selector(clickManBtna:)];
    self.huodongBtn = manBtn;
    [navMenu addSubview:manBtn];
    
}

//选择美容院
- (void)clickManBtna:(UIButton *)manBtn
{
    manBtn.selected = YES;
    self.salonBtn.selected = NO;
    self.scrollView.contentOffset = CGPointMake(MYScreenW, -64);
}

//选择项目
- (void)clickWomenBtna:(UIButton *)womenBtn
{
    womenBtn.selected = YES;
    self.huodongBtn.selected = NO;
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
    
    MYLifeViewController *activityVC = [[MYLifeViewController alloc]init];
    activityVC.vctag = @"1";
    [self addChildViewController:activityVC];
    [scrollView addSubview:activityVC.view];
    
    MYHomeCharacterTableViewController *charaVC = [[MYHomeCharacterTableViewController alloc]init];
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
