//
//  MYAttentionViewController.m
//  魔颜
//
//  Created by Meiyue on 15/9/29.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYAttentionViewController.h"
#import "MYAttention.h"
#import "MYAttentionCellTableViewCell.h"

#import "MYDetailViewController.h"
#import "MYHomeDoctorDeatilTableViewController.h"
#import "MYHeader.h"
@interface MYAttentionViewController ()

@property(strong,nonatomic)NSArray *atteng;
@property(strong,nonatomic) NSMutableArray * tieziArrData;

@property (nonatomic, assign) NSInteger page;
@property(strong,nonatomic) NSString * tieziID;
@property(strong,nonatomic) NSString * type;

@end

@implementation MYAttentionViewController

-(void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNotification];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self requestTieziData];
    
    
    //下拉刷新-----------------------------------
    [self refreshaguanzhuData];
    //上拉刷新------------------------------------
    [self reloadMore];
    self.page = 1;//--
}

//刷新-------------------------------
- (void)refreshaguanzhuData
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestTieziData)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.header beginRefreshing];
    });
    
    
}

/*
 @brief 注册通知
 */
- (void)setupNotification
{
    //取消关注
    [MYNotificationCenter addObserver:self selector:@selector(clickDeleteBtn:) name:@"cancelTieziAttention" object:nil];
}

/*
 @brief 取消关注
 */
- (void)clickDeleteBtn:(NSNotification *)noti
{
    self.type = noti.userInfo[@"type"];
    self.tieziID = noti.userInfo[@"MYCancelAttention"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消关注" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}


/*
 @brief 取消关注
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"attentionId"] = self.tieziID;
        params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        params[@"signature"] = [MYStringFilterTool getSignature];
        params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
        params[@"type"] = self.type;
        
        
        [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/cancelFocusDiary",kOuternet1] params:params success:^(id responseObject) {
            
            [self.tableView reloadData];
            [self refreshaguanzhuData];
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        
        
    }
    
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
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    param[@"signature"] = [MYStringFilterTool getSignature];
    param[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/diary/queryFocusDiary",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.footer endRefreshingWithNoMoreData];
            self.tableView.footer.hidden = YES;
            self.page = 1;
            
        }else{
            
            NSArray *newdeatildata = [MYAttention objectArrayWithKeyValuesArray:responseObject[@"diaryFocus"]];
            
            [self.tieziArrData  addObjectsFromArray:newdeatildata];
            
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.tableView.footer endRefreshing];
            });
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        [self.tableView.footer endRefreshing];
        [self.tableView.footer resetNoMoreData];
    }];
}

//请求数据
-(void)requestTieziData
{
    
    AFHTTPRequestOperationManager *marager = [[AFHTTPRequestOperationManager alloc]init];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    param[@"signature"] = [MYStringFilterTool getSignature];
    param[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    
    
    [marager GET:[NSString stringWithFormat:@"%@/diary/queryFocusDiary",kOuternet1] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *modelArr = [MYAttention objectArrayWithKeyValuesArray:responseObject[@"diaryFocus"]];
        
        
        self.tieziArrData = (NSMutableArray *)modelArr;
        
        [self.tableView.footer resetNoMoreData];
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.tableView.header endRefreshing];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tieziArrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYAttentionCellTableViewCell *cell = [MYAttentionCellTableViewCell cellWithTableView:tableView indexPath:indexPath];
    MYAttention  *model = self.tieziArrData[indexPath.row];
    cell.attention = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    取消cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MYAttention *model = self.tieziArrData[indexPath.row];
    if (model.CLASSIFICATION == 1) {

        MYDetailViewController *circleDeatilVC = [[MYDetailViewController alloc]init];
        
//      NSString *picstr = model.pic;
//      NSArray *picArr = [picstr componentsSeparatedByString:@","];
//      circleDeatilVC.topPic = picArr[0];
        
        circleDeatilVC.topPic = model.homePagePic;
        
        [self.navigationController pushViewController:circleDeatilVC animated:YES];
        
        circleDeatilVC.id = model.id;        
    }else
    {
        MYHomeDoctorDeatilTableViewController *doctordeatil = [[MYHomeDoctorDeatilTableViewController alloc]init];
        [self.navigationController pushViewController:doctordeatil animated:YES];
        doctordeatil.id = model.id;
    }
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
