//
//  MYDoctorTableViewController.m
//  魔颜
//
//  Created by abc on 15/9/28.
//  Copyright (c) 2015年 abc. All rights reserved.
//


#import "MYHomeDoctorTableViewController.h"
#import "MYTopBtn.h"
#import "MYPopView.h"

#import "MYHomeDoctorDeatilTableViewController.h"
#import "doctorListModel.h"

#import "FmdbTool.h"

#import "MYHomeDoctorListCell.h"
#import "MYHeader.h"
#define MYTopMenuW MYScreenW * 0.33
#define MYTopMenuH MYScreenH * 0.066
#define topviewframe CGRectMake(MYScreenW-60, MYScreenH - 80, 50, 50)

@interface MYHomeDoctorTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView * tableView;


@property(strong,nonatomic) UIButton *CaseNumber;
@property(strong, nonatomic) NSArray *titles;

@property(strong,nonatomic) NSMutableArray  * doctorData;

@property (strong, nonatomic) NSMutableDictionary *params;
@property (nonatomic, assign) NSInteger page;

@property(weak, nonatomic) UIView *topMenu;
@property(weak, nonatomic) UIButton *topBtn;
@property(strong,nonatomic) UIView *popView;
@property (weak, nonatomic) UIView *lastView;

@property(copy, nonatomic) NSString *currentTopItem;
@property (copy, nonatomic) NSString *currentRegion;

@property(strong,nonatomic) UIButton * searchBtn;

/*
 @brief 相关服务的总数和当前页
 */
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger num;
@property(strong,nonatomic) UILabel * pagelable;

@property (copy, nonatomic) NSString *currentItem;

@property(strong, nonatomic)NSString *kefuid;

@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * str;


@property(strong,nonatomic) NSString * freshBool;
@property(strong,nonatomic) UIButton * topview;

@end

@implementation MYHomeDoctorTableViewController

- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xeaeaea);
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"医生列表"];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"医生列表"];
    self.searchBtn.hidden = YES;
    [self.popView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addbell];
     self.page = 1;//---
    
    //添加tableview
    [self setupTableview];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //设置导航title
    self.title = @"医生";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.tableView.separatorStyle = NO;
    
    
    
    //添加topviewmenu
    [self setupTopMenu];
    
    
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
    //发送通知
    [self setupNotification];
    
    //上拉刷新------------------------------------
    [self reloadMore];

    
    
    NSString *str  =  [_fmdb createFMDBTable:@"doctor"];
    self.str = str;
    
    NSArray *dataarr =  [fmdb outdata:@"doctor"];
    if(self.hospitalId != nil)
    {
        dataarr = nil;
    }
    if (dataarr.count) {
        
        //获取当前页输
        NSString *numstr = [fmdb chekoutcurrpagenum:@"doctor"];
        NSInteger numpage = [numstr integerValue];
        self.page = numpage;
        
        //        获取总页数
        NSArray *pagecount = [fmdb chekOutData:@"doctor"];
        
        NSInteger num = [pagecount[0] integerValue];
        if (num == 0) {
            self.count = 0;
            self.num = 0;
//            [self setupCurrentPage];
        }else {
            
            self.count = (num + 4) / 5;
        }
//        [self setupCurrentPage];
        
        NSArray *newdotordata = [doctorListModel  objectArrayWithKeyValuesArray:dataarr];
        
        self.doctorData = (NSMutableArray *)newdotordata;
        
        
    }else{
        
        self.freshBool =  @"yes";
        
        
    }
    
    //下拉刷新-----------------------------------
    [ self refreshdocttorData];
    
    
    [self addGotoTopView];
    
}
//置顶控件
-(void)addGotoTopView
{
    UIButton *topview = [[UIButton alloc]initWithFrame:topviewframe];
    self.topview = topview;
    self.topview.hidden = YES;
    [self.view addSubview:topview];
    [topview setImage:[UIImage imageNamed:@"totop"] forState:UIControlStateNormal];
    [topview addTarget:self action:@selector(clickTopbtn) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickTopbtn
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //    [self.hispitalTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView.contentOffset.y <= 700)
    {
        self.topview.hidden = YES;
        
    }else{
        self.topview.hidden = NO;
    }
}
//上拉加载更多--------------------------------------
- (void)setupMoreData
{
    
    self.page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"order"] = self.currentTopItem;
    param[@"region"] = self.currentRegion;
    param[@"hospitalId"] = self.hospitalId;
    
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@doctor/queryDoctorInfoList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.footer endRefreshingWithNoMoreData];
            
        }else{
            
            NSArray *newdeatildata = [doctorListModel objectArrayWithKeyValuesArray:responseObject[@"doctorInfoList"]];
            [self.doctorData  addObjectsFromArray:newdeatildata];
            
            
            NSArray *arr = responseObject[@"doctorInfoList"];
//            NSString *countstr = [NSString stringWithFormat:@"%ld",(long)self.num];
            
             if (self.hospitalId ==nil & self.currentItem ==nil & self.currentRegion == nil)  {
                if ([_str isEqualToString:@"yes"]) {
                    [_fmdb addDataInsetTable:arr page:self.page datacount:@"3000" type:@"doctor"];
                }
            }

            
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.tableView.footer endRefreshing];
            });
        }
        
        
    } failure:^(NSError *error) {
        
        [self.tableView.footer endRefreshing];
    }];
    
    
}

