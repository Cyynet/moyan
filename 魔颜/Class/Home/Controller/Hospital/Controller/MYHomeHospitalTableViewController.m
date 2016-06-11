//
//  MYHomeHospitalTableViewController.m
//  魔颜
//
//  Created by abc on 15/9/29.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYHomeHospitalTableViewController.h"
#import "MYPositionGroup.h"

#import "MYTopBtn.h"
#import "MYPopView.h"
#define MYTopMenuW MYScreenW * 0.33
#define MYTopMenuH MYScreenH * 0.066
#define topviewframe CGRectMake(MYScreenW-60, MYScreenH - 80, 50, 50)

#import "MYHomeHospitalListCell.h"

#import "AFNetworking.h"
#import "hospitaleListModel.h"

#import "MYHomeHospitalDeatilViewController.h"
#import "FmdbTool.h"
#import "MYHeader.h"

@interface MYHomeHospitalTableViewController ()<UITableViewDataSource,UITableViewDelegate>




//医院 美容院  卖场 医生 部位
@property (weak, nonatomic) UITableView *hispitalTableView;

@property(strong, nonatomic) NSArray *titles;

@property(strong,nonatomic) UIButton *CaseNumber;

@property(strong,nonatomic) NSMutableArray * hospitalListdata;


@property(weak, nonatomic) UIView *topMenu;
@property(weak, nonatomic) UIButton *topBtn;
@property(strong,nonatomic) UIView *popView;
@property (weak, nonatomic) UIView *lastView;
@property (weak, nonatomic) UIButton *lastBtn;
@property(copy, nonatomic) NSString *currentTopItem;
@property (copy, nonatomic) NSString *currentRegion;

@property (nonatomic, assign) NSInteger page;

@property(strong,nonatomic) UIButton * searchBtn;


/*
 @brief 相关服务的总数和当前页
 */
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger num;
@property(strong,nonatomic) UILabel * pagelable;

@property (copy, nonatomic) NSString *currentItem;
@property(strong, nonatomic)NSString  *kefuid;


@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * freshBool;
@property(strong,nonatomic) NSString * str;
@property(strong,nonatomic) UIButton * topview;

@end

@implementation MYHomeHospitalTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:@"医院列表"];
    self.navigationController.navigationBar.hidden = NO;
    [self addbell];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"医院列表吧"];

    [self.popView removeFromSuperview];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //    添加tableview视图
    [self setupTableview];
    
    self.hispitalTableView.tableFooterView = [[UIView alloc]init];
    
    //设置导航title
    self.title = @"医院";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    
    //    添加topviewmenu
    [self setupTopMenu];
    
    [self setupNotification];
    
    
    //上拉刷新------------------------------------
    [self reloadMore];
    self.page = 1;//-------------------------------
    
    
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
    NSString *str  =  [_fmdb createFMDBTable:@"hospital"];
    self.str = str;
    
    NSArray *dataarr =  [fmdb outdata:@"hospital"];
    if (dataarr.count) {
        
        //获取当前页输
        NSString *numstr = [fmdb chekoutcurrpagenum:@"hospital"];
        NSInteger numpage = [numstr integerValue];
        self.page = numpage;
        
        NSArray *newdotordata = [hospitaleListModel  objectArrayWithKeyValuesArray:dataarr];
        
        self.hospitalListdata = (NSMutableArray *)newdotordata;
        
        
    }else{
        
        //下拉刷新-----------------------------------
        [ self refreshHospitalData];
        self.freshBool =  @"yes";
        
    }
    //下拉刷新-----------------------------------
    [self refreshHospitalData];

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
    [self.hispitalTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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


- (void)setupNotification
{
    [MYNotificationCenter addObserver:self selector:@selector(selectedItem:) name:@"MYHospitalTitleChange" object:nil];
}

- (void)selectedItem:(NSNotification *)noti
{
    
    self.topBtn = noti.userInfo[@"MYTypeBtn"];
    self.currentItem = noti.userInfo[@"MYTopTitle"];
    MYTopBtn *topBtn = noti.userInfo[@"MYTypeBtn"];
    [topBtn setTitle:self.currentItem forState:UIControlStateNormal];
    if (self.topBtn.tag == 0) {
        
        self.currentTopItem =  [NSString stringWithFormat:@"%@",noti.userInfo[@"MYTitle"]] ;
        if ([self.currentTopItem  isEqualToString: @"0"]) {
            
            self.currentTopItem = nil;
            
        }
        //        self.currentRegion = nil;
        
    }else{
        
        self.currentRegion = noti.userInfo[@"MYTopTitle"];
        if ([self.currentRegion isEqualToString:@"全部地区"]) {
            self.currentRegion = nil;
        }
        //        self.currentTopItem = nil;
    }
    [self.hispitalTableView.header beginRefreshing];
    
    
}

//刷新-------------------------------
- (void)refreshHospitalData
{
    self.hispitalTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestListData)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (![self.freshBool isEqualToString:@"yes"]) {
            
        }else{
            [self.hispitalTableView.header beginRefreshing];
        }
    });
    
}

