
//
//  WQHomeTableViewController.m
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYAliPayViewController.h"
#import "MYHomeDesignerDeatilTableViewController.h"

#import "MYHomeTableViewController.h"

#import "MYRegionViewController.h"
#import "MYLoginViewController.h"

#import "MYCategoryView.h"
#import "MYHomeSeactionControllerViewController.h"

#import "MYHomeDoctorTableViewController.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYHomeHospitalTableViewController.h"

#import "MYHomeDoctorDeatilTableViewController.h"
#import "MYHomeDesignerTableViewController.h"

#import "MYHomeCharacterTableViewController.h"
#import "MYDetailViewController.h"

#import "MYSearchViewController.h"
#import "MYTieziRelatedView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "AdView.h"
#import "MYTieziMyCell.h"

#define tabItemBtnfont 16
#define ImageViewCount 2

#define maxCol 5
#define maxRow 5
#define KMargin 5

#import "MYDiscountStoreViewController.h"  //卖场VC
#import "MYHomeCharacterTableViewController.h"
#import "MobClick.h"
@interface MYHomeTableViewController ()<UIScrollViewDelegate,clickseationBtnaddVCDelegate,clickDoctorBtnDelegate,clickHospitalBtnDelegate,clickMallBtnDelegate,clickCharacterBtnDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UIView  * navBarView;

@property (strong, nonatomic)  AdView * adView;

@property(strong,nonatomic)  UIView *headerView;

@property(assign,nonatomic ) CGFloat with;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UIView *btnView;

@property(strong ,nonatomic ) UIView *callcover;
@property (strong ,nonatomic ) UIButton *backcoverBtn;
@property(strong,nonatomic) UIView * addClassView;

@property(strong,nonatomic) UIView *seationHeaderView;
@property(strong,nonatomic) UIView  * seationHeaderView1;


@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,copy) NSString *currentCityName;
@property (weak, nonatomic) UIButton *leftBtn;
@property(strong,nonatomic) UIButton * rightBtn;


@property(strong,nonatomic) NSMutableArray * modelsArr;

@property(strong,nonatomic) NSMutableDictionary * params;

@property (nonatomic, assign) NSInteger page;

@property(strong,nonatomic) NSMutableArray * imagearr;

@property (copy, nonatomic) NSString *locationCount;

@property(strong,nonatomic) NSArray * callBtntitles;


@property(assign,nonatomic) double  coverheight;

@property(strong,nonatomic) NSString * tagstr;//全部项目参数

@property(strong,nonatomic) NSString * kefuid;//客服id

@property(strong,nonatomic) NSString * seactionName;

@property (strong, nonatomic) NSMutableArray *urls;

@property (nonatomic, assign) CGFloat previousY;
@property (nonatomic, assign) BOOL isUping;

@property(strong,nonatomic) UITableView * tableview;
@property(strong,nonatomic) UIButton * topview;

/**广告图地址*/
@property (copy, nonatomic) NSString *adAdress;
/**广告图链接*/
@property (copy, nonatomic) NSString *urlAdress;
/**视频链接*/
@property (copy, nonatomic) NSString *urlVideo;

/** 魔颜通分享图片 */
@property (copy, nonatomic) NSString *imageurl;

@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * freshBool;
@property(strong,nonatomic) NSString * str;

/** 定位到的区 */
@property (copy, nonatomic) NSString *SubLocality;

@end

@implementation MYHomeTableViewController

- (NSMutableArray *)imagearr
{
    if (_imagearr == nil) {
        _imagearr = [NSMutableArray array];
    }
    return _imagearr;
}

- (NSMutableArray *)modelsArr
{
    if (!_modelsArr) {
        _modelsArr = [NSMutableArray array];
    }
    return  _modelsArr;
}

- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
        self.params[@"homePage"] = @"1";
        self.params = _params;
    }
    return _params;
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
     [MobClick beginLogPageView:@"首页"];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x222222);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self location];//----------
   
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"首页"];
    [MYUserDefaults setObject:self.currentCityName forKey:@"cityName"];
    [MYUserDefaults synchronize];
    
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xeaeaea);
    //关闭定位
    [_locationManager stopUpdatingLocation];
    
    if (MYAppDelegate.isDefault) {
        MYAppDelegate.isDefault = NO;
        return;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    self.seationHeaderView1.hidden = YES;
    
}

