//
//  MYHomeMallTableViewController.m
//  魔颜
//
//  Created by abc on 15/9/29.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYHomeDesignerTableViewController.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYLoginViewController.h"
#import "MYTopBtn.h"
#import "MYPopView.h"
#define MYTopMenuW MYScreenW * 0.33
#define MYTopMenuH MYScreenH * 0.066


#import "MYHomeDesignerDeatilTableViewController.h"
#import "MYHomeDesignerListCell.h"
#define kImageMaxCount 3

#import "designerListModel.h"
#import "MYHeader.h"
@interface MYHomeDesignerTableViewController ()<UIScrollViewDelegate>





@property (strong, nonatomic) UIPageControl *pageControl;
@property(strong,nonatomic) UITableView *desigertableview;


@property(strong,nonatomic)UIView *topMenu;
@property(weak, nonatomic) UIButton *lastBtn;
@property(strong, nonatomic) NSArray *titles;
@property (weak, nonatomic) UIView *lastView;

@property(strong,nonatomic) UIButton *CaseNumber;
@property(strong,nonatomic ) UIButton *project;
@property(strong,nonatomic) UIButton *region;


@property(weak, nonatomic) UIButton *topBtn;

@property(strong,nonatomic) UIView *mallseationView;

@property(strong,nonatomic)UIScrollView *scrollView;


@property(assign,nonatomic) CGFloat scrollviewHeight;

@property(strong,nonatomic) UIView *seationHeaderView;


@property(strong,nonatomic) NSMutableArray * desigerlistdata;

@property(assign,nonatomic) double popviewjuli;

@property(assign,nonatomic) double  oldOffset;


@property(assign,nonatomic) double  tableviewgundongjuli;

@property (nonatomic, assign) NSInteger page;

@property(strong, nonatomic)NSString *kefuid;

@end

@implementation MYHomeDesignerTableViewController


//让导航栏再次显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    self.title = @"设计师";
    
    UIButton *bellBtn = [[UIButton alloc]init];
    bellBtn.frame = CGRectMake(10, 10, 50, 50);
    [bellBtn setImage:[UIImage imageWithName:@"bell"] forState:UIControlStateNormal];
    UIBarButtonItem *rigthItem  = [[UIBarButtonItem alloc]initWithCustomView:bellBtn];
    self.navigationItem.rightBarButtonItem = rigthItem;
    [bellBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    
    //    添加scrollerview
    [self  setupMallScrollView];
    [self setupPageControl];
    
    //下拉刷新-----------------------------------
    [self refreshdesigerData];
    //上拉刷新------------------------------------
    [self reloadMore];
    self.page = 1;//---
    self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 00, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.frame = CGRectMake(0, 0, MYScreenW, MYScreenH - 60 );
    
    
    
    
}

//刷新-------------------------------
- (void)refreshdesigerData
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestListData:)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header beginRefreshing];
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

//上拉加载更多--------------------------------------
- (void)setupMoreData
{
    self.page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@designers/queryDesignersInfoList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            
            NSArray *newdeatildata = [designerListModel objectArrayWithKeyValuesArray:responseObject[@"queryDesignersInfoList"]];
            
            [self.desigerlistdata  addObjectsFromArray:newdeatildata];
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


//请求数据
-(void)requestListData:(NSMutableDictionary *)params
{
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@designers/queryDesignersInfoList",kOuternet1] params:params success:^(id responseObject) {
     
        NSString *status = responseObject[@"status"];
        NSString *url = responseObject[@"url"];
        
        if ([status isEqualToString:@"-106"]) {
            
            MYHomeHospitalDeatilViewController  *hospitaleDeatilVC = [[MYHomeHospitalDeatilViewController alloc]init];
            hospitaleDeatilVC.tag = 5;
            hospitaleDeatilVC.url = url;
            [self.navigationController pushViewController: hospitaleDeatilVC animated:YES];

        }else{
        
            NSArray *newdotordata = [designerListModel  objectArrayWithKeyValuesArray:responseObject[@"queryDesignersInfoList"]];
            //每请求一次就获取一次新的数据,新的数据存储下来,重新存储,老数据就要删除
            self.desigerlistdata = (NSMutableArray *)newdotordata;
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];

        }

    } failure:^( NSError *error) {
        
        [self.tableView.header endRefreshing];
        
    }];
}


//添加ScrollerView
-(void)setupMallScrollView
{
    
    UIView *headerview = [[UIView alloc]init];
    headerview.frame = CGRectMake(0, 0, MYScreenW, 350);
    self.tableView.tableHeaderView = headerview;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 350)];
    self.scrollviewHeight = scrollView.height;
    self.scrollView = scrollView;
    scrollView.delegate = self;
    
    for (int i = 0; i < kImageMaxCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:scrollView.bounds];
        imageView.userInteractionEnabled = YES;
        imageView.x = i * scrollView.width;
        
        NSString *name = [NSString stringWithFormat:@"top%d.jpg",i + 1];
        imageView.image = [UIImage imageWithName:name];
        
        if (i == kImageMaxCount - 1) {
            [self setupLastImageView:imageView];
        }
        
        [scrollView addSubview:imageView];
    }
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    scrollView.contentSize = CGSizeMake(kImageMaxCount * MYScreenW, 1);
    
    [headerview addSubview:scrollView];
}
-(void)setupPageControl
{
}

-(void)setupLastImageView:(UIImageView *)imageView
{
    
    [self setupDeatilBtn:imageView];
}

-(void)setupDeatilBtn:(UIImageView *)imageView
{
    UIButton *deatilBtn = [[UIButton alloc]init];
    deatilBtn.layer.masksToBounds = YES;
    deatilBtn.layer.cornerRadius = 5;
    deatilBtn.size = CGSizeMake(80 , 25);
    deatilBtn.centerX = 45 ;
    deatilBtn.centerY = 163;
    [deatilBtn addTarget:self action:@selector(clickStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:deatilBtn];
    
}


-(void)clickStartBtn:(UIButton *)startBtn
{
    
    MYHomeDesignerDeatilTableViewController *designerDeatilVC = [[MYHomeDesignerDeatilTableViewController alloc]init];
    
    [self.navigationController pushViewController:designerDeatilVC animated:YES];
    designerDeatilVC.id = @"1";
    
}

//滚动出发
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.width + 0.5;
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.desigerlistdata.count == 0) {
        
        self.desigertableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        return self.desigerlistdata.count;
    }else
    {
        self.desigertableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return self.desigerlistdata.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYHomeDesignerListCell *cell = [MYHomeDesignerListCell cellWithTableView:tableView indexPath:indexPath];
    
    designerListModel *model = self.desigerlistdata[indexPath.row];
    cell.designerModel = model;
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.desigertableview deselectRowAtIndexPath:indexPath animated:YES];
    MYHomeDesignerDeatilTableViewController *designerdeatilVC =[[ MYHomeDesignerDeatilTableViewController alloc]init];
    
    [self.navigationController pushViewController:designerdeatilVC animated:YES];
    
    
    designerListModel *desigermodel = self.desigerlistdata[indexPath.row];
    
    designerdeatilVC.id = desigermodel.id;
    designerdeatilVC.name = desigermodel.name;
    
    
}

//小铃铛
-(void)clickBell
{
   }


@end
