//
//  MYNewViewController.m
//  魔颜
//
//  Created by Meiyue on 15/11/30.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYNewViewController.h"
#import "MYTabBarController.h"
#import "sys/utsname.h" 
#import "MYHeader.h"

#define kImageMaxCount 4
@interface MYNewViewController ()<UIScrollViewDelegate>

@property(weak, nonatomic) UIPageControl *pageControl;
@property(strong,nonatomic) NSString * devCode;//手机型号
@property(strong,nonatomic) NSString * devType;//

@end

@implementation MYNewViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //第一次启动应用 需要传参数
    [self firstQiDongApp];
    
    [self setupScrollView];
    [self setupPageControl];
}

-(void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    
    for (int i = 0; i < kImageMaxCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:scrollView.frame];
        imageView.userInteractionEnabled = YES;
        imageView.x = i * scrollView.width;
        
        NSString *name = [NSString stringWithFormat:@"page%d",i +1];
        
        imageView.image = [UIImage imageWithName:name];
        
        if (i == kImageMaxCount - 1) {
            
             [self setupStartBtn:imageView];
        }
        
        [scrollView addSubview:imageView];
    }
    
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(kImageMaxCount * self.view.width, 0);
    
    [self.view addSubview:scrollView];
    
    
}

-(void)setupPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.centerX = self.view.width * 0.5;
    pageControl.y = self.view.height - 30;
    pageControl.numberOfPages = kImageMaxCount;
    pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x666666);
    pageControl.pageIndicatorTintColor = UIColorFromRGB(0xcccccc);
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

-(void)setupStartBtn:(UIImageView *)imageView
{
    UIButton *startBtn = [[UIButton alloc]init];
    startBtn.size = CGSizeMake(180, 40);
    startBtn.centerX = self.view.width * 0.5;
    startBtn.centerY = self.view.height * 0.90;
    [startBtn setBackgroundImage:[UIImage imageNamed:@"icon_jr"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(clickStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
  
}

-(void)clickStartBtn:(UIButton *)startBtn
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIApplication sharedApplication].statusBarHidden = NO;
    window.rootViewController = [[MYTabBarController alloc]init];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.width + 0.5;
}

// 第一次启动应用 需要传参数
-(void)firstQiDongApp
{
    AFHTTPRequestOperationManager *maager = [[AFHTTPRequestOperationManager alloc]init];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"devCode"] = [MYStringFilterTool getUDID];
    param[@"devType"] = [MYStringFilterTool getDeviceType];
    param[@"channel"] = @"0";
    
    [maager GET:[NSString stringWithFormat:@"%@/kefu/preUser",kOuternet1] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *devCode = responseObject[@"devCode"];
        [MYUserDefaults setObject:devCode forKey:@"devCode"];
        [MYUserDefaults synchronize];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