// 1.1 创建定位管理者
-(CLLocationManager *)locationManager
{
    if(!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization]; // 永久授权
        [_locationManager requestWhenInUseAuthorization]; //使用中授权
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.page = 1;
    
    [self setupNavbar];
    
    [self setupFMDB];
    
    /**
     *  请求广告
     */
    [self requestAD];
    
    [self addtableview];

    self.locationCount = 0;
    
    self.navigationItem.title = nil;

    self.seactionName = @"所有项目";
    
    self.navigationController.delegate = self;
    
    [self setupScrollView];
    
    //添加五个Btn
    MYCategoryView *fiveviewBtn = [[MYCategoryView alloc]initWithFrame:CGRectMake(0, MYScreenW / 1.35 , MYScreenW, 70)];
    self.btnView = fiveviewBtn;
    fiveviewBtn.Seactiondelegate = self;
    fiveviewBtn.Doctordelegate = self;
    fiveviewBtn.Hospitaldelegate = self;
    fiveviewBtn.Charaterdelegate = self;
    fiveviewBtn.Malldelegate = self;
    
    [self.headerView addSubview:fiveviewBtn];
    [self setupvoidview];
 
    // 增加刷新控件
    [self setupRefresh];
    
    //置顶控件
    [self addGotoTopView];
    
    
}

-(void)setupFMDB
{
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
      
    NSString *str  =  [_fmdb createFMDBTable:@"homelist"];
    self.str = str;
    NSString *numstr = [fmdb chekoutcurrpagenum:@"homelist"];
    
    NSArray *dataarr =  [fmdb outdata:@"homelist"];
    
    if (dataarr.count) {
        
        //获取当前页输
        NSInteger numpage = [numstr integerValue];
        self.page = numpage;
           
        NSArray *newdotordata = [MYTieziModel  objectArrayWithKeyValuesArray:dataarr];
        self.modelsArr = (NSMutableArray *)newdotordata;
        
    }else{
        
        //下拉刷新-----------------------------------
        [ self setupRefresh];
        self.freshBool =  @"yes";
    }
    
}

//置顶控件
-(void)addGotoTopView
{
    UIButton *topview = [[UIButton alloc]initWithFrame:CGRectMake(MYScreenW-60, MYScreenH-120, 50, 50)];
    self.topview = topview;
    [self.view addSubview:topview];
    [topview setImage:[UIImage imageNamed:@"totop"] forState:UIControlStateNormal];
    [topview addTarget:self action:@selector(clickTopbtn) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickTopbtn
{
    //    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableview setContentOffset:CGPointMake(0, -7.5) animated:YES];
    
}

//添加tableview
-(void)addtableview
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    self.tableview.tableFooterView = [[UIView alloc]init];

    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,MYScreenW, 425)];
    self.headerView = headerView;
    headerView.backgroundColor = [UIColor whiteColor];
    //    添加置顶的viewbar
    self.tableview.tableHeaderView = headerView;
    
}

/**
 @breif 添加刷新控件
 */
- (void)setupRefresh
{
    // header - 下拉
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(addAllHomeData)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (![self.freshBool isEqualToString:@"yes"]) {
            
        }else{
            [self.tableview.header beginRefreshing];
        }
    });
    
    
    // footer - 上拉
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.tableview.footer.automaticallyChangeAlpha = YES;    
}

//当进去的没网，列表展示缓存，但是banner图和魔颜通没有数据，保证再次刷新可以再次请求数据
-(void)addAllHomeData
{
    [self setupvoidview];
    [self setuprequestData:nil];
    [self setupScrollView];
}

/*
 @brief 请求数据
 */