//加载数据
-(void)requestListDataD:(NSMutableDictionary *)params
{
    
    self.params[@"hospitalId"] = self.hospitalId;
    self.params[@"order"] = self.currentTopItem;
    self.params[@"region"] = self.currentRegion;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@doctor/queryDoctorInfoList",kOuternet1] params:self.params success:^(id responseObject) {
        //        http://121.43.229.113:8081/shaping/doctor/queryDoctorInfoList
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.header endRefreshing];
            self.doctorData = nil;
            [self.tableView reloadData];
            [MBProgressHUD showError:@"暂时没有数据哟"];
        }else{
            
            if (self.hospitalId ==nil & self.currentItem ==nil & self.currentRegion == nil) {
                [self.fmdb deleteData:@"doctor"];
            }
            
            NSArray *newdotordata = [doctorListModel  objectArrayWithKeyValuesArray:responseObject[@"doctorInfoList"]];
            self.doctorData = (NSMutableArray *)newdotordata;
            
            NSInteger num = [[responseObject objectForKey:@"count"] intValue];
            
            if (num == 0) {
                self.count = 0;
                self.num = 0;
//                [self setupCurrentPage];
            }else {
                
                self.count = (num + 4) / 5;
                self.page = 1;
            }
            
            if (self.hospitalId == nil & self.currentItem ==nil & self.currentRegion == nil) {
                NSArray *arr = responseObject[@"doctorInfoList"];
//                NSString *countstr = [NSString stringWithFormat:@"%ld",(long)num];
                if ([_str isEqualToString:@"yes"]) {
                    [_fmdb addDataInsetTable:arr page:1 datacount:@"3000" type:@"doctor"];
                }
            }
            
            [self.tableView.footer resetNoMoreData];
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];

            if (num < 5) {
                self.tableView.footer.hidden = YES;
            }
            
            
        }
        
    } failure:^( NSError *error) {
        
        [self.tableView.header endRefreshing];
        
    }];
}

/*
 @brief 显示当前页
 */
- (void)setupCurrentPage
{
    
    self.pagelable.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.num,(long)self.count];
    
}
//页数
-(void)setpagea
{
    
    UIImageView *pageimage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 60, MYScreenH - 65, 50, 50)];
    [self.view addSubview:pageimage];
    pageimage.image = [UIImage imageNamed:@"page"];
    
    UILabel *pagelable = [[UILabel alloc]init];
    [pageimage addSubview:pagelable];
    self.pagelable = pagelable;
    pagelable.frame = pageimage.bounds;
    pagelable.layer.cornerRadius = 20;
    pagelable.layer.masksToBounds = YES;
    pagelable.backgroundColor = [UIColor clearColor];
    pagelable.font = [UIFont systemFontOfSize:13];
    pagelable.textColor = subTitleColor;
    pagelable.textAlignment = NSTextAlignmentCenter;
    
    
}

- (void)setupNotification
{
    [MYNotificationCenter addObserver:self selector:@selector(selectedItem:) name:@"MYHospitalTitleChange" object:nil];
}

- (void)selectedItem:(NSNotification *)noti
{
    self.currentItem = noti.userInfo[@"MYTopTitle"];
    MYTopBtn *topBtn = noti.userInfo[@"MYTypeBtn"];
    [topBtn setTitle:self.currentItem forState:UIControlStateNormal];
    
    self.topBtn = noti.userInfo[@"MYTypeBtn"];
    if (self.topBtn.tag == 0) {
        if ([noti.userInfo[@"MYTopTitle"] isEqualToString:@"从高到低"]) {
            self.currentTopItem = @"desc";
        }else{
            self.currentTopItem = @"asc";
        }
        //        self.currentRegion = nil;
    }else{
        self.currentRegion = noti.userInfo[@"MYTopTitle"];
        
        if ([self.currentRegion isEqualToString:@"全部地区"]) {
            self.currentRegion = nil;
        }
        //        self.currentTopItem = nil;
    }
    
    [self.tableView.header beginRefreshing];
    
}

