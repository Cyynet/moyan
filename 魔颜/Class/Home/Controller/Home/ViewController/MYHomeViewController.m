//
//  MYHomeViewController.m
//  魔颜
//
//  Created by Meiyue on 16/4/9.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYHomeViewController.h"
#import "MYqianggouview.h"
#import "NSString+Extension.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYHomeCharacterTableViewController.h"
#import "MYLoginViewController.h"

#import "MYDiscountStoreViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MYqianggoumodel.h"
#import "MYTagTool.h"
#import "UIAlertViewTool.h"
#import "MYBeautyViewController.h"
#import "LOLScanViewController.h"
#import "MYHomeGoToBuyViewController.h"
#import "MYDiaryMallCollectionViewController.h"
#import "MYLifeSecondViewController.h"
#import "MYHomeNewFormMoreBtnCollectionViewController.h"
#import "MYGoZhengXingAllViewController.h"
#import "MYQuickWriteToOrderForServiceViewController.h"

#import "HWPopTool.h"
#import "MYContentView.h"
#import "MYHomeDiscountListTableViewController.h"

#import "MYHeader.h"
#import "MYTiYanListModle.h"
#import "MYTiYanListCell.h"
@class Banners;
@interface MYHomeViewController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,copy)  NSString *currentCityName;
/** <#注释#> */
@property (strong, nonatomic) MYHomeMenuView *menuView;
/** 悬浮框 */
@property (strong, nonatomic) MYFloatBar *floatBar;

/** 悬浮框 */
@property (strong, nonatomic) MYFloatBar *bar;

/** 整个组头 */
@property(strong,nonatomic)  UIView *headView;
/** tablView */
@property (strong, nonatomic) UITableView *tableView;

@property(strong,nonatomic) NSMutableArray * imageArr;
@property (strong, nonatomic) NSMutableArray *urls;
@property(strong,nonatomic) NSArray * adTitles;
@property(strong,nonatomic) AdView * adview;
@property(strong,nonatomic) UIView * viewbar;
@property(strong,nonatomic) UIView * statubar;
@property(strong,nonatomic) MYqianggouview * qianggouview;
@property(strong,nonatomic) UIView  * line0;
@property(strong,nonatomic) UIImageView * moyanimage;
@property(strong,nonatomic) UIView *xiaoxibackview;
@property(strong,nonatomic) NSMutableArray * qianggouUrltitle;

@property(strong,nonatomic) NSString * kefuid;
@property(strong,nonatomic) NSArray * qianggouImageUrl;
@property(strong,nonatomic) NSArray * qianggoutitle;
//@property(strong,nonatomic) NSArray * qianggouimageUrlarr;


/** 各种专场数组数据 */
/** 广告栏图片数组 */
@property (strong, nonatomic) NSArray *adImages;
/** 美容 */
@property (strong, nonatomic) NSArray *salonArr;
/** 医美 */
@property (strong, nonatomic) NSArray *hospitalArr;
/** 美购 */
@property (strong, nonatomic) NSArray *ownArr;
/** 日记 */
@property (strong, nonatomic) NSArray *noteArr;
/** 解决方案 */
@property (strong, nonatomic) NSArray *diaryArr;
//消息
@property(strong,nonatomic) NSArray * headline;
//抢购
@property(strong,nonatomic) NSArray * expand;

@property (copy, nonatomic) NSString *selecedBeautyTitle;
@property (copy, nonatomic) NSString *selecedHospitalTitle;
@property (copy, nonatomic) NSString *selecedOwnTitle;

@property(assign,nonatomic) BOOL qianggouBOOL;


@property(assign,nonatomic) NSInteger mold0;
@property(assign,nonatomic) NSInteger mold1;
@property(assign,nonatomic) NSInteger mold2;

@end

@implementation MYHomeViewController

