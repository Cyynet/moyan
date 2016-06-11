
//
//  MYZhengXingGongLueViewController.m
//  魔颜
//
//  Created by abc on 16/5/6.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYZhengXingGongLueViewController.h"
#import "SCSearchBar.h"
#import "MYGongLueListModle.h"
#import "MYGongLueCell.h"
#import "MYGongLueSearchResultViewController.h"
#import "MYHeader.h"
#import "MYDetailViewController.h"

@interface MYZhengXingGongLueViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) NSMutableArray * listArr;
@property(assign,nonatomic) NSInteger  page;
@property(strong,nonatomic) UITableView * tableview;
@property(strong,nonatomic) SCSearchBar * searchbar;

@end

@implementation MYZhengXingGongLueViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

-(NSMutableArray*)listArr
{
    if (!_listArr) {
        NSMutableArray *listArr = [NSMutableArray array];
        _listArr = listArr;
    }
    return _listArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addsearchbar];
    [self addtableview];
    
    [self refreshData];
}



#pragma  mark---搜索栏
-(void)addsearchbar
{
    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 10)];
    topview.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.view addSubview:topview];
    
    
    SCSearchBar *searchbar = [[SCSearchBar alloc]initWithFrame:CGRectMake(kMargin, MYMargin, MYScreenW-60, 30)];
    self.searchbar = searchbar;
    [self.view addSubview:searchbar];
    searchbar.placeholder = @"查找美丽秘诀";
    searchbar.layer.masksToBounds = YES;
    searchbar.layer.cornerRadius =2;
    [searchbar setValue:UIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [searchbar setValue:MYFont(14) forKeyPath:@"_placeholderLabel.font"];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, MYScreenW, 0.5)];
    line.alpha = 0.4;
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];

    
    
    UILabel *right = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW-45, MYMargin, 35, 30)];
    [self.view addSubview:right];
    right.text = @"搜索";
    right.textColor = UIColorFromRGB(0x999999);
    right.font =  MYFont(14);
    
    
    
    UIButton *searchbtn = [[UIButton alloc]initWithFrame:CGRectMake(kMargin , MYMargin, MYScreenW, 30)];
    [self.view addSubview:searchbtn];
    [searchbtn addTarget:self action:@selector(ClickseachBtn) forControlEvents:UIControlEventTouchUpInside];
    [searchbtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    searchbtn.titleLabel.font = MYFont(14);
    
    
}

-(void)addtableview
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 50+10, MYScreenW, MYScreenH-40-64)];
    tableview.separatorStyle  = UITableViewCellSeparatorStyleNone;
    tableview.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.tableview = tableview;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
}
-(void)refreshData
{
    self.tableview.
    header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        if (![self.freshBool isEqualToString:@"yes"]) {
        
        //        }else{
        [self.tableview.header beginRefreshing];
        //        }
    });
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.tableview.footer.automaticallyChangeAlpha = YES;
    
    
}
#pragma mark--请求数据
-(void)requestData
{
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];

    prama[@"ver"] = MYVersion;
    prama[@"page"] = @(1);
    prama[@"classIfy"] = @(0);
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@diary/newQueryDiaryList",kOuternet1] params:prama success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"success" ]) {
            NSArray *arr =  [MYGongLueListModle objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            self.listArr = (NSMutableArray*)arr;
        }else{
            [MBProgressHUD showError:@"没有数据"];
        }
        [self.tableview reloadData];
        [self.tableview.header endRefreshing];
        self.page =1;
    } failure:^(NSError *error) {
        
        [self.tableview.header endRefreshing];
    }];
}
#pragma mark --上啦加载
-(void)setupMoreData
{
    self.page++;
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
    prama[@"ver"] = MYVersion;
    prama[@"page"] = @(self.page);
    prama[@"classIfy"] = @(0);
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@diary/newQueryDiaryList",kOuternet1] params:prama success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"-106" ])
        {
            [MBProgressHUD showError:@"没有更多数据"];
            [self.tableview.footer endRefreshingWithNoMoreData];
            self.tableview.footer.hidden = YES;
            
        }else if ([responseObject[@"status"] isEqualToString:@"success" ]) {
            NSArray *arr =  [MYGongLueListModle objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            [self.listArr addObjectsFromArray:arr];
        }
        [self.tableview reloadData];
        [self.tableview.footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableview.footer endRefreshing];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYGongLueCell*cell = [MYGongLueCell cellwithTableview:tableView indexPath:indexPath];
    if(indexPath.row==0)
    {
        cell.boomview.hidden = YES;
    }
    cell.listmodle = self.listArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 247;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MYDetailViewController *detailVC = [[MYDetailViewController alloc] init];
    MYGongLueListModle *model = self.listArr[indexPath.row];
    detailVC.id = model.id;
    detailVC.topPic = model.homePagePic;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchbar endEditing:YES];
}
#pragma mark-- 搜索跳转
-(void)ClickseachBtn
{
    MYGongLueSearchResultViewController *GongLueResult = [[MYGongLueSearchResultViewController alloc]init];
    GongLueResult.URL = @"diary/newQueryDiaryList";
    GongLueResult.classIfy =@"0";
    [self.navigationController pushViewController:GongLueResult animated:YES];
    
}
@end