//刷新-------------------------------
- (void)refreshdocttorData
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestListDataD:)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (![self.freshBool isEqualToString:@"yes"]) {
            
            
        }else{
            
            [self.tableView.header beginRefreshing];
        }
    });
}

/*
 @brief 加载更多数据--------------------------
 */

- (void)reloadMore
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.tableView.footer.automaticallyChangeAlpha = YES;
    
}


//顶部菜单按钮
- (void)setupTopMenu
{
    UIView *topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.width, 35)];
    topMenu.backgroundColor = [UIColor whiteColor];
    self.topMenu = topMenu;
    [self.view addSubview:topMenu];

    UIView *driverView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 0.5, 5, 0.5, 25)];
    driverView.backgroundColor = [UIColor lightGrayColor];
    driverView.alpha = 0.4;
    [topMenu addSubview:driverView];
    
    UIView *driverView1 = [[UIView alloc] initWithFrame:CGRectMake(0, topMenu.height-0.5, MYScreenW, 0.5)];
    driverView1.backgroundColor = [UIColor lightGrayColor];
    driverView1.alpha = 0.4;
    [topMenu addSubview:driverView1];
    
    self.titles = @[@"工作经验",@"全部地区"];
    for (int i = 0; i < self.titles.count; i ++) {
        
        MYTopBtn *topBtn = [[MYTopBtn alloc] init];
        if (i == 0) {
            topBtn.frame = CGRectMake(self.view.width / 2 * i -0.5, 0, self.view.width / 2, 35);
        }else{
            topBtn.frame = CGRectMake(self.view.width / 2 * i + 0.5, 0, self.view.width / 2, 35);
        }
        
        [topBtn setTitle:[self.titles objectAtIndex:i]];
        
        NSString *city = [MYUserDefaults objectForKey:@"cityName"];
        if (city) {
            if (i == 1) {
                [topBtn setTitle:city];
                self.currentRegion = city;
            }
        }
        
        [topBtn addTarget:self action:@selector(clickTopBtn:)];
        topBtn.tag = i;
        self.topBtn = topBtn;
        [_topMenu addSubview:topBtn];
    }
    
}

- (void)clickTopBtn:(UIButton *)topBtn
{
    [self.lastView removeFromSuperview];
    
    CGFloat popX = 0;
    CGFloat popHeight = 0;
    if (topBtn.tag == 0) {
        popHeight = 2 * MYRowHeight;
    }else {
        popHeight = 5 * MYRowHeight;
        popX = 0;

    }
    MYPopView *popView = [MYPopView popViewWithTopBtn:topBtn];
    popView.chooseArray = [NSMutableArray arrayWithArray:@[
            @[@"从高到低",@"从低到高"],
    @[@"全部地区",@"北京",@"上海",@"深圳",@"惠州",@"济南",@"烟台",@"南昌",@"海口",@"长沙"],
    ]];
    self.popView = popView;
    popView.tag = 1;
    [popView showInRect:CGRectMake(popX, self.topMenu.bottom+105, self.view.width , popHeight)];
    self.lastView = popView;
    
}

//添加tableview视图
-(void)setupTableview
{
    UITableView *tableview = [[UITableView alloc]init];

#pragma mark--对是否是从医院详情页进入医生列表的判断
    if (self.hospitalId) {
        tableview.frame = CGRectMake(0, 0, MYScreenW, MYScreenH - MYTopMenuH);
    }else{
        tableview.frame = CGRectMake(0, MYTopMenuH, MYScreenW, MYScreenH - MYTopMenuH-40-10);
    }
    
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableView = tableview;
    [self.view addSubview:tableview];
    
}

#pragma mark - Table view data source
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.doctorData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYHomeDoctorListCell *cell = [MYHomeDoctorListCell cellWithTableView:tableView indexPath:indexPath] ;
    
    doctorListModel *doctlistmode = self.doctorData[indexPath.row];
    cell.doctorListMode = doctlistmode;
    
    self.num = (indexPath.row) / 5 + 1;
    [self setupCurrentPage];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //    return cell.height;
    return 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYHomeDoctorDeatilTableViewController *DoctorDeatilVC = [[MYHomeDoctorDeatilTableViewController alloc]init];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:DoctorDeatilVC animated:YES];
    
    //id 值已传,直接拿过去用
    doctorListModel *doctorModel = self.doctorData[indexPath.row];
    DoctorDeatilVC.id = doctorModel.id;
}


//添加零铛
-(void)addbell
{
    UIButton *rightBtn = [[UIButton alloc]init];
    self.searchBtn =rightBtn;
    rightBtn.frame = CGRectMake(MYScreenW - 40, 30, 25, 25);
    [rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
    
}

//小铃铛
-(void)clickBell
{
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}


@end