- (NSMutableArray *)imageArr
{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (NSMutableArray *)urls
{
    if (_urls == nil) {
        _urls = [NSMutableArray array];
    }
    return _urls;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"clear"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage=[UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //关闭定位
    [_locationManager stopUpdatingLocation];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
 }

 //1.1 创建定位管理者
-(CLLocationManager *)locationManager
{
    if(!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
//        [_locationManager requestAlwaysAuthorization]; // 永久授权
        [_locationManager requestWhenInUseAuthorization]; //使用中授权
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.qianggouBOOL = YES;

    /** 创建整个tableView */
    [self setupTableView];
    
    /** 请求所有数据数据 */
    [self setupRefresh];
 
    /** 创建能悬浮的搜索框 */
    [self setupFloatBar];
    
    /** 定位 */
    [self addLocationFunction];
       
    [MYNotificationCenter addObserver:self selector:@selector(qianggouVIEWnoti:) name:@"qianggouVIEW" object:nil];
    [MYNotificationCenter addObserver:self selector:@selector(clickItem:) name:@"MYItem" object:nil];
    [MYNotificationCenter addObserver:self selector:@selector(clickAd:) name:@"MYAdView" object:nil];


}

- (void)clickAd:(NSNotification*)noti
{
    NSInteger tag = [noti.userInfo[@"MYAdTag"] integerValue];
    MYHomeHospitalDeatilViewController  *vc= [[MYHomeHospitalDeatilViewController alloc]init];
    MYAdModel *adModel = self.adImages[tag];
    vc.url = adModel.url;
    vc.imageName = [NSString stringWithFormat:@"%@%@",kOuternet1,adModel.bannerPath];
    vc.tag = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)setupRefresh
{
    // header - 下拉
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHomeData)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header beginRefreshing];
    });
}
#pragma mark-抢购页面的跳转 通知
-(void)qianggouVIEWnoti:(NSNotification*)noti
{
    NSString *tag = noti.userInfo[@"tag"];
    
    MYHomeHospitalDeatilViewController* viewController = [[MYHomeHospitalDeatilViewController alloc] init];
    
    viewController.url = self.qianggouUrltitle[[tag intValue]];
    viewController.tag = 2;
    viewController.titleName = self.qianggoutitle[[tag intValue]];
    viewController.imageName = self.qianggouImageUrl[[tag intValue]];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

#pragma mark---------- 点击item跳转 ----------
- (void)clickItem:(NSNotification*)noti
{
    
    NSInteger tag = [noti.userInfo[@"MYTag"] integerValue];
    NSInteger btnTag = [noti.userInfo[@"MYBtnTag"] integerValue];
    NSInteger id = [noti.userInfo[@"MYID"] integerValue];

    
    MYHomeHospitalDeatilViewController *hospitonVC  =[[MYHomeHospitalDeatilViewController alloc]init];
    if (tag == 0) {
        MYSalonSpe *item = self.salonArr[btnTag];
        hospitonVC.titleName = item.title;
        hospitonVC.imageName = [NSString stringWithFormat:@"%@%@",kOuternet1,item.listPic];

    }else if (tag == 1){
        MYHosSpe *item = self.hospitalArr[btnTag];
        hospitonVC.titleName = item.title;
        hospitonVC.imageName = [NSString stringWithFormat:@"%@%@",kOuternet1,item.smallPic];

    }else if (tag == 2){
        MYOwnSpe *item = self.ownArr[btnTag];
        hospitonVC.titleName = item.title;
        hospitonVC.imageName = [NSString stringWithFormat:@"%@%@",kOuternet1,item.smallPic];

    }

    if (tag) {
        hospitonVC.tag = 1;
    }else{
        hospitonVC.tag = 6;
    }
    hospitonVC.character = @"";
    hospitonVC.id = [NSString stringWithFormat:@"%ld",(long)id];
    [self.navigationController pushViewController: hospitonVC animated:YES];
    

}

- (void)setupTableView
{
    self.tableView = [UITableView initWithGroupTableView:CGRectMake(0, 0, MYScreenW, self.view.height-50) withDelegate:self];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    /** 整个列表组头 */
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,MYScreenW, MYScreenH*0.685+110-5)];
    self.headView = headView;
    headView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.tableView.tableHeaderView = headView;

//    状态栏背景
    UIView *statubar =[[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 20)];
    [self.view addSubview:statubar];
    statubar.backgroundColor = [UIColor whiteColor];
    self.statubar = statubar;
    self.statubar.hidden = YES;
    [self addTableHeadView];
//   [self moyanxiaoxiBigView];

}

