//
//  MYHomeCharacterTableViewController.m
//  魔颜
//
//  Created by abc on 15/9/29.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYHomeCharacterTableViewController.h"
#import "MYPositionGroup.h"
#import "MYPopView.h"
#import "MYTopBtn.h"
#import "MYAreaNames.h"
#import "MYtradingModel.h"
#define MYTopMenuW MYScreenW * 0.33
#define MYTopMenuH MYScreenH * 0.066
#define topviewframe CGRectMake(MYScreenW-60, MYScreenH - 80, 50, 50)

#import "MYHomeHospitalListCell.h"
#import "MYHomeCharaListModel.h"

#import "MYHomeHospitalDeatilViewController.h"
#import "MYHeader.h"
@interface MYHomeCharacterTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) UITableView *hispitalTableView;

@property(strong, nonatomic) NSArray *titles;

@property(strong,nonatomic) UIButton *CaseNumber;

@property(strong,nonatomic) NSMutableArray * hospitalListdata;

@property(weak, nonatomic) UIView *topMenu;
@property(weak, nonatomic) UIButton *topBtn;
@property(strong,nonatomic) UIView *popView;
@property (weak, nonatomic) UIView *lastView;
@property (weak, nonatomic) UIButton *lastBtn;
@property(copy, nonatomic)  NSString  *areaId;
@property (copy, nonatomic) NSString *tradingId;

@property (nonatomic, assign) NSInteger page;

@property(strong,nonatomic) UIButton * searchBtn;

@property(strong,nonatomic) UILabel * pagelable;

@property (copy, nonatomic) NSString *currentItem;
@property(strong, nonatomic)NSString  *kefuid;

@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * str;
@property(strong,nonatomic) NSString * freshBool;
@property(strong,nonatomic) UIButton * topview;

/** 全部项目 */
@property (strong, nonatomic) NSMutableArray *areaNames;
//@property (strong, nonatomic) NSArray *areas;
/** 商圈名字 */
//@property (strong, nonatomic) NSArray *tradingNames;
//@property (strong, nonatomic) NSArray *tradingIds;

//@property (assign, nonatomic) NSInteger indexPath;

/**项目选择  */
@property (strong, nonatomic) NSMutableArray *progectArr;

/** 特色 */
@property (copy, nonatomic) NSString *feature;

/** <#注释#> */
@property (nonatomic, assign) NSInteger leftReady;
/** <#注释#> */
@property (nonatomic, assign) NSInteger rightReady;

@end

@implementation MYHomeCharacterTableViewController

- (NSMutableArray *)progectArr
{
    if (!_progectArr) {
        _progectArr = [NSMutableArray arrayWithObject:@"全部"];
        //        _progectArr = [NSMutableArray array];
    }
    return _progectArr;
}

- (NSMutableArray *)areaNames
{
    if (!_areaNames) {
        //        _areaNames = [NSMutableArray arrayWithObject:@"不限地区"];
        _areaNames = [NSMutableArray array];
    }
    return _areaNames;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [MobClick beginLogPageView:@"美容院列表"];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"美容院列表"];
    [self.popView removeFromSuperview];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addbell];
    
    self.page = 1;//------
    self.title  = @"美容院";
    
    //添加tableview视图
    [self setupTableview];
    
    self.hispitalTableView.tableFooterView = [[UIView alloc]init];
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
    
    self.str = [_fmdb createFMDBTable:@"salonlist"];
    
    NSArray *dataarr =  [fmdb outdata:@"salonlist"];
    //    if (self.currentCity != nil) {
    //        dataarr = nil;
    //    }
    if (dataarr.count) {
        
        //获取当前页输
        NSString *numstr = [fmdb chekoutcurrpagenum:@"salonlist"];
        NSInteger numpage = [numstr integerValue];
        self.page = numpage;
        
        NSArray *newdotordata = [hospitaleListModel  objectArrayWithKeyValuesArray:dataarr];
        
        self.hospitalListdata = (NSMutableArray *)newdotordata;
        
    }else{
        
        //下拉刷新------------
        [ self refreshHospitalData];
        self.freshBool =  @"yes";
    }
    
    
    //下拉刷新----------
    [self refreshHospitalData];
    //上拉刷新----------
    [self reloadMore];
    
    [self requestMenuList];
    [self requestRightList];
    [self addGotoTopView];
    
    [self setupTopMenu];
    
    [self setupNotification];
    
}

