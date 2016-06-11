//
//  MYIntroduceViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/12.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYIntroduceViewController.h"
#import "MYMenuBtn.h"

#import "MYProjectViewController.h"
#import "MYReletedViewController.h"
#import "MYHeader.h"

@interface MYIntroduceViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIButton *progectBtn;
@property (weak, nonatomic) UIButton *reletedBtn;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIView *lineView;

@property (strong, nonatomic) MYProjectViewController *progectVC;
@property (strong, nonatomic) MYReletedViewController *reletedVC;

@end

@implementation MYIntroduceViewController

-(MYProjectViewController *)progectVC
{
    if (!_progectVC) {
        
        MYProjectViewController *progectVC = [[MYProjectViewController alloc]init];
        progectVC.id = self.id;
        progectVC.view.x = 0;
        progectVC.view.y = 0;
        self.progectVC = progectVC;
        // 将notiVC添加到messageVC
        [self addChildViewController:progectVC];
    }
    return _progectVC;
}

-(MYReletedViewController *)reletedVC
{
    if (!_reletedVC) {
        
        MYReletedViewController *reletedVC = [[MYReletedViewController alloc]init];
        reletedVC.view.x = self.view.width;
        reletedVC.view.y = 0;
        self.reletedVC = reletedVC;
        // 将notiVC添加到messageVC
        [self addChildViewController:reletedVC];

    }
    return _reletedVC;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.reletedVC.scrollRight) {
        self.scrollView.contentOffset = CGPointMake(self.view.width, 0);
    }
    [MobClick beginLogPageView:@"部位详情"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"部位详情"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupHeader];
    [self setupScrollLine];
    [self setupScrollView];
    
    self.title = self.name;
  
}

- (void)setupHeader
{
    MYMenuBtn *progectBtn = [[MYMenuBtn alloc] init];
    progectBtn.frame = CGRectMake(0, 64, self.view.width / 2, 35);
    [progectBtn setTitle:@"部位介绍"];
    progectBtn.titleLabel.font = MYFont(12);
    progectBtn.layer.borderWidth = 0;
    progectBtn.backgroundColor = [UIColor whiteColor];
    [progectBtn addTarget:self action:@selector(clickProgectBtn:)];
    self.progectBtn = progectBtn;
    [self.view addSubview:progectBtn];
    
    MYMenuBtn *reletedBtn = [[MYMenuBtn alloc] init];
    reletedBtn.frame = CGRectMake(self.view.width / 2, 64, self.view.width / 2, 35);
    reletedBtn.layer.borderWidth = 0;
    reletedBtn.titleLabel.font = MYFont(12);
    [reletedBtn setTitle:@"相关帖子"];
    [reletedBtn addTarget:self action:@selector(clickReletedBtn:)];
//    reletedBtn.selected = YES;
    self.reletedBtn = reletedBtn;
    [self.view addSubview:reletedBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(reletedBtn.frame), self.view.width, 0.5)];
    lineView.backgroundColor = lineViewBackgroundColor;
    [self.view addSubview:lineView];
    
}

- (void)clickProgectBtn:(UIButton *)progectBtn
{
    progectBtn.selected = YES;
    self.progectBtn.selected = NO;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.lineView.x = MYMargin * 3;
    }];
}

- (void)clickReletedBtn:(UIButton *)reletedBtn
{
    reletedBtn.selected = YES;
    self.reletedBtn.selected = NO;
    self.scrollView.contentOffset = CGPointMake(self.view.width, 0);
    
    [UIView animateWithDuration:0.2 animations:^{
    
    self.lineView.x = self.view.width / 2  + 3 * MYMargin;
    }];
}

- (void)setupScrollLine
{
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(3 * MYMargin, 98, self.view.width / 2 -  6 * MYMargin , 2);
    lineView.backgroundColor = UIColorFromRGB(0xb29e59);
    self.lineView = lineView;
    [self.view addSubview:lineView];
}

-(void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 105, self.view.width, self.view.height)];
    scrollView.delegate = self;
    
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    // 分页属性
    scrollView.pagingEnabled = YES;
    
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    [scrollView addSubview:self.progectVC.view];
    [scrollView addSubview:self.reletedVC.view];
}

@end