#pragma mark - 请求所有数据
- (void)loadHomeData
{

    self.imageArr =nil;
    self.urls = nil;
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/banner/queryBanner",kOuternet1] params:nil success:^(id responseObject) {
        
        for (NSDictionary *dict in responseObject[@"banners"]) {
            
            [self.imageArr addObject:[NSString stringWithFormat:@"%@%@",kOuternet1,dict[@"bannerPath2"]]];
            
            [self.urls addObject:dict[@"url"]];
            
        }
        /** 整个列表组头 */
        [self addbananer];
//        //刷新section
//        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSError *error) {
    }];

    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/homePage/querySalonSpeInfo",kOuternet1] params:nil success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
        MYGlobalGCD((^{
            /**
             *  插入的广告
             */
            NSArray *adArr = [MYAdModel objectArrayWithKeyValuesArray:responseObject[@"ad"]];
            self.adImages = adArr;
            
            /**
             *  美容专场
             */
            NSArray *salonArr = [MYSalonSpe objectArrayWithKeyValuesArray:responseObject[@"salonSpe"]];
            self.salonArr = salonArr;
            
            /**
             *  医美专场
             */
            NSArray *hospitalArr = [MYHosSpe objectArrayWithKeyValuesArray:responseObject[@"hosSpe"]];
            self.hospitalArr = hospitalArr;
            
            /**
             *  美购专场
             */
            NSArray *ownArr = [MYOwnSpe objectArrayWithKeyValuesArray:responseObject[@"ownSpe"]];
            self.ownArr = ownArr;
            
            /**
             *  体验日记
             */
            NSArray *noteArr = [MYDiary objectArrayWithKeyValuesArray:responseObject[@"experience"]];
            self.noteArr = noteArr;
            
            /**
             *  体验解决方案
             */
             NSArray *diaryArr = [MYDiary objectArrayWithKeyValuesArray:responseObject[@"diary"]];
             self.diaryArr = diaryArr;
            
            
            self.headline = responseObject[@"headline"] ;
            self.expand = responseObject[@"expand"];
            
            MYMainGCD(^{
                if(!self.expand.count)
                {
                    self.qianggouBOOL = NO;
                    [self.tableView sizeToFit];
                    self.headView.height = MYScreenH*0.685+110-5 - MYScreenH*0.27;
                    [self.tableView setTableHeaderView:self.headView];
                }
                [self moyanxiaoxiBigView];
                [self.tableView reloadData];

            });

        }));
            
        [self.tableView.header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
    
}
#pragma mark - 轮播图
-(void)addbananer
{
    AdView *adview = [AdView adScrollViewWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenW *0.453) imageLinkURL:self.imageArr placeHoderImageName:nil pageControlShowStyle:UIPageControlShowStyleCenter];
    self.adview = adview;
    //图片被点击后回调的方法
    adview.callBack = ^(NSInteger index,NSString * imageURL)
    {
        MYHomeHospitalDeatilViewController  *vc= [[MYHomeHospitalDeatilViewController alloc]init];
        vc.tag = 2;
        vc.imageName = imageURL;
        vc.url = [self.urls objectAtIndex:index];
        [self.navigationController pushViewController:vc animated:YES];

    };
    [self.headView addSubview:adview];
}