//顶部菜单按钮
- (void)setupTopMenu
{
    UIView *topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.width, 35)];
    self.topMenu = topMenu;
    topMenu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topMenu];
    
    UIView *driverView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 0.5, 5, 0.5, 25)];
    driverView.backgroundColor = [UIColor lightGrayColor];
    driverView.alpha = 0.4;
    [topMenu addSubview:driverView];
    
    UIView *driverView1 = [[UIView alloc] initWithFrame:CGRectMake(0, topMenu.height-0.5, MYScreenW, 0.5)];
    driverView1.backgroundColor = [UIColor lightGrayColor];
    driverView1.alpha = 0.4;
    [topMenu addSubview:driverView1];
    
    
    self.titles = @[@"全部项目",@"全部地区"];
    for (int i = 0; i < self.titles.count; i ++) {
        
        MYTopBtn *topBtn = [[MYTopBtn alloc] init];
        if (i == 0) {
            topBtn.frame = CGRectMake(self.view.width / 2 * i -0.5, 0, self.view.width / 2, 35);
        }else{
            topBtn.frame = CGRectMake(self.view.width / 2 * i + 0.5, 0, self.view.width / 2, 35);
        }
        [topBtn setTitle:[self.titles objectAtIndex:i]];
        [topBtn addTarget:self action:@selector(clickTopBtn:)];
        topBtn.tag = i;
        self.topBtn = topBtn;
        [_topMenu addSubview:topBtn];
    }
    
}

- (void)clickTopBtn:(UIButton *)topBtn
{
    [self.lastView removeFromSuperview];
    
    CGFloat popHeight = 8 * MYRowHeight;
    CGFloat popX = 0;
    if (topBtn.tag) {
        popX =0 ;
    }
    MYPopView *popView = [MYPopView popViewWithTopBtn:topBtn];
    popView.chooseArray = [NSMutableArray arrayWithArray:@[
    @[@"全部项目",@"额部",@"眉部",@"眼部",@"鼻部",@"唇部",@"面部",@"牙齿",@"毛发",@"抗衰",@"皮肤",@"身体"],
    @[@"全部地区",@"北京",@"上海",@"深圳",@"惠州",@"济南",@"烟台",@"南昌",@"海口",@"长沙"],
         ]];
    self.popView = popView;
    popView.tag = 1;
    [popView showInRect:CGRectMake(popX, self.topMenu.bottom+105, self.view.width , popHeight)];
    self.lastView = popView;
}

//请求数据
-(void)requestListData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"project"] = self.currentTopItem;
    params[@"region"] = self.currentRegion;
    params[@"page"] = @(1);
    
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@hospital/queryHospitalInfoList",kOuternet1] params:params success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.hispitalTableView.header endRefreshing];
            self.hospitalListdata = nil;
            [self.hispitalTableView reloadData];
            [MBProgressHUD showError:@"暂时没有数据哟"];
        }else{
            if (self.currentRegion ==nil & self.currentItem == nil) {
            //    删除数据
            [self.fmdb deleteData:@"hospital"];
            }
            NSArray *newdeatildata = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"queryHospitalInfoList"]];
            
            self.hospitalListdata = (NSMutableArray *)newdeatildata;
            [self.hispitalTableView reloadData];
            
            
            
            NSArray *arr = responseObject[@"queryHospitalInfoList"];
//            NSString *countstr = [NSString stringWithFormat:@"%ld",(long)num];
            if ([_str isEqualToString:@"yes"]) {
                if (self.currentRegion ==nil & self.currentItem == nil) {
                [_fmdb addDataInsetTable:arr page:1 datacount:@"5000" type:@"hospital"];
                }
            }else
            {
                return;
            }
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.hispitalTableView.header endRefreshing];
            [self.hispitalTableView.footer resetNoMoreData];
            self.page = 1;
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
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, MYTopMenuH, MYScreenW, MYScreenH -MYTopMenuH-10-40)];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.hispitalTableView = tableview;
    [self.view addSubview:tableview];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.hospitalListdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYHomeHospitalListCell *cell = [MYHomeHospitalListCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.controlerStyle = UIControlerStyleHospital;
//    cell.backgroundColor = MYRandomColor;
    
    if (self.hospitalListdata.count==0) {
        
    }else{
        hospitaleListModel *model = self.hospitalListdata[indexPath.row];
        cell.hospitalmodel = model;
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 130;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MYHomeHospitalDeatilViewController  *hospitaleDeatilVC = [[MYHomeHospitalDeatilViewController alloc]init];
    hospitaleListModel *hospitalemodel = self.hospitalListdata[indexPath.row];
    hospitaleDeatilVC.id = hospitalemodel.id;
    [self.navigationController pushViewController: hospitaleDeatilVC animated:YES];
    hospitaleDeatilVC.tag = 0;
    
    hospitaleDeatilVC.latitude = hospitalemodel.latitude;
    hospitaleDeatilVC.longitude = hospitalemodel.longitude;
    
    hospitaleDeatilVC.titleName = hospitalemodel.name;
    hospitaleDeatilVC.imageName = hospitalemodel.listPic;
    hospitaleDeatilVC.character = hospitalemodel.feature;
    
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
    param[@"project"] = self.currentTopItem;
    param[@"region"] = self.currentRegion;
    
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@hospital/queryHospitalInfoList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            
            [self.hispitalTableView.footer endRefreshingWithNoMoreData];
            
            
        }else{
            
            NSArray *newdeatildata = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"queryHospitalInfoList"]];
            
            [self.hospitalListdata  addObjectsFromArray:newdeatildata];
            
            
            NSArray *arr = responseObject[@"queryHospitalInfoList"];
//            NSString *countstr = [NSString stringWithFormat:@"%ld",(long)self.num];
            
            if ([_str isEqualToString:@"yes"]) {
                if (self.currentRegion ==nil & self.currentItem == nil) {
                [_fmdb addDataInsetTable:arr page:self.page datacount:@"5000" type:@"hospital"];
                }
            }else
            {
                return;
            }
            
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

/*
 @brief 分割线左对齐
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //按照作者最后的意思还要加上下面这一段
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

@end
