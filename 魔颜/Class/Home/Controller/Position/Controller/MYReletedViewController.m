
//  MYPublicViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/9.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYReletedViewController.h"

#import "MYDetailViewController.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYHomeDoctorDeatilTableViewController.h"

#import "MYTieziModel.h"
#import "MYTieziMyCell.h"
#import "MYHeader.h"


@interface MYReletedViewController ()

@property (strong, nonatomic) NSMutableArray *modelsArr;
@property (assign, nonatomic) NSInteger count;

@property (nonatomic, assign) NSInteger page;

@end

@implementation MYReletedViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"相关帖子"];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [MobClick endLogPageView:@"相关帖子"];
 }
- (NSMutableArray *)modelsArr
{
    if (!_modelsArr) {
        _modelsArr = [NSMutableArray array];
    }
    return  _modelsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView.height = MYScreenH - 64 - 40;
    
    //下拉刷新-----------------------------------
    [self refreshHospitalData];
    //上拉刷新------------------------------------
    [self reloadMore];
    self.page = 1;//-------------------------------
}

//刷新-------------------------------
- (void)refreshHospitalData
{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestMyTiezia)];
    
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
    param[@"secProCode"] = [MYUserDefaults objectForKey:@"second"];
    param[@"order"] = @"desc";
    param[@"ver"] = MYVersion;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@diary/queryDiaryList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.footer endRefreshingWithNoMoreData];
            
        }else{
            
            NSArray *newdeatildata = [MYTieziModel objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            
            [self.modelsArr  addObjectsFromArray:newdeatildata];
            
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

- (void)requestMyTiezia
{
    
    [self.modelsArr removeAllObjects];
    
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secProCode"] = [MYUserDefaults objectForKey:@"second"];
    params[@"type"] = @"0";
    params[@"signature"] = [MYStringFilterTool getSignature];
    params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    params[@"page"] = @"1";
    params[@"order"] = @"desc";
    params[@"ver"] = MYVersion;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@diary/queryDiaryList",kOuternet1] params:params success:^(id responseObject) {
        

        NSArray *modelArr = [MYTieziModel objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
        //       self.modelsArr = modelArr;
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, modelArr.count)];
        
        [self.modelsArr insertObjects:modelArr atIndexes:indexSet];
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {

        [self.tableView.header endRefreshing];

    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYTieziMyCell *cell = [MYTieziMyCell cellWithTableView:tableView indexPath:indexPath];
    if(self.modelsArr.count==0){
        return cell;
    }else{
    MYTieziModel  *model = self.modelsArr[indexPath.row];
    cell.tieziModel = model;
    cell.releatedView.myBlock = ^(NSInteger type,NSString *id,NSString *name,NSString *imageURL){
        
        if (type) {
            MYHomeHospitalDeatilViewController  *deatilevc = [[MYHomeHospitalDeatilViewController alloc]init];
            [self.navigationController pushViewController:deatilevc animated:YES];
            
            deatilevc.titleName = name;
            deatilevc.imageName = imageURL;
            //                deatilevc.character = discountListmodel.hospitalName;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     self.scrollRight = YES;
    //  取消cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MYTieziModel  *model = self.modelsArr[indexPath.row];
    MYDetailViewController *circleDeatilVC = [[MYDetailViewController alloc]init];
    circleDeatilVC.id = model.id;
    [self.navigationController pushViewController:circleDeatilVC animated:YES];
    
}


@end