#pragma mark - 抢购页面 + 消息
-(void)moyanxiaoxi
{
    if (self.expand.count) {
        NSMutableArray *imagetitle = [NSMutableArray array];
        NSMutableArray *qianggouUrltitle = [NSMutableArray array];
        NSMutableArray *typearr = [NSMutableArray array];
        NSMutableArray *qianggoutitle = [NSMutableArray array];

        for (NSDictionary *dict in self.expand) {
            
            [imagetitle addObject:dict[@"bannerPath"]];
            [qianggouUrltitle addObject:dict[@"url"]];
            [qianggoutitle addObject:dict[@"title"]];

        }
        self.qianggouUrltitle = qianggouUrltitle;
        self.qianggouImageUrl = imagetitle;
        self.qianggoutitle = qianggoutitle;
        NSArray *imagearr = imagetitle;
        
        MYqianggouview* qianggouview = [[MYqianggouview alloc]initWithFrame:CGRectMake(0, self.menuView.bottom+10, MYScreenW, MYScreenH*0.27) imagearr:imagearr imagcount:self.expand.count urlarr:qianggouUrltitle type:typearr];
        self.qianggouview = qianggouview;
        qianggouview.model = self.expand;
        if (self.qianggouBOOL) {
            [self.headView addSubview:qianggouview];
        }else
        {
            
        }
    }
    
    NSMutableArray *titlesArr = [NSMutableArray array];
    NSMutableArray *urlArr = [NSMutableArray array];
    NSMutableArray *imageUrl = [NSMutableArray array];
    
    if (self.headline) {
        
        for (NSDictionary *dict in self.headline) {
            [titlesArr addObject:dict[@"bannerPath"]];
            [urlArr addObject:dict[@"url"]];
//              [imageUrl addObject:dict[@"pic"]];
        }
        
        self.adTitles = titlesArr;
        VierticalScrollView *scroView = [VierticalScrollView initWithTitleArray:self.adTitles AndFrame:CGRectMake(self.line0.right+5, 0, MYScreenW-15-self.moyanimage.width, 40)];
        scroView.backgroundColor = [UIColor whiteColor];
        
        scroView.btnIndex = ^(NSInteger btnIndex){
            
            MYHomeHospitalDeatilViewController  *vc= [[MYHomeHospitalDeatilViewController alloc]init];
            vc.tag = 2;
//            vc.imageName = imageUrl[btnIndex-1];
            vc.titleName = titlesArr[btnIndex-1];
            vc.url = [urlArr objectAtIndex:btnIndex-1];
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        [self.xiaoxibackview addSubview:scroView];
    }
    

}

-(void)moyanxiaoxiBigView
{
    
#pragma mark - 魔颜消息
    UIView *xiaoxibackview = [[UIView alloc]init];
    xiaoxibackview.backgroundColor = [UIColor whiteColor];
    
    CGRect rect;
    if (!_qianggouBOOL) {
        
        rect = CGRectMake(0, self.menuView.bottom+10+1, MYScreenW, 40);
    }else
    {
        rect = CGRectMake(0, self.menuView.bottom+10+MYScreenH*0.27+1, MYScreenW, 40);
    }
    xiaoxibackview.frame = rect;
    self.xiaoxibackview = xiaoxibackview;
    [self.headView addSubview:xiaoxibackview];
    
    
    UIImageView *moyanimage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2.5,97, 35)];
    moyanimage.image = [UIImage imageNamed:@"moyanxiaoxi"];
    [xiaoxibackview addSubview:moyanimage];
    self.moyanimage = moyanimage;
    moyanimage.backgroundColor = [UIColor whiteColor];
    
    
    UIView *line0 = [[UIView alloc]init];
    line0.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [xiaoxibackview addSubview:line0];
    line0.frame = CGRectMake(moyanimage.right+5, 5, 0.5, 30);
    line0.alpha = 0.5;
    self.line0 = line0;
    
    [self moyanxiaoxi];

}

