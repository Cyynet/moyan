//
//  MYGoZhengXingAllViewController.m
//  魔颜
//
//  Created by abc on 16/4/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYGoZhengXingAllViewController.h"

#import "MYBeautyServiceController.h"

#import "MYIdeaViewController.h"
#import "MYHomeDoctorTableViewController.h"
#import "MYHomeHospitalTableViewController.h"
#import "MYZhengXingGongLueViewController.h"
#import "MYTitleMenuView.h"
#import "MYDiscountTableViewController.h"
#import "MYHeader.h"

@interface MYGoZhengXingAllViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) MYTitleMenuView *titView;
@property(strong,nonatomic) UIButton * rightBtn;

@end

@implementation MYGoZhengXingAllViewController


////在页面出现的时候就将黑线隐藏起来
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //设置导航栏的背景图片
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wenli"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//  
//
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: titlecolor, NSFontAttributeName : MYFont(17)};
//}
////在页面消失的时候就让navigationbar还原样式
//-(void)viewWillDisappear:(BOOL)animated{
//
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.title = @"去整形";
 
    //1.添加titleView
    [self setupTitleView];
    //2.添加滚动视图
    [self setupChildVC];
    //3.搜索框
    [self addSearch];
    
}

- (void)addSearch
{
    UIButton *rightBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 40, 30, 25, 25) image:@"itemRIght_search" highImage:@"itemRIght_search" backgroundColor:nil Target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
//小铃铛
-(void)search
{
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark  添加titleview视图
-(void)setupTitleView
{
    NSArray *arr = @[@"微整形",@"医院",@"医生",@"微整攻略"];
    MYTitleMenuView *tv = [[MYTitleMenuView alloc] initWithFrame:CGRectMake(0, 64, MYScreenW, 40) titleArr:arr type:@"gotozhengxing"];

    self.titView = tv;
    tv.titleBlock = ^(NSInteger index){
        self.scrollView.contentOffset = CGPointMake(index * MYScreenW, 0);
    };
    [self.view addSubview:tv];
    

    
}
#pragma mark 添加滚动视图
-(void)setupChildVC
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, MYScreenW, MYScreenH )];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.y = CGRectGetMaxY(self.titView.frame);
    scrollView.contentSize = CGSizeMake(MYScreenW * 4, 1);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    MYDiscountTableViewController *oneVC = [[MYDiscountTableViewController alloc]init];
    oneVC.VCtype = @"1";
    [self addChildViewController:oneVC];
    [scrollView addSubview:oneVC.view];

    
    MYHomeHospitalTableViewController *twoVC = [[MYHomeHospitalTableViewController alloc]init];
    twoVC.view.x = MYScreenW;
    [self addChildViewController:twoVC];
    [scrollView addSubview:twoVC.view];
    
    MYHomeDoctorTableViewController *threeVC = [[MYHomeDoctorTableViewController alloc]init];
    threeVC.view.x = MYScreenW * 2;
    [self addChildViewController:threeVC];
    [scrollView addSubview:threeVC.view];

    
    MYZhengXingGongLueViewController *fourVC = [[MYZhengXingGongLueViewController alloc]init];
    fourVC.view.x = MYScreenW * 3;
    [self addChildViewController:fourVC];
    [scrollView addSubview:fourVC.view];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 10, MYScreenW, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
//    [scrollView addSubview:line];

    
}
#pragma mark 监听滚动事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.titView sliderMoveToOffsetX:scrollView.contentOffset.x];
}
@end
