//
//  WQTabBarController.m
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYTabBarController.h"
#import "MYHomeViewController.h"
#import "MYMeTableViewController.h"
#import "MYNavigateViewController.h"

#import "MYTiyanFirstViewController.h"
#import "MYDiscoverMianController.h"
#import "MYTabBar.h"

#import "MYAskQuestionViewController.h"
#import "MYRandomChatPublicViewController.h"
#import "MYHeader.h"
#import "pushView.h"
#import "MYWeather.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYLoginViewController.h"

// iOS7
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)
// iOS9
#define iOS9 ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0)
@interface MYTabBarController ()<UITabBarControllerDelegate>

/** 弹出视图 */
@property (strong, nonatomic) pushView *myview;
/** 分享图片 */
@property (copy, nonatomic) NSString *sharePic;

/** tabBar */
@property (strong, nonatomic)  MYTabBar *tabBar;

@end

@implementation MYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MYHomeViewController *home = [[MYHomeViewController alloc]init];
    [self addChildVC:home title:@"首页" imageName:@"tabbar_icon_home_Normal" selIamgeName:@"tabbar_icon_home_Highlight"];
    
    MYDiscoverMianController *traformation = [[MYDiscoverMianController alloc]init];
    [self addChildVC:traformation title:@"发现" imageName:@"tabbar_icon_mojing_Normal" selIamgeName:@"tabbar_icon_mojing_Highlight"];
    
    MYTiyanFirstViewController *discount = [[MYTiyanFirstViewController alloc]init];
    //    discount.scrollPoint = MYScreenW;
    [self addChildVC:discount title:@"体验" imageName:@"tabbar_icon_Sale_Normal" selIamgeName:@"tabbar_icon_Sale_Highlight"];
    
    MYMeTableViewController *profile = [[MYMeTableViewController alloc]init];
    [self addChildVC:profile title:@"我的" imageName:@"tabbar_icon_me_Normal" selIamgeName:@"tabbar_icon_me_Highlight"];
    
    
    //处理tabBar
    [self setupTabBar];
    
    //    //设置item属性
    [self setItems];
    
    //请求天气接口
    [self requestWeather];
    
}
/**
 *  设置item文字属性
 */
- (void)setItems
{
    //设置文字属性
    NSMutableDictionary *attrsNomal = [NSMutableDictionary dictionary];
    //文字颜色
    attrsNomal[NSForegroundColorAttributeName] = UIColorFromRGB(0x4c4c4c);
    //文字大小
    attrsNomal[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    NSMutableDictionary *attrsSelected = [NSMutableDictionary dictionary];
    //文字颜色
    attrsSelected[NSForegroundColorAttributeName] = MYRedColor;
    
    //统一整体设置
    UITabBarItem *item = [UITabBarItem appearance]; //拿到底部的tabBarItem
    [item setTitleTextAttributes:attrsNomal forState:UIControlStateNormal];
    [item setTitleTextAttributes:attrsSelected forState:UIControlStateSelected];
}

/**
 *  处理tabBar
 */
- (void)setupTabBar
{
    pushView *myview=[[pushView alloc] init];
    self.myview = myview;
    myview.pushBlock = ^(NSInteger tag,NSString *urlStr){
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        MYTabBarController *tabVC = (MYTabBarController *)window.rootViewController;
        MYNavigateViewController *pushClassStance = (MYNavigateViewController *)tabVC.viewControllers[tabVC.selectedIndex];
        
        if (tag == 0) {
            
            MYRandomChatPublicViewController *instance = [[MYRandomChatPublicViewController alloc] init];
            [pushClassStance pushViewController:instance animated:YES];
            
        }else if (tag == 1){
            
            MYAskQuestionViewController *instance = [[MYAskQuestionViewController alloc] init];
            
            [pushClassStance pushViewController:instance animated:YES];
        }else{
            
            MYHomeHospitalDeatilViewController  *instance = [[MYHomeHospitalDeatilViewController alloc] init];
            instance.tag = 2;
            instance.url = urlStr;
            instance.imageName = self.sharePic;
            [pushClassStance pushViewController:instance animated:YES];
            
        }
    };
    
    //用kvc的方式将系统的tabbar换成我们自定义的
    MYTabBar *tabBar = [[MYTabBar alloc] init];
    self.tabBar = tabBar;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    tabBar.publicBlock = ^(){
        
        [self.view addSubview:myview];
        [myview pushButton];
        
    };
    
    
}
-(void)addChildVC:(UIViewController *)VC title:(NSString *)title imageName:(NSString *)imageName selIamgeName:(NSString *)selImageName
{
    //    VC.view.backgroundColor = [UIColor whiteColor];
    VC.title = title;
    [VC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MYRedColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    // ios7之后系统会自动渲染图片，对tabBarItem的selected图片进行处理
    UIImage *selImage = [UIImage imageNamed:selImageName];
    
    // 不让系统处理图片变蓝
    
    if (iOS7) {
        
        selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    [VC.tabBarItem setImage:[UIImage imageWithName:imageName]];
    [VC.tabBarItem setSelectedImage:selImage];
    
    MYNavigateViewController *nav = [[MYNavigateViewController alloc]initWithRootViewController:VC];
    
    // 添加到tabBarController
    [self addChildViewController:nav];
}

- (void)requestWeather
{
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@homePage/weather",kOuternet1] params:nil success:^(id responseObject) {
        
        MYWeather *weatherModel = [MYWeather objectWithKeyValues:responseObject];
        if ([weatherModel.status isEqualToString:@"success"]) {
            
            self.sharePic = weatherModel.ad[0].bannerPath;
            
            if (iOS9) {
                self.myview.weatherModel = weatherModel;
            }else{
                self.tabBar.weatherModel = weatherModel;
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}


@end
