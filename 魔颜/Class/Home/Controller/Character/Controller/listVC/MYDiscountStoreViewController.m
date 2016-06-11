//
//  MYDiscountStoreViewController.m
//  魔颜
//
//  Created by Meiyue on 16/2/19.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYDiscountStoreViewController.h"
#import "MYDiscountTableViewController.h"
#import "MYLifeViewController.h"
#import "MYDiaryMallCollectionViewController.h"
#import "MYTitleMenuView.h"
#import "MYSearchViewController.h"
#import "MobClick.h"

@interface MYDiscountStoreViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) MYTitleMenuView *titView;

@property(strong,nonatomic) UIButton * rightBtn;

@end

@implementation MYDiscountStoreViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"卖场"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"卖场"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"卖场";
    //1.添加titleView
    [self setupTitleView];
    //2.添加滚动视图
    [self setupChildVC];
    //
    [self addbell];
    
}

#pragma mark  添加titleview视图
-(void)setupTitleView
{
    NSArray *arr = @[@"医疗美容",@"生活美容",@"日常护肤"];
    MYTitleMenuView *tv = [[MYTitleMenuView alloc] initWithFrame:CGRectMake(0, 64, MYScreenW, 40) titleArr:arr type:@"gotomeirong"];
    self.titView = tv;
    tv.titleBlock = ^(NSInteger index){
        self.scrollView.contentOffset = CGPointMake(index * MYScreenW, 0);
    };
    [self.view addSubview:tv];
}
#pragma mark 添加滚动视图
-(void)setupChildVC
{
    CGRect rect;
    // scrollView
    if ([self.TAG isEqualToString:@"1"]) {
        rect = CGRectMake(0, 0, MYScreenW, MYScreenH);
    } else {
        rect = CGRectMake(0, 0, MYScreenW, MYScreenH-64);
    }
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.titView.bottom, MYScreenW, MYScreenH-64)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(MYScreenW * 3, 1);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollPoint, 0) animated:YES];

    
    MYDiscountTableViewController *oneVC = [[MYDiscountTableViewController alloc]init];
    if ([self.TAG isEqualToString:@"1"]) {
        oneVC.tagVC = @"TAG";
    }
    [self addChildViewController:oneVC];
    [scrollView addSubview:oneVC.view];
    
    MYLifeViewController *twoVC = [[MYLifeViewController alloc]init];
    if ([self.TAG isEqualToString:@"1"]) {
        twoVC.vctag = @"TAG";
    }
    twoVC.view.x = MYScreenW;
    [self addChildViewController:twoVC];
    [scrollView addSubview:twoVC.view];
    
    MYDiaryMallCollectionViewController *threeVC = [[MYDiaryMallCollectionViewController alloc]init];
    if ([self.TAG isEqualToString:@"1"]) {
        threeVC.TAGVC = @"TAG";
    }else{
        threeVC.TAGVC = @"3";}
    threeVC.view.x = MYScreenW * 2;
    [self addChildViewController:threeVC];
    [scrollView addSubview:threeVC.view];
    
}
#pragma mark 监听滚动事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.titView sliderMoveToOffsetX:scrollView.contentOffset.x];
}

-(void)addbell
{
    UIButton *rightBtn = [[UIButton alloc]init];
    self.rightBtn =rightBtn;
    rightBtn.frame = CGRectMake(MYScreenW - 40, 30, 25, 25);
    [rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:rightBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}
//小铃铛
-(void)clickBell
{
    
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}



@end
