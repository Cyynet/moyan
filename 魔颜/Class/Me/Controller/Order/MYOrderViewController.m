//
//  MYOrderViewController.m
//  魔颜
//
//  Created by Meiyue on 15/9/29.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYOrderViewController.h"
#import "MYOrderSelectViewController.h"
#import "MYFinishViewController.h"
#import "MYProductCell.h"
#import "MYOrder.h"
#import "MYOrderCommentViewController.h"
#import "MYTopBtn.h"
#import "MYHeader.h"
#define MYOrederMenuBtnW MYScreenW * 0.25

@interface MYOrderViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) UITableView *orderTableView;
@property (weak, nonatomic) UIView *lineView;

@property (nonatomic, strong) NSArray *titles;
@property (weak, nonatomic) UIButton *lastBtn;
@property (weak, nonatomic) UIButton *headBtn;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (strong, nonatomic) NSMutableArray *btnMutableArray;
@property (copy, nonatomic) NSString *currentParam;
@property (copy, nonatomic) NSString *isEvaluat;
@property (strong, nonatomic) NSMutableArray *orderLists;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *orderId;
@property (nonatomic, assign) NSInteger page;

@end

@implementation MYOrderViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    
    //请求数据
    [self refreshdingdanData:_params];
    
    //请求数据
    [self refreshdingdanData:_params];
}

/*
 @brief 懒加载
 */
- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}


- (NSMutableArray *)orderLists
{
    if (!_orderLists) {
        _orderLists = [NSMutableArray array];
    }
    return _orderLists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupHeadMenu];
    [self setupScrollLine];
    [self requestOrderListData:_params];
    [self setupTableView];
    [self setupNotification];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //上拉刷新
    [self reloadMore];
    
    self.page = 1;
}

//刷新
- (void)refreshdingdanData:(NSMutableDictionary *)dict
{
    self.orderTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestOrderListData:)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.orderTableView.header beginRefreshing];
    });
}

/*
 @brief 加载更多数据
 */

- (void)reloadMore
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.orderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.orderTableView.footer.automaticallyChangeAlpha = YES;
    
}

- (void)setupMoreData
{
    self.page ++;

    self.params[@"page"] = @(self.page);
    self.params[@"id"] = [MYUserDefaults objectForKey:@"id"];
    self.params[@"signature"] = [MYStringFilterTool getSignature];
    self.params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@reservationDes/selectOrderAndRes",kOuternet1] params:self.params success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.orderTableView.footer endRefreshingWithNoMoreData];
            self.page = self.page-1;
        }else{
            
            NSArray *orderList = [MYOrder objectArrayWithKeyValuesArray:responseObject[@"list"]];
           
            [self.orderLists  addObjectsFromArray:orderList];
        
            [self.orderTableView reloadData];
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.orderTableView.footer endRefreshing];
            });
        }
        
    } failure:^(NSError *error) {
    
        [self.orderTableView.footer endRefreshing];
    }];
    

}

/*
 @brief 注册通知
 */
- (void)setupNotification
{
    //删除订单
    [MYNotificationCenter addObserver:self selector:@selector(clickDeleteBtn:) name:@"delete" object:nil];
    
//    //评论按钮
    [MYNotificationCenter addObserver:self selector:@selector(clickComment:) name:@"comment" object:nil];

}

/*
 @brief 添加评论
 */
- (void)clickComment:(NSNotification *)noti
{
    
    MYOrderCommentViewController *orderCommentVC = [[MYOrderCommentViewController alloc] init];
    orderCommentVC.orderLists = noti.userInfo[@"MYOrder"];
//    orderCommentVC.commentBlock = ^(NSInteger mark){
//        MYProductCell *product = [MYProductCell productCell];
//        product.goToPayBtn.enabled = NO;
//        [product.goToPayBtn setTitle:@"已评价" forState:UIControlStateNormal];
//        
//    };
    [self.navigationController pushViewController:orderCommentVC animated:YES];
    
}

/*
 @brief 删除订单
 */
