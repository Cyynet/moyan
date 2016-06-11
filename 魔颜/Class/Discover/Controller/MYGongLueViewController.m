
//
//  MYGongLueViewController.m
//  魔颜
//
//  Created by abc on 16/5/5.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYGongLueViewController.h"
#import "MYSearchBar.h"
#import "MYGongLueCell.h"
#import "SCSearchBar.h"
#import "MYGongLueListModle.h"
#import "MYGongLueSearchResultViewController.h"
#import "MJChiBaoZiHeader.h"
//#import "MJChiBaoZiFooter2"
#import "MJChiBaoZiFooter2.h"
#import "MYDetailViewController.h"
#import "MYHeader.h"


@interface MYGongLueViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,searchdelegate>
@property(strong,nonatomic) UITableView *tableview;
@property(strong,nonatomic) SCSearchBar * searchbar;

@property(assign,nonatomic) NSInteger page;
@property(strong,nonatomic) NSMutableArray * listArr;

@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * freshBool;


@end

@implementation MYGongLueViewController

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
    
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 0.5)];
    [self.view addSubview:line];
    line.alpha= 0.4;
    line.backgroundColor = [UIColor lightGrayColor];
    
    
    self.page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
    
    [self.fmdb createFMDBTable:@"discovergonglue"];
    NSArray *dataarr = [self.fmdb outdata:@"discovergonglue"];
    
    if (dataarr.count) {
        
        self.listArr = (NSMutableArray*)[MYGongLueListModle objectArrayWithKeyValuesArray:dataarr];
        
        self.page  =  [[self.fmdb chekoutcurrpagenum:@"discovergonglue"] integerValue];

    }else{
        
    self.freshBool = @"yes";

    }
    
    [self addsearchbar];
    [self addtableview];
    
    [self refreshData];
}
#pragma  mark---搜索栏
-(void)addsearchbar
{
    SCSearchBar *searchbar = [[SCSearchBar alloc]initWithFrame:CGRectMake(kMargin, kMargin, MYScreenW-60, 30)];
//    searchbar.searchdelegate = self;

    searchbar.searchdelegate = self;
    self.searchbar = searchbar;
    [self.view addSubview:searchbar];
    searchbar.placeholder = @"查找美丽秘诀";
    searchbar.layer.masksToBounds = YES;
    searchbar.layer.cornerRadius =2;
    [searchbar setValue:UIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [searchbar setValue:MYFont(14) forKeyPath:@"_placeholderLabel.font"];
    
//    searchbar.searchblock=^(NSString *searchstr)
//    {
//        self.searchbar.text = searchstr;
//    };
//    
    
    UILabel *right = [[UILabel alloc]initWithFrame:CGRectMake(MYScreenW-50, kMargin, 40, 30)];
    [self.view addSubview:right];
    right.text = @"搜索";
    right.textAlignment = NSTextAlignmentCenter;
    right.textColor = UIColorFromRGB(0x999999);
    right.font =  MYFont(14);
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MYScreenW, 0.5)];
    line.alpha = 0.4;
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    UIButton *searchbtn = [[UIButton alloc]initWithFrame:CGRectMake(kMargin , kMargin, MYScreenW, 30)];
    [self.view addSubview:searchbtn];
    [searchbtn addTarget:self action:@selector(ClickseachBtn) forControlEvents:UIControlEventTouchUpInside];
    [searchbtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    searchbtn.titleLabel.font = MYFont(14);
 
}

-(void)addtableview
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, MYScreenW, MYScreenH-50-64)];
    tableview.separatorStyle  = UITableViewCellEditingStyleNone;
    self.tableview = tableview;
    tableview.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];

}
-(void)refreshData
{
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self.freshBool isEqualToString:@"yes"]) {
        
        }else{
            [self.tableview.header beginRefreshing];
        }
    });
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.tableview.footer.automaticallyChangeAlpha = YES;

//    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
//    self.tableview.mj_header = header;
//    header.stateLabel.hidden=YES;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    if (![self.freshBool isEqualToString:@"yes"]) {
//
//        }else{
//            // 马上进入刷新状态
//            [self.tableview.mj_header beginRefreshing];
//        }
//
//   
//    MJChiBaoZiFooter2 *footer = [MJChiBaoZiFooter2 footerWithRefreshingTarget:self refreshingAction:@selector(setupMoreData)];
//    self.tableview.mj_footer = footer;
//    footer.stateLabel.hidden = YES;
//    self.tableview.mj_footer.automaticallyChangeAlpha = YES;
//

}

#pragma mark--请求数据
-(void)requestData
{
    self.tableview.footer.hidden = NO;
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
//    prama[@"title"] = self.searchbar.text;
    prama[@"ver"] = MYVersion;
    prama[@"page"] = @(1);
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@diary/newQueryDiaryList",kOuternet1] params:prama success:^(id responseObject) {

        if ([responseObject[@"status"] isEqualToString:@"success" ]) {
            
            self.listArr = nil;
            [self.fmdb deleteData:@"discovergonglue"];
            
            NSArray *arr =  [MYGongLueListModle objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            self.listArr = (NSMutableArray*)arr;

            
            [self.fmdb addDataInsetTable:nil listArr1:responseObject[@"diaryLists"] listArr2:nil listArr3:nil page:self.page type:@"discovergonglue"];
        
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
//    prama[@"title"] = self.searchbar.text;
    prama[@"ver"] = MYVersion;
    prama[@"page"] = @(self.page);
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@diary/newQueryDiaryList",kOuternet1] params:prama success:^(id responseObject) {
        
         if ([responseObject[@"status"] isEqualToString:@"-106" ])
         {
             [MBProgressHUD showError:@"没有更多数据"];
             [self.tableview.footer endRefreshingWithNoMoreData];
             self.tableview.footer.hidden = YES;

             
         }else if ([responseObject[@"status"] isEqualToString:@"success" ]) {
            NSArray *arr =  [MYGongLueListModle objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
             
             [self.listArr addObjectsFromArray:arr];
             
        
             [self.fmdb addDataInsetTable:nil listArr1:responseObject[@"diaryLists"] listArr2:nil listArr3:nil page:self.page type:@"discovergonglue"];

             
             
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

    [self.navigationController pushViewController:GongLueResult animated:YES];

}
-(void)gotosearchdelegate:(NSString *)values
{
    self.searchbar.text = values;
}




@end