#pragma mark - 搜索栏
- (void)addTableHeadView
{
    MYFloatBar *floatBar = [[MYFloatBar alloc] initWithFrame:CGRectMake(0, MYScreenW *0.453, MYScreenW, 45)];
    self.bar = floatBar;
    __block MYFloatBar *weakSelf = floatBar;

    floatBar.floatBlock = ^(NSInteger tag){
        
        UIViewController *viewController;
        if (tag == 0) {//地区
            MYRegionViewController *regionVC = [[MYRegionViewController alloc] init];
            regionVC.myBlock = ^(NSString *city){
                [weakSelf.leftBtn setTitle:city forState:UIControlStateNormal];
                [self.bar.leftBtn setTitle:city forState:UIControlStateNormal];
                
            };
            regionVC.currentCity = self.currentCityName;
            viewController = regionVC;
            
        }
        else if (tag == 1){//搜索
            
            MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
            [self.navigationController pushViewController:searchVC animated:YES];
        
            
        }
        else if (tag == 2){//扫一扫
            
            if ([self validateCamera] && [self canUseCamera]) {
                LOLScanViewController *scanVC = [[LOLScanViewController alloc]init];
                [self.navigationController pushViewController:scanVC animated:YES];
                
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        
        else if (tag == 3){     //购物车
            
            [self gotoKeFu];

        }
        
        [self.navigationController pushViewController:viewController animated:YES];
    };
    [self.headView addSubview:floatBar];

    
#pragma mark - 三个按钮
    MYHomeMenuView *menuView = [[MYHomeMenuView alloc] initWithFrame:CGRectMake(0, floatBar.bottom + 10, MYScreenW, MYScreenH*0.16)];
    self.menuView = menuView;
    menuView.btnType = ^(NSInteger btnType){
        
        UIViewController *viewController;
        
        switch (btnType) {
                
            case 0:
                
                viewController = [[MYBeautyViewController alloc] init];
                
                break;
                
            case 1:
                viewController = [[MYGoZhengXingAllViewController alloc] init];
                break;
                
            case 2:
                viewController = [[MYDiaryMallCollectionViewController alloc] init];
    
                break;
        }
        
        [self.navigationController pushViewController:viewController animated:YES];

    };
    [self.headView addSubview:menuView];
    self.menuView = menuView;
    
    [self moyanxiaoxiBigView];
    
   
}

#pragma mark - 悬浮框
-(void)setupFloatBar
{
    MYFloatBar *floatBar = [[MYFloatBar alloc] initWithFrame:CGRectMake(0, 20, MYScreenW, 45)];
    self.floatBar = floatBar;
    floatBar.floatBlock = ^(NSInteger tag){
        
        UIViewController *viewController;
        if (tag == 0) {//地区
            MYRegionViewController *regionVC = [[MYRegionViewController alloc] init];
            regionVC.myBlock = ^(NSString *city){
//                MYLog(@"%@",city);
                [self.floatBar.leftBtn setTitle:city forState:UIControlStateNormal];
                [self.bar.leftBtn setTitle:city forState:UIControlStateNormal];
            };
            regionVC.currentCity = self.currentCityName;
            viewController = regionVC;
            
        }
        else if (tag == 1){//搜索
            
            MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
            [self.navigationController pushViewController:searchVC animated:YES];
            
            
        }
        else if (tag == 2){//扫一扫
            
            if ([self validateCamera] && [self canUseCamera]) {
                
                LOLScanViewController *scanVC = [[LOLScanViewController alloc]init];
                [self.navigationController pushViewController:scanVC animated:YES];
                
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alertView show];
            }
            
        }
        else if (tag == 3){     //购物车
            
            [self gotoKeFu];
            

        }
        
        [self.navigationController pushViewController:viewController animated:YES];
    };

    floatBar.hidden = YES;
    [self.view addSubview:floatBar];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section < 3) return 1;
    
    if (section == 3) {
        return self.noteArr.count;
    }else{
        return self.diaryArr.count;
    }
    
    
//    if (section == 3) {
//
//        return self.diaryArr.count;
//    }else{
//    
//        return 1;
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        MYHomeCell *cell = [MYHomeCell cellWithTableView:tableView indexPath:indexPath];
        cell.tag = indexPath.section;

        cell.items = self.salonArr;

        return cell;
    }
    
    else if (indexPath.section == 1){
        MYHomeCell *cell = [MYHomeCell cellWithTableView:tableView indexPath:indexPath];
        cell.tag = indexPath.section;
        cell.items = self.hospitalArr;
        return cell;
    }
    else if (indexPath.section == 2){
        MYHomeCell *cell = [MYHomeCell cellWithTableView:tableView indexPath:indexPath];
        cell.tag = indexPath.section;
        cell.items = self.ownArr;
        return cell;
    }
    else if (indexPath.section == 3){
        
        MYDiaryCell *cell = [MYDiaryCell cellWithTableView:tableView indexPath:indexPath];
        cell.tag = 1;
        MYDiary *mode= self.noteArr[indexPath.row];
        cell.diarymode = mode;
        return cell;

    }
    else{

        MYDiaryCell *cell = [MYDiaryCell cellWithTableView:tableView indexPath:indexPath];
        cell.tag = 0;
        MYDiary *mode= self.diaryArr[indexPath.row];
        cell.diarymode = mode;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.salonArr.count > 2) {
            return MYScreenH * 0.725;
        }else if (self.salonArr.count < 2){
//            [MBProgressHUD showHUDWithTitle:@"暂时没有数据" andImage:nil andTime:0.6];
            return 0;
        }else {
            return MYScreenH * 0.365;
        }

    }else if (indexPath.section == 1){
        
        if (self.hospitalArr.count > 2) {
            return MYScreenH * 0.725;
        }else if (self.hospitalArr.count < 2){
//            [MBProgressHUD showHUDWithTitle:@"暂时没有数据" andImage:nil andTime:0.6];
            return 0;
        }else {
            return MYScreenH * 0.365;
        }
    }else if (indexPath.section == 2){
        
        if (self.ownArr.count > 2) {
            return MYScreenH * 0.725;
        }else if (self.ownArr.count < 2){
//            [MBProgressHUD showHUDWithTitle:@"暂时没有数据" andImage:nil andTime:0.6];
            return 0;
        }else {
            return MYScreenH * 0.365;
        }
     }else  {
        
        UILabel *lable = [[UILabel alloc]init];
         
         if (indexPath.section == 3) {
             MYDiary *mode = self.noteArr[indexPath.row];
            lable.text = mode.project;
         }else{
             MYDiary *mode = self.diaryArr[indexPath.row];
             lable.text = mode.content;
        }
        CGFloat cellheight = [lable.text heightWithFont:MYFont(13) withinWidth:MYScreenW-20];
        if (cellheight>15) {
            return 262+20;
        }else{
            return 272;
        }
    }
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//   NSLog(@"%ld,%ld",indexPath.section,indexPath.row);
    
    if (indexPath.section == 3) {
        
        MYHomeHospitalDeatilViewController *detailVC = [[MYHomeHospitalDeatilViewController alloc] init];
        MYDiary *mode = self.noteArr[indexPath.row];
        detailVC.id = [NSString stringWithFormat:@"%ld",mode.id];
        detailVC.tag = 7;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else{
    
        MYDetailViewController *circleDeatilVC = [[MYDetailViewController alloc]init];
        MYDiary *model = self.diaryArr[indexPath.row];
        circleDeatilVC.topPic = model.homePagePic;
        circleDeatilVC.id = [NSString stringWithFormat:@"%ld",(long)model.id];
        [self.navigationController pushViewController:circleDeatilVC animated:YES];
    }
    
    
}
#pragma mark - 组头
// 当一个分组标题进入视野的时候就会调用该方法
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *imagearr = @[@"",@"",@"",@"tiyanriji",@"jiejuefangan"];
    if (section > 2) {
        
        UIView *headview3 = [[UIView alloc]init];
        
        UIImageView *heaherimageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[imagearr objectAtIndex:section]]];
        heaherimageview.frame = CGRectMake(0, kMargin, MYScreenW, 75);
        [headview3 addSubview:heaherimageview];
        heaherimageview.backgroundColor = [UIColor whiteColor];
        
        UIView *lien = [[UIView alloc]init];
        lien.frame = CGRectMake(0, heaherimageview.height-1, MYScreenW
                                , 0.5);
        [heaherimageview addSubview:lien];
        lien.backgroundColor = UIColorFromRGB(0xcccccc);
        
        return headview3;
        
    }else{
        
        MYAdModel *adModel;
        if (section < self.adImages.count) {
            
            adModel = self.adImages[section];
        }else{
            adModel = nil;
        }
        
        //创建自定义的头部视图
        MYHomeHeadSectionView *headerview=[MYHomeHeadSectionView headerWithTableView:tableView section:section adView:adModel];
        headerview.sectionBlock = ^(NSArray *tagArr,UIButton *btn){
            
            if (btn.tag) {
                if (section == 0) {
                    
                    self.selecedBeautyTitle = btn.titleLabel.text;
                }else if (section == 1){
                      self.selecedHospitalTitle = btn.titleLabel.text;
                }else{
                    self.selecedOwnTitle = btn.titleLabel.text;

                }
 //                MYLog(@"您点击了第%ld组,它的id是%ld",(long)section,(long)id);
                [self requestSectionData:(int)section AndID:btn.tag];
            }
            else{
                
                MYColumnViewController *vc = [[MYColumnViewController alloc] init];
                vc.myBlock = ^(NSArray *selecedArr){
                    
//                    MYLog(@"第%ld组的数据保存完成:%@",(long)section,selecedArr);
                    
                    if (section == 0) {
                        [MYTagTool saveBeauty:selecedArr];
                    }else if (section == 1){
                        [MYTagTool saveHospital:selecedArr];
                    }else{
                        [MYTagTool saveOwn:selecedArr];
                    }
                    //刷新section
                    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                };
                NSArray *selectedArray = tagArr;
                NSArray *tempArr;
                if (section == 0) {
                    tempArr = [MYTagTool arrayWithString:@"beauty.plist"];
                }
                else if (section == 1){
                    tempArr = [MYTagTool arrayWithString:@"hospital.plist"];
                }
                else{
                    tempArr = [MYTagTool arrayWithString:@"own.plist"];
                    
                }
                
                NSMutableArray *allArray = [NSMutableArray array];
                
                for (NSDictionary *dict in tempArr) {
                    [allArray addObject:dict[@"title"]];
                }
                NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",tagArr];
                //从全部数据中过滤掉已经筛选过的数组
                NSArray *optionalArray = [allArray filteredArrayUsingPredicate:filterPredicate];
                
                
//                NSArray *optionalArray = [allArray subarrayWithRange:NSMakeRange(tagArr.count, allArray.count - tagArr.count)];
                
                [vc.selectedArray addObjectsFromArray:selectedArray];
                [vc.optionalArray addObjectsFromArray:optionalArray];
                [self.navigationController presentViewController:vc animated:YES completion:nil];
                
            }
        };
        return headerview;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section < 3) {
        
        if (section < self.adImages.count) {
            return 165 + MYScreenW / 3;
        }else{
            return 155;
        }
    }else {
        
        return 75 + 10;
    }
  
}