- (void)requestMenuList
{
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@salon/queryCityList",kOuternet1] params:nil success:^(id responseObject){
        
        NSArray *arr = [MYAreaNames objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.areaNames addObjectsFromArray:arr];
        
        if (self.currentCity) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"areaName CONTAINS %@", self.currentCity];
            NSArray *filteredArray = [arr filteredArrayUsingPredicate:predicate];
            MYAreaNames *areaNames = filteredArray[0];
            self.areaId = areaNames.areaId;
            MYLog(@"定位当前城市的area是:%@",self.areaId);
        }
        
        self.leftReady = 1;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestRightList
{
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@salon/queryXiangmuList",kOuternet1] params:nil success:^(id responseObject){
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            [self.progectArr addObjectsFromArray:responseObject[@"xiangmu"]];
            self.rightReady = 1;
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
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
    [self.hispitalTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
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

- (void)setupNotification
{
    /** 右边的通知 */
    [MYNotificationCenter addObserver:self selector:@selector(selectedItem:) name:@"MYHospitalTitleChange" object:nil];
    
    /** 左边的通知 */
    [MYNotificationCenter addObserver:self selector:@selector(selectedLeftItem:) name:@"MYSecondTitleChange" object:nil];
}
- (void)selectedLeftItem:(NSNotification *)noti
{
    MYTopBtn *topBtn = noti.userInfo[@"MYTypeBtn"];
    NSString *name = noti.userInfo[@"MYTopTitle"];
    [topBtn setTitle:name forState:UIControlStateNormal];
    self.areaId = noti.userInfo[@"MYType"];
    self.tradingId = noti.userInfo[@"MYTitle"];
    self.freshBool = @"yes";
    [self refreshHospitalData];
    
}

- (void)selectedItem:(NSNotification *)noti
{
    MYTopBtn *topBtn = noti.userInfo[@"MYTypeBtn"];
    self.currentItem = noti.userInfo[@"MYTopTitle"];
    [topBtn setTitle:self.currentItem forState:UIControlStateNormal];
    
    int indexPath = [noti.userInfo[@"MYTitle"] intValue];
    if (topBtn.tag) {
        
        if (indexPath == 0) {
            self.feature = nil;
        }else{
            self.feature = self.progectArr[indexPath];
        }
    }
    self.freshBool = @"yes";
    [self refreshHospitalData];
    
}

//刷新-------------------------------
- (void)refreshHospitalData
{
    [self.hispitalTableView.header endRefreshing];
    
    self.hispitalTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestListdata)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.freshBool isEqualToString:@"yes"]) {
            [self.hispitalTableView.header beginRefreshing];
        }
    });
    
}

//顶部菜单按钮
- (void)setupTopMenu
{
    UIView *topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 35)];
    self.topMenu = topMenu;
    topMenu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topMenu];
    
    UIView *driverView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 0.5, 0, 1, 35)];
    driverView.backgroundColor = [UIColor lightGrayColor];
    driverView.alpha = 0.4;
    [topMenu addSubview:driverView];
    
    UIView *driverView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, self.view.width, 0.5)];
    driverView1.backgroundColor = [UIColor lightGrayColor];
    driverView1.alpha = 0.4;
    [topMenu addSubview:driverView1];
    
    if (self.currentCity) {
        self.titles = @[self.currentCity,@"项目选择"];
    }else{
        self.titles = @[@"商区选择",@"项目选择"];
    }
    
    for (int i = 0; i < self.titles.count; i ++) {
        
        MYTopBtn *topBtn = [[MYTopBtn alloc] init];
        topBtn.frame = CGRectMake(self.view.width / 2 * i , 0, self.view.width / 2, 35);
        [topBtn setTitle:[self.titles objectAtIndex:i]];
        [topBtn addTarget:self action:@selector(clickTopBtn:)];
        topBtn.tag = i;
        self.topBtn = topBtn;
        [_topMenu addSubview:topBtn];
    }
    
}

- (void)clickTopBtn:(MYTopBtn *)topBtn
{
    if (self.leftReady && self.rightReady) {
        
        self.lastBtn.selected = NO;
        topBtn.selected = YES;
        self.lastBtn = topBtn;
        
        [self.lastView removeFromSuperview];
        
        CGFloat popHeight;
        CGFloat popWidth;
        CGFloat popX;
        MYPopView *popView = [MYPopView popViewWithTopBtn:topBtn];
        self.popView = popView;
        
        if (topBtn.tag == 0) {
            popView.showStyle = UITableViewShowStyleDouble;
            popHeight = 7 * MYRowHeight;
            popWidth = self.view.width;
            popX = 0;
        }else{
            popHeight = 6 * MYRowHeight;
            popWidth = self.view.width / 2;
            popX = MYScreenW / 2;
        }
        
        popView.chooseArray = [NSMutableArray arrayWithArray:@[self.areaNames, self.progectArr]];
        [popView showInRect:CGRectMake(popX, 0, popWidth, popHeight)];
        self.lastView = popView;
    }
}

