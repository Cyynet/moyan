//
//  MYLifeSecondViewController.m
//  魔颜
//
//  Created by Meiyue on 16/2/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYLifeSecondViewController.h"
#import "MYLifeSecondTableViewCell.h"
#import "MYLifeSecondModle.h"

#import "MYHomeHospitalDeatilViewController.h"
#import "MYHeader.h"
@interface MYLifeSecondViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UITableView * tableview;
@property(strong,nonatomic) NSMutableArray * lifeArrdata;
@property (nonatomic, assign) NSInteger page;


@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * str;
@property(strong,nonatomic) NSString * freshBool;


@property(strong,nonatomic) UIButton * rightBtn;

@end

@implementation MYLifeSecondViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"促销活动二级列表"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"促销活动二级列表"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titlename;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addtableview];
    //上拉刷新------------------------------------
    [self reloadMore];
    [self refreshData];
    
    self.fmdb = [[FmdbTool alloc]init];
    
    self.str = [self.fmdb createFMDBTable:@"activesecond"];
    
    NSArray *arr = [self.fmdb outdataActive:self.type];
 
    if (arr.count) {
        
        NSString *s = [self.fmdb checkoutpage:self.type];
        self.page = [s integerValue];
        
        NSArray *arry = [MYLifeSecondModle objectArrayWithKeyValuesArray:arr];
        self.lifeArrdata = (NSMutableArray *)arry;
    }else
    {
    [self refreshData];
    self.freshBool = @"yes";
    }
    
    [self addbell];
}


-(void)addbell
{
    UIButton *rightBtn = [[UIButton alloc]init];
    self.rightBtn =rightBtn;
    rightBtn.frame = CGRectMake(MYScreenW - 40, 30, 25, 25);
    [rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:rightBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}
//小铃铛
-(void)clickBell
{
    
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}


//刷新
-(void)refreshData
{
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestlifesecondData)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self.freshBool isEqualToString:@"yes"]) {
            
        }else{
        [self.tableview.header beginRefreshing];
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
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreliefsecondData];
    }];
    self.tableview.footer.automaticallyChangeAlpha = YES;
    
}

//上拉加载更多--------------------------------------
- (void)setupMoreliefsecondData
{
    self.page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"ver"] = MYVersion;
    param[@"classify"] = self.type;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/salonSpe/queryNewSalonSpeList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableview.footer endRefreshingWithNoMoreData];
            
        }else{
            
            NSArray *newdeatildata = [MYLifeSecondModle objectArrayWithKeyValuesArray:responseObject[@"querySalonSpeList"]];
            
            [self.lifeArrdata  addObjectsFromArray:newdeatildata];
            [self.tableview reloadData];
            
            if ([self.str isEqualToString:@"yes"]) {
            
                [self.fmdb addDataInsetTable:responseObject[@"querySalonSpeList"] page:self.page datacount:self.type type:@"activesecond"];
                
            }else{
                return ;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.tableview.footer endRefreshing];
                [self.tableview.footer resetNoMoreData];
            });
        }
        
    } failure:^(NSError *error) {
        
        [self.tableview.footer endRefreshing];
        [self.tableview.footer resetNoMoreData];
    }];
    
}


-(void)addtableview
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenH)];
    [self.view addSubview:tableview];
    tableview.delegate =self;
    tableview.dataSource = self;
    self.tableview = tableview;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

}
-(void)requestlifesecondData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    AFHTTPRequestOperationManager *marager = [[AFHTTPRequestOperationManager alloc]init];
    param[@"ver"] = MYVersion;
    param[@"classify"] = self.type;
    [marager GET:[NSString stringWithFormat:@"%@/salonSpe/queryNewSalonSpeList",kOuternet1] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [self.fmdb deleactiveseconddata:self.type];
        
        NSArray *arr = [MYLifeSecondModle objectArrayWithKeyValuesArray:responseObject[@"querySalonSpeList"]];
        self.lifeArrdata = (NSMutableArray *)arr;
        self.page = 1;
        [self.tableview reloadData];
        [self.tableview.header endRefreshing];
        [self.tableview.footer resetNoMoreData];
        
        
        if ([self.str isEqualToString:@"yes"]) {
            [self.fmdb addDataInsetTable:responseObject[@"querySalonSpeList"] page:1 datacount:self.type type:@"activesecond"];
            
        }else{
            return ;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.tableview.header endRefreshing];
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lifeArrdata.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYLifeSecondTableViewCell *cell = [MYLifeSecondTableViewCell cellWithTableView:tableView index:indexPath];

    MYLifeSecondModle *modle = self.lifeArrdata[indexPath.row];

    cell.lifenmodle = modle;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYHomeHospitalDeatilViewController *hosptionVC = [[MYHomeHospitalDeatilViewController alloc]init];
    MYLifeSecondModle *modle = self.lifeArrdata[indexPath.row];
    
    hosptionVC.id = modle.id;
    hosptionVC.tag = 6;
    hosptionVC.titleName = modle.title;
    hosptionVC.imageName = modle.listPic;
    hosptionVC.character = modle.desc;
    
    [self.navigationController pushViewController:hosptionVC animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MYScreenW / 3.0;
}


@end