#pragma mark - 组尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    
    UIButton *footBtn = [[UIButton alloc] init];
    footBtn.frame = CGRectMake(5, 1, self.view.width-10, 40);
    [footBtn setTitle:@"更多 >" forState:UIControlStateNormal];
    [footBtn setTitleColor:UIColorFromRGB(0x4c4c4c) forState:UIControlStateNormal];
    footBtn.titleLabel.font = MYFont(14);
    footBtn.tag = section;
    [footBtn addTarget:self action:@selector(clickFooter:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:footBtn];
    footBtn.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        footView.backgroundColor = UIColorFromRGB(0xfcf2fd);
    }else if(section == 1)
    {
        footView.backgroundColor = UIColorFromRGB(0xfcf9ea);
        
    }else if (section == 2)
    {
        footView.backgroundColor = UIColorFromRGB(0xdffffe);
        
    }else if (section>2)
    {
        footBtn.frame = CGRectMake(0, 0, MYScreenW, 40);
        [footView addSubview:[UIView addLineWithLineTopValue:0]];

    }
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (void)clickFooter:(UIButton *)sectionBtn
{
    
    if (sectionBtn.tag == 3) {
        
        self.tabBarController.selectedIndex = 2;
    }else if (sectionBtn.tag == 4){
    
         self.tabBarController.selectedIndex = 1;
    }else{
        
        if (sectionBtn.tag ==0) {
             MYHomeNewFormMoreBtnCollectionViewController *moreVC = [[MYHomeNewFormMoreBtnCollectionViewController alloc] init];
            
            if (self.mold0 ==0) {
                self.mold0 = 1000;
            }
            moreVC.modle = self.mold0;
            moreVC.section = 0;
            moreVC.titleName = self.selecedBeautyTitle ? self.selecedBeautyTitle : @"美容专场";
            
            [self.navigationController pushViewController:moreVC animated:YES];
        }else if(sectionBtn.tag ==1)
        {
             MYHomeDiscountListTableViewController *moreVC = [[MYHomeDiscountListTableViewController alloc]init];
            
            if (self.mold1 ==0) {
                self.mold1 = 1000;
                
            }
            
            moreVC.navTitle = [NSString stringWithFormat:@"%ld",(long)self.mold1];
            moreVC.section = 1;
            moreVC.tag = self.selecedHospitalTitle ? self.selecedHospitalTitle : @"微整形专场";
           
            
            [self.navigationController pushViewController:moreVC animated:YES];
        }else if(sectionBtn.tag ==2)
        {
            
            MYDiaryMallCollectionViewController * moreVC = [[MYDiaryMallCollectionViewController alloc] init];

            moreVC.titleName = self.selecedOwnTitle ? self.selecedOwnTitle : @"护肤品专场";
            [self.navigationController pushViewController:moreVC animated:YES];
        }
        
    }

}