-(void)setuprequestData:(NSMutableDictionary *)params
{
    self.params[@"order"] = @"desc";
    self.params[@"ver"] = MYVersion;
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@diary/queryDiaryList",kOuternet1] params:self.params success:^(id responseObject) {

        if (self.params[@"secProCode"] == nil ) {
            // 删除数据库
            [self.fmdb deleteData:@"homelist"];
        }
 
        NSArray *modelArr = [MYTieziModel objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
        self.modelsArr = (NSMutableArray *)modelArr;
        
        NSArray *arr = responseObject[@"diaryLists"];
        
        if ([_str isEqualToString:@"yes"]) {
            
            if (self.params[@"secProCode"] == nil ) {
                [_fmdb addDataInsetTable:arr page:1 datacount:nil type:@"homelist"];
            }
            
        }else
        {
            return;
        }
        
        [self.tableview  reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 如果没有刷新数据的话，就把筛选view全部露出
            if (self.modelsArr.count == 0) {
                
                [self.tableview setContentOffset:CGPointMake(0, 100) animated:YES];
            }
            [self.tableview.header endRefreshing];
            [self.tableview.footer resetNoMoreData];
        });
        
        self.params[@"secProCode"] = nil;
        
    } failure:^(NSError *error) {
        
        [self.tableview.header endRefreshing];
        
    }];
    
    
}

-(void)setupNavbar
{
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 44)];
    self.navBarView = navBarView;
    self.navigationItem.titleView = navBarView;
    
    UIButton *searchbtn = [[UIButton alloc]initWithFrame:CGRectMake((MYScreenW -210)/2, 13, 210, 20)];
    [searchbtn setTitle:@"查找美丽秘诀" forState:UIControlStateNormal];
    [navBarView addSubview:searchbtn];
    [searchbtn setImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"] forState:UIControlStateNormal];
    [searchbtn setImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"] forState:UIControlStateHighlighted];
    searchbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    searchbtn.backgroundColor = [UIColor whiteColor];
    [searchbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    searchbtn.layer.masksToBounds = YES;
    searchbtn.layer.cornerRadius = 5;
    [searchbtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *leftbtn = [[UIButton alloc]init];
    [leftbtn setTitle:self.currentCityName ? self.currentCityName : @"北京市" forState:UIControlStateNormal];
    leftbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    leftbtn.titleLabel.font = [UIFont systemFontOfSize:11];
    leftbtn.frame = CGRectMake(10, 0, 50, 50);
    [leftbtn addTarget:self action:@selector(clickCurrentCity) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = leftbtn;
    [navBarView addSubview:leftbtn];
    
    
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(MYScreenW - 50, 2, 40, 40);
    [rightBtn setImage:[UIImage imageNamed:@"bell-1"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    [navBarView addSubview:rightBtn];
}

- (void)location
{
    // 只要设置里面定位服务开启，与网络无关
    if ([CLLocationManager locationServicesEnabled])
    {
        // 1.2 开始定位
        [self.locationManager startUpdatingLocation];
      
    }
    else
    {
//      [MBProgressHUD showError:@"定位不成功 ,请确认开启定位"];
    }
}
/**
 *
 *  @return 广告
 */

- (void)requestAD
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ver"] = MYVersion;
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/video/queryAdvertising",kOuternet1] params:params success:^(id responseObject) {
        
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"success"]) {
            
        self.adAdress = [NSString stringWithFormat:@"%@%@",kOuternet1,responseObject[@"advertisingPath"]];
        self.urlAdress = responseObject[@"path"];

        }
        
    } failure:^(NSError *error) {
    }];
    
}

/*
 @brief 定位的代理方法
 */
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
            //SubLocality(区)
            if ([self.currentCityName isEqualToString:@"北京市"]) {
                self.SubLocality = [test objectForKey:@"SubLocality"];
            }
            
            [MYUserDefaults setObject:self.currentCityName forKey:@"cityName"];
            [MYUserDefaults synchronize];
            
            [self.leftBtn setTitle:self.currentCityName forState:UIControlStateNormal];
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
        [MBProgressHUD showError:@"获取位置信息失败"];
    }
}

