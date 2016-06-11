//
//  MYDiscountFuWuJieSaoViewController.m
//  魔颜
//
//  Created by admin on 15/11/29.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYDiscountFuWuJieSaoViewController.h"
#import "MYHeader.h"

@interface MYDiscountFuWuJieSaoViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollerview;
@end

@implementation MYDiscountFuWuJieSaoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    [MobClick beginLogPageView:@"特惠服务介绍"];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.backgroundColor = [UIColor clearColor];
}
-(void)viewWillDisappear:(BOOL)animated
{[super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [MobClick endLogPageView:@"特惠服务介绍"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务介绍";
    self.tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollerview = [[UIScrollView alloc]init];
    scrollerview.frame = CGRectMake(0, 0, MYScreenW, MYScreenH);
    [self.view addSubview:scrollerview];
    scrollerview.contentSize = CGSizeMake(1, MYScreenH );
    self.scrollerview = scrollerview;
    scrollerview.delegate = self;
    
    
    UIImageView *backimageview = [[UIImageView alloc]init];
    backimageview.frame = CGRectMake(0, 0, MYScreenW, MYScreenH);
    [backimageview sd_setImageWithURL:[NSURL URLWithString:@"http://121.43.229.113:8081/shaping/pic/service/tehui.jpg"]];
    [scrollerview addSubview:backimageview];
    
    //    添加手势
    UISwipeGestureRecognizer *shoushi = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tianjiashoushi)];
    shoushi.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:shoushi];
}

//  手势方法
-(void)tianjiashoushi
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//返回
-(void)clickbackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