/*
 @brief 定位的代理方法
 */
- (void)addLocationFunction
{
    // 只要设置里面定位服务开启，与网络无关
    if ([CLLocationManager locationServicesEnabled]){
        // 1.2 开始定位
        [self.locationManager startUpdatingLocation];
    }else{
        [MBProgressHUD showError:@"定位失败,请确认开启定位"];
    }
}
#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    //获取当前城市经纬度
    NSString *longitude = [NSString stringWithFormat:@"%lf", currentLocation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%lf", currentLocation.coordinate.latitude];
    
    [MYUserDefaults setObject:longitude forKey:@"longitude"];
    [MYUserDefaults setObject:latitude forKey:@"latitude"];
    [MYUserDefaults synchronize];
    
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSDictionary *test = [placemark addressDictionary];
            // Country(国家)State(城市)
            self.currentCityName = [test objectForKey:@"State"];
//            MYLog(@"%@",self.currentCityName);

        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        [MBProgressHUD showHUDWithTitle:@"获取位置信息失败" andImage:nil andTime:1.2];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yOffSet = scrollView.contentOffset.y;

    if (yOffSet > MYScreenW*0.453-20) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.statubar.hidden = NO;
        self.floatBar.hidden = NO;
    }else{
        self.floatBar.hidden = YES;
        self.statubar.hidden = YES;
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
}

