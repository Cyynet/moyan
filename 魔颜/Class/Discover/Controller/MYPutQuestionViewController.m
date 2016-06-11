//
//  MYPutQuestionViewController.m
//  魔颜
//
//  Created by abc on 16/5/5.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYPutQuestionViewController.h"
#import "SCSearchBar.h"
#import "MYGongLueSearchResultViewController.h"
#import "MYRequestTableViewCell.h"
#import "MYRequestModle.h"
#import "MYQuestionViewController.h"
#import "UIButton+Extension.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYHeader.h"

@interface MYPutQuestionViewController ()<searchdelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSMutableArray * requestData;
@property(assign,nonatomic) NSInteger page;

@property(strong,nonatomic) NSString * freshBool;

@property(strong,nonatomic) SCSearchBar * searchbar;

@property(strong,nonatomic) UITableView * tableview;

@property(strong,nonatomic) NSMutableArray * ADimage;
@property(strong,nonatomic) NSMutableArray * ADurl;


@end

@implementation MYPutQuestionViewController

-(NSMutableArray*)requestData
{
    if (!_requestData) {
        NSMutableArray *listArr = [NSMutableArray array];
        _requestData = listArr;
    }
    return _requestData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 0.5)];
    [self.view addSubview:line];
        line.alpha= 0.4;
    line.backgroundColor = [UIColor lightGrayColor];

    
    self.page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    FmdbTool *fmdb = [[FmdbTool alloc]init];
    //    self.fmdb = fmdb;
    //
    //    [self.fmdb createFMDBTable:@"discovergonglue"];
    //    NSArray *dataarr = [self.fmdb outdata:@"discovergonglue"];
    //
    //    if (dataarr.count) {
    //
    //        self.listArr = (NSMutableArray*)[MYGongLueListModle objectArrayWithKeyValuesArray:dataarr];
    //
    //        self.page  =  [[self.fmdb chekoutcurrpagenum:@"discovergonglue"] integerValue];
    //
    //    }else{
    //
    self.freshBool = @"yes";
    
    //    }
    
    [self addsearchbar];
    [self addtableview];
    
    self.tableview.tableFooterView = [[UIView alloc]init];
    [self refreshData];
}
#pragma  mark---搜索栏
-(void)addsearchbar
{
    SCSearchBar *searchbar = [[SCSearchBar alloc]initWithFrame:CGRectMake(kMargin, kMargin, MYScreenW-60, 30)];
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
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, MYScreenW, MYScreenH-50-64-50)];

    self.tableview = tableview;
    tableview.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
}

-(void)addtableviewheader
{
    UIView *tableheader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenW / 3.0 + 10)];
    self.tableview.tableHeaderView = tableheader;
    
    UIButton *btn = [UIButton addButtonWithFrame:CGRectMake(0, 10, MYScreenW, MYScreenW / 3.0) backgroundColor:nil Target:self action:@selector(clickBtn)];
    [tableheader addSubview:btn];
    
    SDWebImageManager *imageManager = [[SDWebImageManager alloc]init];
    [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.ADimage[0]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (error == nil) {
            [btn setBackgroundImage:image forState:UIControlStateNormal];
        }
      }];

}

- (void)clickBtn
{
    MYHomeHospitalDeatilViewController *detailVC = [[MYHomeHospitalDeatilViewController alloc] init];
    detailVC.url = self.ADurl[0];
    detailVC.tag = 2;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)refreshData
{
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestionData)];
    
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
    
}

#pragma mark--请求数据
-(void)requestionData
{
    self.tableview.footer.hidden = NO;
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
//    prama[@"ver"] = MYVersion;
    prama[@"page"] = @(1);
    prama[@"type"]= @"1";
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@publish/queryPublishList",kOuternet1] params:prama success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"success" ]) {
            
            self.requestData = nil;
            //            [self.fmdb deleteData:@"discovergonglue"];
            
            NSArray *arr =  [MYRequestModle objectArrayWithKeyValuesArray:responseObject[@"publishList"]];
            self.requestData = (NSMutableArray*)arr;
            
            self.ADimage = [NSMutableArray array];
            self.ADurl = [NSMutableArray array];
            
            for (NSDictionary *dict in responseObject[@"publishAD"]) {
                [self.ADimage addObject:[NSString stringWithFormat:@"%@%@",kOuternet1,dict[@"pic"]]];
                
                [self.ADurl addObject:dict[@"url"]];

                }
            
            //            [self.fmdb addDataInsetTable:responseObject[@"diaryLists"] listArr2:nil listArr3:nil page:self.page type:@"discovergonglue"];
            if (self.ADimage.count) {
                
                [self addtableviewheader];
            }
        }else{
//            [MBProgressHUD showError:@"没有数据"];
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
//    prama[@"ver"] = MYVersion;
    prama[@"page"] = @(self.page);
    prama[@"type"] = @"1";
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@publish/queryPublishList",kOuternet1] params:prama success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"-106" ]){

            [self.tableview.footer endRefreshingWithNoMoreData];

            self.tableview.footer.hidden = YES;
//            self.page =1;
            
        }else if ([responseObject[@"status"] isEqualToString:@"success" ]) {


            NSArray *arr =  [MYRequestModle objectArrayWithKeyValuesArray:responseObject[@"publishList"]];
            
            [self.requestData addObjectsFromArray:arr];
            
//            [self.fmdb addDataInsetTable:responseObject[@"diaryLists"] listArr2:nil listArr3:nil page:self.page type:@"discovergonglue"];
            
        }
        [self.tableview reloadData];
        [self.tableview.footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableview.footer endRefreshing];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  self.requestData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MYRequestTableViewCell *cell = [MYRequestTableViewCell cellWithTableView:tableView indexPath:indexPath];

    cell.questModle = self.requestData[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MYQuestionViewController *detailVC = [[MYQuestionViewController alloc] init];
    detailVC.deleteBlock = ^(){
        
        MYRequestModle *model = self.requestData[indexPath.row];
        [self.requestData removeObject:model];
        [self.tableview reloadData];
        
    };

    MYRequestModle *model = self.requestData[indexPath.row];
    detailVC.id = model.id;
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
    GongLueResult.URL = @"publish/queryPublishList";
    GongLueResult.TYPE =@"1";
    [self.navigationController pushViewController:GongLueResult animated:YES];
    
}

-(void)gotosearchdelegate:(NSString *)values
{
    self.searchbar.text = values;
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
