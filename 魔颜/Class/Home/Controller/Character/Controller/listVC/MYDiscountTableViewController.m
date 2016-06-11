//
//  WQDiscountTableViewController.m
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYDiscountTableViewController.h"
#import "MYDiscountCell.h"
#import "MYDiscount.h"
#import "MYProgectCell.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYHomeDiscountListTableViewController.h"
#import "MYSearchViewController.h"
#import "MobClick.h"

@interface MYDiscountTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *discounts;
@property(strong, nonatomic)NSString *kefuid;


@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * str;
@property(strong,nonatomic) NSString * freshBool;
@end

@implementation MYDiscountTableViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick beginLogPageView:@"商城一级列表"];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"商城一级列表"];
}

-(NSArray *)discounts
{
    if (!_discounts) {
        _discounts = [NSArray array];
    }
    return _discounts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
        [self refreshDiscountData];
    
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
    
    
    if ([self.VCtype isEqualToString:@"1"]) {
    
        self.str = [self.fmdb createFMDBTable:@"malldiscount"];
        
        NSArray *mallarr = [self.fmdb outdata:@"malldiscount"];
        if (mallarr.count) {
            NSArray *newStatuses = [MYDiscount objectArrayWithKeyValuesArray:mallarr];
            self.discounts = newStatuses;
            
        }else
        {
        [self refreshDiscountData];
            self.freshBool = @"yes";
        }
        
    }else{
        
        self.str =  [self.fmdb createFMDBTable:@"discount"];
        
        NSArray *mallarr = [self.fmdb outdata:@"discount"];
        if (mallarr.count) {
            NSArray *newStatuses = [MYDiscount objectArrayWithKeyValuesArray:mallarr];
            self.discounts = newStatuses;
            
        }else
        {
            [self refreshDiscountData];
            self.freshBool = @"yes";
        }
    }
    

    

}
//刷新-----------
- (void)refreshDiscountData
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDiscountData)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self.freshBool isEqualToString:@"yes"]) {
            
        }else{
        [self.tableView.header beginRefreshing];
        }
    });
    
}
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    if ([self.tagVC isEqualToString:@"1"]) {
        tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height-64);
    }else if([self.tagVC isEqualToString:@"TAG"])
    {
        tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height-64-40);

    }else{
    tableView.frame = CGRectMake(0, kMargin, self.view.width, self.view.height-64-45);
        tableView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

//请求数据
- (void)requestDiscountData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ver"] = MYVersion;
    
    NSString *url;
    
//    if (![self.VCtype isEqualToString:@"1"]) {
    
        url = [NSString stringWithFormat:@"%@/specialdeals/querySpecialdealsNewTypeList",kOuternet1];
        
//    }else
//    {
//          url = [NSString stringWithFormat:@"%@/specialdeals/querySpecialdealsTypeList",kOuternet1];
//    }
    
    [MYHttpTool getWithUrl:url params:params success:^(id responseObject) {

        if ([self.VCtype isEqualToString:@"1"]) {
        [self.fmdb deleteData:@"malldiscount"];
        }else{
        [self.fmdb deleteData:@"discount"];
        }
        
        NSArray *newStatuses = [MYDiscount objectArrayWithKeyValuesArray:responseObject[@"querySpecialdealsTypeList"]];
        self.discounts = newStatuses;
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
        if ([self.str isEqualToString:@"yes"]) {

            if ([self.VCtype isEqualToString:@"1"]) {
                
                [self.fmdb addDataInsetTable:responseObject[@"querySpecialdealsTypeList"] page:1 datacount:nil type:@"malldiscount"];
            }else{
                [self.fmdb addDataInsetTable:responseObject[@"querySpecialdealsTypeList"] page:1 datacount:nil type:@"discount"];
            }
        }else{
            return ;
        }
        
    } failure:^(NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^(){
        [self.tableView.header endRefreshing];
            
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.discounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYDiscount *discount = self.discounts[indexPath.row];
    
    if (discount.smallPic) {
        
        MYProgectCell *cell = [MYProgectCell progectCell];
         cell.progect = self.discounts[indexPath.row];
        return cell;
        
    }else{
        
        MYDiscountCell *cell = [MYDiscountCell cellWithTableView:tableView index:indexPath];
         cell.discount = self.discounts[indexPath.row];
        return cell;
     }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MYDiscount *discount = self.discounts[indexPath.row];
    
        if (discount.smallPic) {
            
            MYHomeHospitalDeatilViewController  *deatilevc = [[MYHomeHospitalDeatilViewController alloc]init];
            [self.navigationController pushViewController:deatilevc animated:YES];
            deatilevc.titleName = discount.title;
            deatilevc.imageName = discount.smallPic;
            deatilevc.character = discount.hospitalName;
            deatilevc.id = discount.id;
            deatilevc.tag = 1;
            deatilevc.classify = @"1";
            
        }else{
            
            MYHomeDiscountListTableViewController *discountListVC = [[MYHomeDiscountListTableViewController alloc]init];
            [self.navigationController pushViewController:discountListVC animated:YES];
            
            discountListVC.navTitle = discount.type;
            discountListVC.tag = discount.typeName;
    
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYDiscount *discount = self.discounts[indexPath.row];
    
    if (discount.smallPic) {
        
        return 120;
     
    }else{
        
        return MYScreenW / 2.5 + 10;

    }
    
}

@end