/** 客服 */
-(void)gotoKeFu
{
    // 判断手机是否安装QQ
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=3308321066&version=1&src_type=web"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
        
    }else{
        
        CGFloat width = MYScreenW / 1.4;
        MYContentView *contentView = [[MYContentView alloc] initWithFrame:CGRectMake(0, 0, width, width / 1.42)];
        [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeGradient;
        [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
        [[HWPopTool sharedInstance] showWithPresentView:contentView animated:YES];
        
    }

}

-(BOOL)canUseCamera {
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        [UIAlertViewTool showAlertView:self title:@"提示" message:@"请在设备的设置-隐私-相机中允许访问相机" cancelTitle:@"确认" otherTitle:nil cancelBlock:^{
            
        } confrimBlock:^{}];
        
    }
    
    return YES;
}

-(BOOL)validateCamera {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - 请求每个组的数据(组头刷新)
- (void)requestSectionData:(int)section AndID:(NSInteger)ID
{
    NSString *url;
    if (section == 0) {
        url = [NSString stringWithFormat:@"%@homePage/querySalonSpe",kOuternet1];
    }
    else if (section == 1){
        url = [NSString stringWithFormat:@"%@homePage/queryHosSpe",kOuternet1];
        
    }
    else if (section == 2){
        url = [NSString stringWithFormat:@"%@homePage/queryOwnSpe",kOuternet1];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"homepage"] = @(1);
    params[@"mold"] = @(ID);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.color = [UIColor clearColor];
    hud.alpha = 0.8;
    hud.activityIndicatorColor = UIColorFromRGB(0xbcaa7c);
    
    [MYHttpTool postWithUrl:url params:params success:^(id responseObject) {
        
        if (section == 0) {
            self.mold0 = ID;
            
            /**
             *  美容专场
             */
            NSArray *salonArr = [MYSalonSpe objectArrayWithKeyValuesArray:responseObject[@"salonSpe"]];
            self.salonArr = salonArr;
        }
        
        if (section == 1) {
               self.mold1 = ID;
            /**
             *  医美专场
             */
            NSArray *hospitalArr = [MYHosSpe objectArrayWithKeyValuesArray:responseObject[@"hosSpe"]];
            self.hospitalArr = hospitalArr;
        }
        
        if (section == 2) {
               self.mold2 = ID;
            /**
             *  美购专场
             */
            NSArray *ownArr = [MYOwnSpe objectArrayWithKeyValuesArray:responseObject[@"ownSpe"]];
            self.ownArr = ownArr;
            
        }
        [hud hide:YES];
        
        //刷新section
        //一个cell刷新
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:section];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end