- (void)search
{
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

//视屏视图
-(void)setupvoidview
{
    
    AFHTTPRequestOperationManager *maragerVoid = [[AFHTTPRequestOperationManager alloc]init];
    [maragerVoid GET:[NSString stringWithFormat:@"%@/video/queryVideo",kOuternet1] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.urlVideo = responseObject[@"vPath"];
        NSString * voidimageurl = responseObject[@"videoPath"];
        UIImageView *voideImge = [[UIImageView alloc]init];
        [self.headerView addSubview:voideImge];
        
        [voideImge setContentScaleFactor:[[UIScreen mainScreen] scale]];
        voideImge.contentMode = UIViewContentModeScaleAspectFill;
        voideImge.frame = CGRectMake(0, 310, MYScreenW, 110);
        self.imageurl = [NSString stringWithFormat:@"%@%@",kOuternet1,voidimageurl];
        [voideImge sd_setImageWithURL:[NSURL URLWithString:self.imageurl]];
        
        UIButton *voidbtn = [[UIButton alloc]init];
        voidbtn.frame = CGRectMake(0, 325, MYScreenW, 110);
        [self.headerView addSubview:voidbtn];
        
        [voidbtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [voidbtn addTarget:self action:@selector(clickVoidBtn) forControlEvents:UIControlEventTouchUpInside];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

-(void)clickVoidBtn
{
    MYHomeHospitalDeatilViewController  *vc= [[MYHomeHospitalDeatilViewController alloc]init];
    vc.url =  self.urlVideo;
    vc.imageName = self.imageurl;
    vc.tag = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*
 @brief 切换城市
 */
-(void)clickCurrentCity
{
    MYRegionViewController *regionVC = [[MYRegionViewController alloc] init];
    regionVC.myBlock = ^(NSString *city){
        [self.leftBtn setTitle:city forState:UIControlStateNormal];
    };
    regionVC.currentCity = self.currentCityName;
    [self.navigationController pushViewController:regionVC animated:YES];
}

//bananer图
-(void)setupScrollView
{
    self.imagearr = nil;
    self.urls = nil;
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/banner/queryBanner",kOuternet1] params:nil success:^(id responseObject) {
        
        for (NSDictionary *dict in responseObject[@"banners"]) {
            [self.imagearr addObject:[NSString stringWithFormat:@"%@%@",kOuternet1,dict[@"bannerPath"]]];
            
            [self.urls addObject:dict[@"url"]];
        }
        [self loadScrollView];
    } failure:^(NSError *error) {
    }];
}

//加载轮播图
- (void)loadScrollView
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    AdView *view = [AdView adScrollViewWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenW / 1.35) imageLinkURL:self.imagearr
                             placeHoderImageName:nil
                            pageControlShowStyle:UIPageControlShowStyleCenter];
    
    //图片被点击后回调的方法
    view.callBack = ^(NSInteger index,NSString * imageURL)
    {
        MYHomeHospitalDeatilViewController  *vc= [[MYHomeHospitalDeatilViewController alloc]init];
        vc.tag = 2;
        vc.imageName = imageURL;
        vc.url = [self.urls objectAtIndex:index];
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    [self.headerView addSubview:view];
}

//滚动时置顶seationHeaderview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self addTableviewSeactionBar];
    
    return _seationHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}

-(void)addTableviewSeactionBar
{
    UIView *seationHeaderView = [[UIView alloc]init];
    seationHeaderView.backgroundColor =[UIColor whiteColor ];
    self.seationHeaderView = seationHeaderView;
    
    //  边线
    UIView *view1 = [[UIView alloc]init];
    view1.frame = CGRectMake(0, 0.5, MYScreenW, 0.5);
    view1.backgroundColor = [UIColor blackColor];
    view1.alpha = 0.1;
    [seationHeaderView addSubview:view1];
    
    
    UIView *view2 = [[UIView alloc]init];
    view2.frame = CGRectMake(0, 35 - 0.5, MYScreenW, 0.5);
    view2.backgroundColor = [UIColor blackColor];
    view2.alpha = 0.1;
    [seationHeaderView addSubview:view2];
    self.seationHeaderView = seationHeaderView;
    
    
    //    添加约束
    UIButton *topViewbarbtn = [[UIButton alloc]init];
    [topViewbarbtn setTitle:@"魔镜" forState:UIControlStateNormal];
    topViewbarbtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
    
    [topViewbarbtn setTitleColor:MYColor(87, 87, 87) forState:UIControlStateNormal];
    [topViewbarbtn addTarget:self action:@selector(clickTopViewbar) forControlEvents:UIControlEventTouchUpInside];
    [self.seationHeaderView addSubview:topViewbarbtn];
    
    [topViewbarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seationHeaderView).with.offset(15);
        make.bottom.equalTo(seationHeaderView).with.offset(-6);
    }];
    
    
    UIButton *rigthClassBtn = [[UIButton alloc]init];
    [rigthClassBtn setTitle:self.seactionName ? self.seactionName: @"所有项目" forState:UIControlStateNormal];
    [rigthClassBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rigthClassBtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
    
    [rigthClassBtn addTarget:self action:@selector(clickClassBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.seationHeaderView addSubview:rigthClassBtn ];
    [rigthClassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(seationHeaderView).with.offset(-15);
        make.bottom.equalTo(seationHeaderView).with.offset(-6);
    }];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(MYScreenW - 140, 0, 130, 35);
    [btn addTarget:self action:@selector(clickClassBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.seationHeaderView addSubview:btn];
    
}
/**
 *  让组头停留
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.callcover removeFromSuperview];
    [self.backcoverBtn removeFromSuperview];
    self.tableview.contentInset = UIEdgeInsetsMake(64, 0, 80, 0);
    
    if(scrollView.contentOffset.y <= 1600)
    {
        self.topview.hidden = YES;
        
    }else{
        self.topview.hidden = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= -104 && scrollView.contentOffset.y < -10) {
        [self.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

//置顶的组头
-(void)clickClassBtn
{
    UIView * callcover = [[UIView alloc]init];
    callcover.frame = CGRectMake(0, 0, MYScreenW, MAXFLOAT);
    callcover.backgroundColor = [UIColor blackColor];
    callcover.alpha = 0.02;
    self.callcover = callcover;
    [self.tableview addSubview:callcover];
    
    
    UIButton *backcoverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, MAXFLOAT)];
    [backcoverBtn addTarget:self action:@selector(clickbackcoverBtn) forControlEvents:UIControlEventTouchUpInside];
    self.backcoverBtn = backcoverBtn;
    [self.tableview addSubview:backcoverBtn];
    
    UIView *addClassView = [[UIView alloc]initWithFrame:CGRectMake(0, self.seationHeaderView.y + 30, MYScreenW, 80)];
    self.addClassView = addClassView;
    addClassView.backgroundColor = MYColor(246, 246, 246);
    
    
    //    背景图
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [UIImage imageWithName:@"homebtnback"];
    imageview.frame = CGRectMake(0, self.seationHeaderView.y + 28, MYScreenW, addClassView.height );
    [backcoverBtn addSubview:imageview];
    
    //分割线
    UIView *classdivibtnview1 = [[UIView alloc]init];
    classdivibtnview1.frame = CGRectMake(0, 28, MYScreenW, 1);
    classdivibtnview1.backgroundColor = MYColor(231, 231, 231);
    //    classdivibtnview1.alpha = 0.05;
    [addClassView addSubview:classdivibtnview1];
    
    UIView *classdivibtnview2 = [[UIView alloc]init];
    classdivibtnview2.frame = CGRectMake(0, 78, MYScreenW, 1);
    classdivibtnview2.backgroundColor = MYColor(231, 231, 231);
    //    classdivibtnview2.alpha = 0.05;
    [addClassView addSubview:classdivibtnview2];
    
    
    UIView *classdivibtnview3 = [[UIView alloc]init];
    classdivibtnview3.frame = CGRectMake(0, 52, MYScreenW, 1);
    classdivibtnview3.backgroundColor = MYColor(231, 231, 231);
    //    classdivibtnview3.alpha = 0.05;
    [addClassView addSubview:classdivibtnview3];
    
    [self.backcoverBtn addSubview:addClassView];
    
    
    self.callBtntitles = @[@"额  头",@"眉  型",@"眼  周",@"鼻  型",  @"唇  型",@"脸  型",@"美  肤",@"除  皱", @"胸  部",@"塑  身",@"面综合",@"双眼皮",@"查看全部"];
    
    for (int i = 0; i < self.callBtntitles.count; i ++ ) {
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [btn setTitleColor:MYColor(104, 104, 104) forState:UIControlStateNormal];
        
        int col = i % maxCol;
        int row = i / maxCol;
        btn.width = (self.view.width - (maxCol + 1) * KMargin) / maxCol+2 ;
        btn.height = 20;
        btn.x = col *  (btn.width + KMargin) ;
        btn.y = row * (btn.height + KMargin) +5;
        [btn setTitle:[self.callBtntitles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickCallBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        if (btn.tag == 20) {
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        //        第四列居左
        if (btn.tag ==11||btn.tag == 12||btn.tag==13) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        }
        [addClassView addSubview:btn];
        
    }
}

-(void)clickCallBtn:(UIButton *)btn
{
    
    [self clickbackcoverBtn];
    NSString *str ;
    switch (btn.tag) {
        case 1:
            str = @"1";
            self.seactionName = @"额 头";
            break;
        case 2:
            str = @"2";
            self.seactionName = nil;
            self.seactionName = @"眉 形";
            break;
        case 3:
            str = @"4";
            self.seactionName = @"眼 周";
            break;
        case 4:
            str = @"5";
            self.seactionName = @"鼻 型";
            break;
        case 5:
            str = @"6";
            self.seactionName = @"唇 型";
            break;
        case 6:
            str = @"7";
            self.seactionName = @"脸 型";
            break;
        case 7:
            str = @"15";
            self.seactionName = @"美 肤";
            break;
        case 8:
            str = @"13";
            self.seactionName = @"除 皱";
            break;
        case 9:
            str = @"18";
            self.seactionName = @"胸 部";
            break;
        case 10:
            str = @"19";
            self.seactionName = @"塑 身";
            break;
        case 11:
            str = @"9";
            self.seactionName = @"面综合";
            break;
        case 12:
            str = @"3";
            self.seactionName = @"双眼皮";
            break;
            
    }

    if (btn.tag == 13) {
        self.seactionName = @"所有项目";
        [self.modelsArr removeAllObjects];
        [self setuprequestData:_params];
        
    }else{
        self.params[@"secProCode"] = str;
        self.tagstr = str;
        self.params[@"homePage"] = nil;
        [self setuprequestData:_params];
    }
    self.page = 1;
}

-(void)clickbackcoverBtn
{
    [self.callcover removeFromSuperview];
    [self.backcoverBtn removeFromSuperview];
    
}

-(void)clickTopViewbar
{
    
}

//小铃铛
-(void)clickBell
{}

//代理方法
-(void)clickSeactionBtn        //部位
{
    
    MYHomeSeactionControllerViewController *seactionVC = [[MYHomeSeactionControllerViewController alloc]init];
    [self.navigationController pushViewController:seactionVC animated:YES];
    
}
-(void)clickDoctorBtn       //医生
{
    MYHomeDoctorTableViewController *DoctorVC = [[MYHomeDoctorTableViewController alloc]init];
    [self.navigationController pushViewController:DoctorVC animated:YES];
    
}
-(void)clickHosptialBtnaddVC    //医院
{
    MYHomeHospitalTableViewController *hospitalVC = [[MYHomeHospitalTableViewController alloc]init];
    [self.navigationController pushViewController:hospitalVC animated:YES];
}
-(void)clickMallBtnaddVC //卖场
{
    MYDiscountStoreViewController *storeVC = [[MYDiscountStoreViewController alloc]init];
    
    self.rightBtn.hidden = YES;
    [self.navigationController pushViewController:storeVC animated:YES];
    
    
}
-(void)clickCharacterBtnaddVC  //美容院
{
    MYHomeCharacterTableViewController *salonVC = [[MYHomeCharacterTableViewController alloc]init];
    salonVC.currentCity = self.SubLocality;
    [self.navigationController pushViewController:salonVC animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modelsArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYTieziMyCell *cell = [MYTieziMyCell cellWithTableView:tableView indexPath:indexPath];
    
    if (!self.adAdress) {
        
        MYTieziModel *model = self.modelsArr[indexPath.row];
        cell.tieziModel = model;
        cell.releatedView.myBlock = ^(NSInteger type,NSString *id,NSString *name,NSString *imageURL){
            
            if (type) {
                MYHomeHospitalDeatilViewController  *deatilevc = [[MYHomeHospitalDeatilViewController alloc]init];
                [self.navigationController pushViewController:deatilevc animated:YES];
                
                deatilevc.titleName = name;
                deatilevc.imageName = imageURL;
                //  deatilevc.character = discountListmodel.hospitalName;
                deatilevc.id = id;
                deatilevc.tag = 1;
                deatilevc.character =@"";
            }else{
                
                MYHomeDoctorDeatilTableViewController *DoctorDeatilVC = [[MYHomeDoctorDeatilTableViewController alloc]init];
                [self.navigationController pushViewController:DoctorDeatilVC animated:YES];
                DoctorDeatilVC.id = id;
                
            }
            
        };
        return cell;
    }else{

    if (indexPath.row == 1) {
        
        NSArray *arr = [NSArray arrayWithObjects:self.adAdress, nil];
        
        AdView *view = [AdView adScrollViewWithFrame:CGRectMake(5, 0, MYScreenW - 10, 110) imageLinkURL:arr
                                 placeHoderImageName:nil
                                pageControlShowStyle:UIPageControlShowStyleNone];
        
        //图片被点击后回调的方法
        view.callBack = ^(NSInteger index,NSString * imageURL)
        {
            MYHomeHospitalDeatilViewController  *vc= [[MYHomeHospitalDeatilViewController alloc]init];
            vc.tag = 3;
            vc.imageName = imageURL;
            vc.url = self.urlAdress;
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        [cell.contentView addSubview:view];
        return cell;
        
    }else{
        
        MYTieziModel *model;
        
        if (indexPath.row == 0) {
            model = self.modelsArr[indexPath.row];
        }else{
            model = self.modelsArr[indexPath.row - 1];
        }
        cell.tieziModel = model;
        cell.releatedView.myBlock = ^(NSInteger type,NSString *id,NSString *name,NSString *imageURL){
            
            if (type) {
                
                MYHomeHospitalDeatilViewController  *deatilevc = [[MYHomeHospitalDeatilViewController alloc]init];
                [self.navigationController pushViewController:deatilevc animated:YES];
                
                deatilevc.titleName = name;
                deatilevc.imageName = imageURL;
                //  deatilevc.character = discountListmodel.hospitalName;
                deatilevc.id = id;
                deatilevc.tag = 1;
                
            }else{
                
                MYHomeDoctorDeatilTableViewController *DoctorDeatilVC = [[MYHomeDoctorDeatilTableViewController alloc]init];
                [self.navigationController pushViewController:DoctorDeatilVC animated:YES];
                DoctorDeatilVC.id = id;
                
            }
            
        };
        return cell;
    }
    
    }
 }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        
        if (!self.adAdress) {
            UITableViewCell *cell = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
            return cell.height;
        }else{
          return 110;
        }
    }else{
        UITableViewCell *cell = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     //    取消cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MYTieziModel  *model;
    if (self.adAdress) {
        
        if (indexPath.row > 1) {
            model = self.modelsArr[indexPath.row - 1];
        }else{
            model = self.modelsArr[indexPath.row];
        }
    }else{
            model = self.modelsArr[indexPath.row];
    }
    
    MYDetailViewController *circleDeatilVC = [[MYDetailViewController alloc]init];
    circleDeatilVC.id = model.id;
    [self.navigationController pushViewController:circleDeatilVC animated:YES];
    
}

- (void)setupMoreData
{
    self.page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"order"] = @"desc";
    param[@"ver"] = MYVersion;
    
    if ([self.seactionName isEqualToString:@"所有项目"]){
        param[@"secProCode"] = nil;
        param[@"homePage"] = @"1";
    }else{
        param[@"secProCode"] = self.tagstr;
    }
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@diary/queryDiaryList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableview.footer endRefreshingWithNoMoreData];
        }else{
            
            NSArray *modelArr = [MYTieziModel objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            
            [self.modelsArr  addObjectsFromArray:modelArr];

            //插入数据
            NSArray *arr = responseObject[@"diaryLists"];
            if ([_str isEqualToString:@"yes"]) {
                if (self.params[@"secProCode"] == nil ){
                    [_fmdb addDataInsetTable:arr page:self.page datacount:nil type:@"homelist"];
                }
            }else
            {
                return;
            }
            

            [self.tableview reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.tableview.footer endRefreshing];
                [self.tableview.footer resetNoMoreData];
            });
        }
        
        
    } failure:^(NSError *error) {
        
        [self.tableview.footer endRefreshing];
    }];
    
    
}

@end
