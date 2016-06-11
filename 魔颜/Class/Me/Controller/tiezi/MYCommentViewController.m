//
//  MYCommentViewController.m
//  魔颜
//
//  Created by Meiyue on 15/12/22.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYCommentViewController.h"

#import "MYMyDiaryCommentsModel.h"
#import "MYDiaryCommentCell.h"
#import "MYDetailViewController.h"
#import "MYHeader.h"

@interface MYCommentViewController ()

@property(strong,nonatomic) NSMutableArray * diaryArr;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (nonatomic, assign) NSInteger page;
@property(strong,nonatomic) NSString * commentID;

@end

@implementation MYCommentViewController

- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}


-(NSMutableArray *)diaryArr
{
    if (!_diaryArr) {
        
        _diaryArr = [NSMutableArray array];
    }
    return _diaryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshMycommentData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //上拉刷新
    [self reloadMore];
    self.page = 1;
    
    /**注册通知*/
    [self setupNotification];
    
}

//下拉刷新
- (void)refreshMycommentData
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestCommentData:)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header beginRefreshing];
    });
 }

/*
 @brief 请求数据
 */
- (void)requestCommentData:(NSMutableDictionary *)parm
{
    self.diaryArr = nil;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    params[@"signature"] = [MYStringFilterTool getSignature];
    params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];

    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@diary/queryMyCommentsList",kOuternet1] params:params success:^(id responseObject) {
        
        NSString *data = [responseObject objectForKey:@"status"];
        if ([data isEqualToString:@"-106"])
        {
            [MBProgressHUD showError:@"暂时没有数据"];
        }
        
        NSMutableArray *commentsArr = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"diaryComments"]) {
            [commentsArr addObject:dict[@"diaryComments"]];
        }
        self.diaryArr = (NSMutableArray *)[MYMyDiaryCommentsModel objectArrayWithKeyValuesArray:commentsArr];
        [self.tableView.footer resetNoMoreData];
         [self.tableView reloadData];
        [self.tableView.header endRefreshing];
       self.page = 1;
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.diaryArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MYDiaryCommentCell *cell = [MYDiaryCommentCell cellWithTableView:tableView indexPath:indexPath];
    MYMyDiaryCommentsModel  *model = self.diaryArr[indexPath.row];
    cell.commentModel = model;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
    
    //    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MYDetailViewController *cirlceDeatilVC  = [[MYDetailViewController alloc]init];
    
    [self.navigationController pushViewController:cirlceDeatilVC animated:YES];
    
    MYMyDiaryCommentsModel *model = self.diaryArr[indexPath.row];
    cirlceDeatilVC.id = model.diaryId;
    
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
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@diary/queryMyCommentsList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.footer endRefreshingWithNoMoreData];
            self.page = 1;
        }else{
            
            NSMutableArray *commentsArr = [NSMutableArray array];
            for (NSDictionary *dict in responseObject[@"diaryComments"]) {
                
                [commentsArr addObject:dict[@"diaryComments"]];
            }

            NSArray *moreArr = [MYMyDiaryCommentsModel objectArrayWithKeyValuesArray:commentsArr];
            [self.diaryArr addObjectsFromArray:moreArr];
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

/*
 @brief 注册通知
 */
- (void)setupNotification
{
    //删除评论
    [MYNotificationCenter addObserver:self selector:@selector(clickDeleteBtn:) name:@"deleteMycomment" object:nil];
}

/*
 @brief 删除评论
 */
- (void)clickDeleteBtn:(NSNotification *)noti
{
    self.commentID = noti.userInfo[@"MYMycommentDelete"];
    
    [UIAlertViewTool showAlertView:self title:@"确定删除评论" message:nil cancelTitle:@"取消" otherTitle:@"确认" cancelBlock:^{
        
    } confrimBlock:^{
        
        self.params[@"id"] = self.commentID;
        self.params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        self.params[@"signature"] = [MYStringFilterTool getSignature];
        self.params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
        
        [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/cancelCommentDiary",kOuternet1] params:self.params success:^(id responseObject) {
            
            [self requestCommentData:_params];
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
            
        }];
    }
     ];
    
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
