//
//  MYDiscoverMianController.m
//  魔颜
//
//  Created by abc on 16/5/5.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYDiscoverMianController.h"
#import "MYTitleMenuView.h"
#import "MYGongLueViewController.h"
#import "MYRandomChatViewController.h"
#import "MYPutQuestionViewController.h"

@interface MYDiscoverMianController ()<UIScrollViewDelegate>
@property(strong,nonatomic) MYTitleMenuView * titView;
@property(strong,nonatomic) UIScrollView * scrollView;
@property (nonatomic, assign) CGFloat scrollPoint;

@end

@implementation MYDiscoverMianController

-(void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
    
       self.navigationController.navigationBar.hidden = NO;
    
       self.navigationController.navigationBarHidden=NO;
        //设置导航栏的背景图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wenli"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTitleView];
    [self setupChildVC];
    
    
}
#pragma mark  添加titleview视图
-(void)setupTitleView
{
    NSArray *arr = @[@"攻略",@"随便聊聊",@"提问"];
    MYTitleMenuView *tv = [[MYTitleMenuView alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, 40) titleArr:arr type:@""];
    self.titView = tv;
    tv.titleBlock = ^(NSInteger index){
        self.scrollView.contentOffset = CGPointMake(index * MYScreenW, -64);
    };
    self.navigationItem.titleView = tv;
}

#pragma mark 添加滚动视图
-(void)setupChildVC
{

    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenH)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;

    scrollView.contentSize = CGSizeMake(MYScreenW * 3, 1);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self.scrollView setContentOffset:CGPointMake(MYScreenW * 2, 0) animated:YES];
    
    
    MYGongLueViewController *oneVC = [[MYGongLueViewController alloc]init];
    [self addChildViewController:oneVC];
    [scrollView addSubview:oneVC.view];
    
    MYRandomChatViewController *twoVC = [[MYRandomChatViewController alloc]init];
    twoVC.view.x = MYScreenW;
    [self addChildViewController:twoVC];
    [scrollView addSubview:twoVC.view];
    
    MYPutQuestionViewController *threeVC = [[MYPutQuestionViewController alloc]init];
    threeVC.view.x = MYScreenW * 2;
    [self addChildViewController:threeVC];
    [scrollView addSubview:threeVC.view];
    
}

#pragma mark 监听滚动事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.titView sliderMoveToOffsetX:scrollView.contentOffset.x];
}

@end
