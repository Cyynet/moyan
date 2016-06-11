//
//  WQMeTableViewController.m
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYMeTableViewController.h"
#import "MYBaseGroup.h"
#import "MYBaseItem.h"
#import "MYArrowItem.h"

#import "MYHeadView.h"
#import "MYLoginHeadView.h"
#import "NSString+File.h"

#import "MYInfoViewController.h"
#import "MYOrderViewController.h"
#import "MYAttentionViewController.h"
#import "MYCommentViewController.h"

#import "banquanmessageViewController.h"
#import "MYLoginViewController.h"
#import "MYOrderResultViewController.h"
#import "MYHeader.h"

#define deatiltextcolor  MYColor(109, 109, 109)

@interface MYMeTableViewController ()<MYHeadViewDelegate,MYLoginHeadViewDelegate>

@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UIView *loginHeadView;
@property (weak, nonatomic) UIButton *quitBtn;
@property (copy, nonatomic) NSString *iconName;

@end

@implementation MYMeTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;

    [self setupHeader];
    [self setupGroups];
    [MobClick beginLogPageView:@"个人中心"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    if (MYAppDelegate.isDefault) {
         MYAppDelegate.isDefault = NO;
        return;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
     }
    [MobClick endLogPageView:@"个人中心"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化模型数据
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 20, 0);

    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage resizableImage:@"bg_dropdown_left_selected"]];
    self.tableView.backgroundView = image;
}

- (void)setupHeader
{
    if (MYAppDelegate.isLogin) {
        
        MYLoginHeadView *loginHeadView = [[MYLoginHeadView alloc] init];
        loginHeadView.delegate = self;
        loginHeadView.backgroundColor = UIColorFromRGB(0x222222);
        self.loginHeadView = loginHeadView;
        loginHeadView.frame = CGRectMake(0, 0, MYScreenW, MYScreenH * 0.27);
        
        self.tableView.tableHeaderView = loginHeadView;
        loginHeadView.iconName = self.iconName;
        
        [self setupFooter];
        
    }else{
        
        MYHeadView *headView = [[MYHeadView alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenH * 0.27)];
        headView.delegate = self;
        headView.backgroundColor = UIColorFromRGB(0x222222);
        self.headView = headView;
        self.tableView.tableHeaderView = _headView;
    }
}

- (void)setupFooter
{
    
    if (! MYAppDelegate.isLogin) {
        return;
    }else{
        
        self.tableView.sectionFooterHeight = 70;
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 20, self.view.width, 40);
        self.tableView.tableFooterView = view;

        
        UIButton *quitBtn = [[UIButton alloc] init];
        quitBtn.backgroundColor = [UIColor lightGrayColor];
        quitBtn.frame =  CGRectMake((self.view.width - 250) / 2, 0, 250, 40);
        quitBtn.layer.masksToBounds = YES;
        quitBtn.layer.cornerRadius = 4;
        quitBtn.backgroundColor = deatiltextcolor;
        self.quitBtn = quitBtn;
        [quitBtn setTitle:@"退出当前帐户" forState:UIControlStateNormal];
        quitBtn.titleLabel.font = leftFont;
        [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [quitBtn addTarget:self action:@selector(quitLogin) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:quitBtn];
    }
}

/*
 @brief 退出当前账号
 */
- (void)quitLogin
{
    [UIAlertViewTool showAlertView:self title:nil message:@"确定退出魔颜" cancelTitle:@"取消" otherTitle:@"确认" cancelBlock:^{
        
    } confrimBlock:^{
        
        MYAppDelegate.isLogin = NO;
        [self setupHeader];
    
        [self contentInset];
        [self.tableView reloadData];
        [self.quitBtn setHidden:YES];
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [MYUserDefaults removePersistentDomainForName:appDomain];
     }];
    

    
}
- (void)setupGroups
{
    [self.groups removeAllObjects];
    [self setupGroup0];
    [self setupGroup1];
}

- (void)setupGroup0
{
    
    // 1.创建组
    MYBaseGroup *group = [MYBaseGroup group];
    [self.groups addObject:group];
    
    // 多态
    MYBaseItem *item0 = [MYArrowItem itemWithtitle:@"我的资料" destVC:[MYInfoViewController class]];
    MYBaseItem *item1 = [MYArrowItem itemWithtitle:@"我的消息" destVC:nil];
    MYBaseItem *item2 = [MYArrowItem itemWithtitle:@"我的订单" destVC:[MYOrderViewController class]];
    group.items = @[item0,item1,item2];
    
}

- (void)setupGroup1
{
    // 1.创建组
    MYBaseGroup *group = [MYBaseGroup group];
    [self.groups addObject:group];
    
    // 多态
    MYBaseItem *item1 = [MYArrowItem itemWithtitle:@"我的评论" destVC:[MYCommentViewController class]];
    MYBaseItem *item2 = [MYArrowItem itemWithtitle:@"我的关注" destVC:[MYAttentionViewController class]];
    MYBaseItem *item3 = [MYArrowItem itemWithtitle:@"关于我们" destVC:[banquanmessageViewController class]];
    MYBaseItem *item4 = [MYBaseItem itemWithtitle:@"清除缓存"];
    group.items = @[item1,item2,item3,item4];
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imageCachesPath = [cachesPath stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    NSString *NetImageCachesPath = [cachesPath stringByAppendingPathComponent:@"com.moyan.www.cn/fsCachedData"];
    long long fileSize = [imageCachesPath fileSize];
    long long NetFileSize = [NetImageCachesPath fileSize];//fsCachedData
    
    item4.subTitle = [NSString stringWithFormat:@"(%.2fM)",(fileSize + NetFileSize) / (1000.0 * 1000.0) ];
    [self.tableView reloadData];
    __weak typeof(item4) weakItem4 = item4;
    __weak typeof(self) weakVC = self;
    //点击清理缓存
    item4.optional = ^{
        
        //提示
        [MBProgressHUD showMessage:@"正在清理"];
        
        //清理
        NSFileManager *mgr = [[NSFileManager alloc] init];
        [mgr removeItemAtPath:imageCachesPath error:nil];
        [mgr removeItemAtPath:NetImageCachesPath error:nil];
        
        //隐藏
        [MBProgressHUD hideHUD];
        
        //改成（0.00K）
        weakItem4.subTitle = @"(0.00K)";
        
        //刷新
        [weakVC.tableView reloadData];
    };

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 18;
    }
    else
    {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }else{
        return 18;
    }
}

- (void)headView:(MYHeadView *)headView
{
    MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

- (void)loginHeadView:(MYLoginHeadView *)loginHeadView
{
    MYInfoViewController *infoVC = [[MYInfoViewController alloc] init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)contentInset
{
     [UIView animateWithDuration:0.2 animations:^{
         self.tableView.contentOffset = CGPointMake(0, 0);
     }];
}

@end