//请求数据
-(void)requestListdata
{
    [self.hospitalListdata removeAllObjects];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"areaId"] = self.areaId;
    params[@"tradingId"] = self.tradingId;
    params[@"feature"] = self.feature;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@salon/querySalonList",kOuternet1] params:params success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"-106"]) {
            
            [MBProgressHUD showError:@"暂时没有数据"];
            
        }else{
            
            if ( self.tradingId == nil & self.feature == nil) {
                // 删除
                [self.fmdb deleteData:@"salonlist"];
            }
            
            //             if ( (self.tradingId == nil || [self.tradingId isEqualToString:@""]) & (self.feature == nil || [self.feature isEqualToString:@""]))
            
            NSArray *newdeatildata = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"querySalonList"]];
            
            self.hospitalListdata = (NSMutableArray *)newdeatildata;
            
            NSArray *arr = responseObject[@"querySalonList"];
            if ([_str isEqualToString:@"yes"]) {
                
                if ( self.tradingId == nil & self.feature == nil) {
                    
                    [_fmdb addDataInsetTable:arr page:1 datacount:@"1000" type:@"salonlist"];
                    
                }
                
            }
        }
        [self.hispitalTableView reloadData];
        [self.hispitalTableView.header endRefreshing];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.hispitalTableView.footer resetNoMoreData];
        self.page = 1;
        
        if (self.hospitalListdata.count < 5) {
            
            self.hispitalTableView.footer.hidden = YES;
        }
        
    } failure:^( NSError *error) {
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.hispitalTableView.header endRefreshing];
        self.page = 1;
        
    }];
}

//添加tableview视图
-(void)setupTableview
{
    UITableView *tableview = [[UITableView alloc]init];
    tableview.frame = CGRectMake(0, 35 , MYScreenW, MYScreenH-35 );
    
    tableview.delegate = self;
    tableview.dataSource = self;
    self.hispitalTableView = tableview;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.hospitalListdata.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYHomeHospitalListCell *cell = [MYHomeHospitalListCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.controlerStyle = UIControlerStyleSalon;
    
    if (self.hospitalListdata.count==0) {
        
    }else{
        hospitaleListModel *model = self.hospitalListdata[indexPath.row];
        cell.hospitalmodel = model;
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MYHomeHospitalDeatilViewController  *hospitaleDeatilVC = [[MYHomeHospitalDeatilViewController alloc]init];
    hospitaleListModel *hospitalemodel = self.hospitalListdata[indexPath.row];
    hospitaleDeatilVC.id = hospitalemodel.id;
    [self.navigationController pushViewController: hospitaleDeatilVC animated:YES];
    
    
    hospitaleDeatilVC.latitude = hospitalemodel.latitude;
    hospitaleDeatilVC.longitude = hospitalemodel.longitude;
    
    hospitaleDeatilVC.titleName = hospitalemodel.name;
    hospitaleDeatilVC.imageName = hospitalemodel.listPic;
    hospitaleDeatilVC.character = hospitalemodel.feature;
    //    0 美容院付过费的    1没有
    if ([hospitalemodel.type isEqualToString:@"0"]) {
        hospitaleDeatilVC.tag = 5;
    }else{
        hospitaleDeatilVC.tag = 4;
    }
}

/*
 @brief 加载更多数据--------------------------
 */
- (void)reloadMore
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.hispitalTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.hispitalTableView.footer.automaticallyChangeAlpha = YES;
    
}

//上拉加载更多--------------------------------------
- (void)setupMoreData
{
    self.page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"areaId"] = self.areaId;
    param[@"tradingId"] = self.tradingId;
    
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@salon/querySalonList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            
            [self.hispitalTableView.footer endRefreshingWithNoMoreData];
            self.page = 1;
            
        }else{
            
            NSArray *newdeatildata = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"querySalonList"]];
            if ( self.tradingId == nil & self.feature == nil)
            {
                [self.fmdb addDataInsetTable:responseObject[@"querySalonList"] page:self.page datacount:@"1000" type:@"salonlist"];
            }
            [self.hospitalListdata  addObjectsFromArray:newdeatildata];
            [self.hispitalTableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.hispitalTableView.footer endRefreshing];
            });
        }
        
    } failure:^(NSError *error) {
        
        MYLog(@"%@",error);
        [self.hispitalTableView.footer endRefreshing];
    }];
    
}
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