- (void)clickDeleteBtn:(NSNotification *)noti
{
    self.orderId = noti.userInfo[@"MYOrderDelete"];
    self.type = noti.userInfo[@"MYOrderType"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定删除订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}
/*
 @brief 确认删除
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        self.params[@"id"] = self.orderId;
        self.params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        self.params[@"signature"] = [MYStringFilterTool getSignature];
        self.params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
        
        if ([self.type isEqualToString:@"1"]) {
            
            [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@reservationDes/deleteResInfoById",kOuternet1] params:self.params success:^(id responseObject) {
                self.params[@"userId"] = nil;
                [self requestOrderListData:_params];

                [self.orderTableView reloadData];

            } failure:^(NSError *error) {
                
            }];
         }
        else{
            
            [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@order/deleteOrder",kOuternet1] params:self.params success:^(id responseObject) {
                self.params[@"userId"] = nil;
                [self requestOrderListData:_params];
                [self.orderTableView reloadData];

                
            } failure:^(NSError *error) {
                
            }];
        }

    }
}

/*
 @brief 创建tableView
 */
- (void)setupTableView
{
    UITableView *orderTableView = [[UITableView alloc] init];
    orderTableView.frame = CGRectMake(0, 100, self.view.width, self.view.height - 64  - 30);
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderTableView = orderTableView;
    [self.view addSubview:orderTableView];
}

- (void)setupNav
{
    MYTopBtn *titleBtn = [[MYTopBtn alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];
    [titleBtn setTitle:@"我的订单"];
    [titleBtn addTarget:self action:@selector(clickTitleBtn)];
    self.navigationItem.titleView = titleBtn;

}

- (void)clickTitleBtn
{
    MYOrderSelectViewController *orderSelectedVC = [[MYOrderSelectViewController alloc] init];
//    block  逆传值
    orderSelectedVC.myBlock = ^(NSInteger type){

        if (type) {
            self.type = [NSString stringWithFormat:@"%ld",(long)type];
        }else{
            self.type = nil;
        }
        self.page = 1;
        self.params[@"page"] = @(self.page);
        [self requestOrderListData:_params];
    };

    [self.navigationController pushViewController:orderSelectedVC animated:YES];
}

- (void)setupHeadMenu
{
    self.titles = @[@"全部",@"已付款",@"待付款",@"已完成"];
    
    for (int i = 0; i < self.titles.count; i ++ ) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = leftFont;
        btn.frame = CGRectMake(self.view.width * i / self.titles.count, 64, MYOrederMenuBtnW, 30);
        [btn setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:titlecolor forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:btn];
        
        if (0 == i) {
            btn.selected = YES;
            self.lastBtn = btn;
        }
        [_btnMutableArray addObject:btn];      
    }

}

- (void)setupScrollLine
{
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(MYOrederMenuBtnW * 0.2, 94, MYOrederMenuBtnW * 0.6, 2);
    lineView.backgroundColor = MYColor(193, 177, 122);
    self.lineView = lineView;
    [self.view addSubview:lineView];
}

- (void)btnClick:(UIButton *)btn
{
    
    self.page = 1;
    self.params[@"page"] = @(self.page);
    
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
 
    
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.x = btn.tag * (MYOrederMenuBtnW) + MYOrederMenuBtnW * 0.2;
    }];
    
    if (btn.tag == 0) {
        self.currentParam = @"";
    }else if (btn.tag == 1){
        self.currentParam = @"1";
    }else if (btn.tag == 2){
        self.currentParam = @"0";
    }else if (btn.tag == 3){
        self.currentParam = @"2";
    }else {
        self.currentParam = nil;
    }
    [self setupParams:btn];
    
}

/*
 @brief 订单参数
 */
- (void)setupParams:(UIButton *)btn
{
    self.params[@"status"] = self.currentParam;
    [self requestOrderListData:_params];
}
/*
 @brief 请求订单数据
 */
- (void)requestOrderListData:(NSMutableDictionary *)params
{
    if (self.orderTableView.header.isRefreshing) {
        [self.orderTableView.header endRefreshing];
    }
    self.params[@"type"] = self.type;
    self.params[@"id"] = [MYUserDefaults objectForKey:@"id"];
    self.params[@"signature"] = [MYStringFilterTool getSignature];
    self.params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    self.params[@"page"] = @"1";
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@reservationDes/selectOrderAndRes",kOuternet1] params:self.params success:^(id responseObject) {
         
         NSArray *arr = [MYOrder objectArrayWithKeyValuesArray:responseObject[@"list"]];
         self.orderLists = (NSMutableArray *)arr;

         if (arr.count == 0) {
             [MBProgressHUD showError:@"暂无数据"];
         }
         [self.orderTableView reloadData];
         [self.orderTableView.header endRefreshing];
         [self.orderTableView.footer resetNoMoreData];
         self.page = 1;
        
    } failure:^(NSError *error) {
        
         [self.orderTableView.header endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orderLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYProductCell *cell = [MYProductCell productCell];
    MYOrder *order = self.orderLists[indexPath.row];
    
    cell.order = order;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     MYOrder *order = self.orderLists[indexPath.row];
    
        MYFinishViewController *finishVC = [[MYFinishViewController alloc] init];
        finishVC.orderLists = order;
        finishVC.id = order.id;
        finishVC.type = order.type;
        finishVC.sumPrice = order.sumall;
        finishVC.status = [NSString stringWithFormat:@"%ld",(long)order.status];
        if (order.status) {
            finishVC.isShow = YES;
        }
        [self.navigationController pushViewController:finishVC animated:YES];


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}


@end
