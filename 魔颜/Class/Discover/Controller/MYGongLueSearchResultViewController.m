
//  MYGongLueSearchResultViewController.m
//  魔颜
//
//  Created by abc on 16/5/5.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYGongLueSearchResultViewController.h"
#import "MYGongLueCell.h"
#import "SCSearchBar.h"
#import "MYHeader.h"
#import "MYRandonChatModle.h"
#import "MYRequestModle.h"
#import "MYRandomChatTableViewCell.h"
#import "MYRequestTableViewCell.h"
#import "MYQuestionViewController.h"
#import "MYArticleViewController.h"
#import "MYDetailViewController.h"

@interface MYGongLueSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) SCSearchBar * searchbar;

@property(assign,nonatomic) NSInteger page;
@property(strong,nonatomic) NSString * searchtext;

@property(strong,nonatomic) NSMutableArray * listArr;
@property(strong,nonatomic) UITableView * tableview;
@property(strong,nonatomic) NSString * freshBool;

@end

@implementation MYGongLueSearchResultViewController


-(NSMutableArray*)listArr
{
    if (!_listArr) {
        NSMutableArray *listArr = [NSMutableArray array];
        _listArr = listArr;
    }
    return _listArr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [MYNotificationCenter addObserver:self selector:@selector(searchtext:) name:@"searchtext" object:nil];

    [self addsearchbar];
    
    UITableView*tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 60+30, MYScreenW, MYScreenH-60-30)];
//    tableview.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:tableview];
    tableview.delegate =self;
    tableview.dataSource = self;
    self.tableview = tableview;

    self.tableview.tableFooterView = [[UIView alloc]init];
    
    [self refreshsearresultData];


}
-(void)refreshsearresultData
{

    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.tableview.footer.automaticallyChangeAlpha = YES;
}



#pragma  mark---搜索栏
-(void)addsearchbar
{
    UIButton *backbtn = [[UIButton alloc]initWithFrame:CGRectMake(kMargin, 20*2, 30, 30)];
    [self.view addSubview:backbtn];
    [backbtn setTitle:@"取消" forState:UIControlStateNormal];
    [backbtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    backbtn.titleLabel.font = MYFont(14);
    [backbtn addTarget:self action:@selector(clickback) forControlEvents:UIControlEventTouchUpInside];
    
    
    SCSearchBar *searchbar = [[SCSearchBar alloc]initWithFrame:CGRectMake(45,MYMargin*2, MYScreenW-70-30, 30)];
    self.searchbar = searchbar;
    [self.view addSubview:searchbar];
    searchbar.placeholder = @"查找美丽秘诀";
    searchbar.layer.masksToBounds = YES;
    searchbar.layer.cornerRadius =2;
    [searchbar setValue:UIColorFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [searchbar setValue:MYFont(14) forKeyPath:@"_placeholderLabel.font"];
    searchbar.keyboardType = UIKeyboardTypeWebSearch;
    
    
    UIButton *searchbtn = [[UIButton alloc]initWithFrame:CGRectMake(MYScreenW-50 , MYMargin*2, 40, 30)];
    [self.view addSubview:searchbtn];
    [searchbtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(ClickseachBtn) forControlEvents:UIControlEventTouchUpInside];
    [searchbtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    searchbtn.titleLabel.font = MYFont(14);
    [self.searchbar becomeFirstResponder];
    
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 80, MYScreenW, 0.5)];
    [self.view addSubview:lineview];
    lineview.backgroundColor = [UIColor lightGrayColor];
    lineview.alpha = 0.4;
    
}
-(void)ClickseachBtn
{

    self.searchtext = self.searchbar.text;
//    self.freshBool = @"yes";
    [self requestData];
    [self.searchbar endEditing:YES];

}

#pragma mark--请求数据
-(void)requestData
{
    if (self.searchbar.text.length==0) {
        return;
    }else{

    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
    prama[@"title"] = self.searchbar.text;
    prama[@"page"] = @(1);
    prama[@"type"] = self.TYPE;
    prama[@"classIfy"] = self.classIfy;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kOuternet1,self.URL];
    
    [MYHttpTool postWithUrl:url params:prama success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            NSArray *arr ;
            if ([self.TYPE isEqualToString:@"0"]) //聊聊
            {
                arr =  [MYRandonChatModle objectArrayWithKeyValuesArray:responseObject[@"publishList"]];
            }else if([self.TYPE isEqualToString:@"1"])//提问
            {
                arr =  [MYRequestModle objectArrayWithKeyValuesArray:responseObject[@"publishList"]];
            
            }else if ([self.classIfy isEqualToString:@"0"]) //医疗美容
            {
                arr =  [MYGongLueListModle objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            
            }else if ([self.classIfy isEqualToString:@"1"])//生活美容
            {
                arr =  [MYGongLueListModle objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            }else{
                
                arr =  [MYGongLueListModle objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            }
            self.listArr = (NSMutableArray*)arr;
        }else{
            [MBProgressHUD showError:@"没有搜索到数据"];
        }
        [self.tableview reloadData];
        [self.tableview.header endRefreshing];
        self.page =1;
    } failure:^(NSError *error) {
        [self.tableview.header endRefreshing];
    }];
    }
}

#pragma mark --上啦加载
-(void)setupMoreData
{
    if(self.searchbar.text.length ==0)
    {
        [self.tableview.footer endRefreshing];
        
    }else{
    self.page++;
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
    prama[@"title"] = self.searchbar.text;
    prama[@"page"] = @(self.page);
    prama[@"type"] = self.TYPE;
    prama[@"classIfy"] = self.classIfy;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kOuternet1,self.URL] params:prama success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"-106" ])
        {
//            [MBProgressHUD showError:@"没有更多数据"];
            [self.tableview.footer endRefreshingWithNoMoreData];
            self.tableview.footer.hidden = YES;
            
        }else if ([responseObject[@"status"] isEqualToString:@"success" ]) {
 
            NSArray *arr ;
            if ([self.TYPE isEqualToString:@"0"]) //聊聊
            {
                arr =  [MYRandonChatModle objectArrayWithKeyValuesArray:responseObject[@"publishList"]];
            }else if([self.TYPE isEqualToString:@"1"])//提问
            {
                arr =  [MYRequestModle objectArrayWithKeyValuesArray:responseObject[@"publishList"]];
                
            }else if ([self.classIfy isEqualToString:@"0"]) //医疗美容
            {
                arr =  [MYGongLueListModle objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
                
            }else if ([self.classIfy isEqualToString:@"1"])//生活美容
            {
                arr =  [MYGongLueListModle objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            }else{
                
                arr =  [MYGongLueListModle objectArrayWithKeyValuesArray:responseObject[@"diaryLists"]];
            }
            [self.listArr addObjectsFromArray:arr];
            
        }
        [self.tableview reloadData];
        [self.tableview.footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableview.footer endRefreshing];
    }];
    }
}

#pragma mark-- 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.TYPE isEqualToString:@"0"]) //聊聊
    {
       MYRandomChatTableViewCell* cell = [MYRandomChatTableViewCell cellWithTableView:tableView indexPath:indexPath];
        if (indexPath.row==0) {
            cell.boomview.hidden = YES;
        }
        cell.randomchatmodle = self.listArr[indexPath.row];
   return cell;
    }else if([self.TYPE isEqualToString:@"1"])//提问
    {
        MYRequestTableViewCell *cell = [MYRequestTableViewCell cellWithTableView:tableView indexPath:indexPath];
        
        cell.questModle = self.listArr[indexPath.row];

           return cell;
    }else if ([self.classIfy isEqualToString:@"0"]) //医疗美容
    {
        MYGongLueCell*cell = [MYGongLueCell cellwithTableview:tableView indexPath:indexPath];
        if(indexPath.row==0)
        {
            cell.boomview.hidden = YES;
        }
        cell.listmodle = self.listArr[indexPath.row];

           return cell;
    }else if ([self.classIfy isEqualToString:@"1"])//生活美容
    {
        MYGongLueCell*cell = [MYGongLueCell cellwithTableview:tableView indexPath:indexPath];
        if(indexPath.row==0)
        {
            cell.boomview.hidden = YES;
        }
        cell.listmodle = self.listArr[indexPath.row];
   return cell;
    }else{
        MYGongLueCell* cell = [MYGongLueCell cellwithTableview:tableView indexPath:indexPath];
        cell.listmodle = self.listArr[indexPath.row];
           return cell;
    }

 
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.TYPE isEqualToString:@"0"]) //聊聊
    {
            return 295;
    }else if([self.TYPE isEqualToString:@"1"])//提问
    {
         return 50;
    }else if ([self.classIfy isEqualToString:@"0"]) //医疗美容
    {
          return 247;
    }else if ([self.classIfy isEqualToString:@"1"])//生活美容
    {
         return 247;
    }else{
        
        return  247;
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [self.searchbar endEditing:YES];
    
    if (self.searchbar.text.length ==0||self.listArr.count==0) {
        self.tableview.footer.hidden =  YES;

    }else{
        self.tableview.footer.hidden = NO;
    
    }
    
}

-(void)clickback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchtext:(NSNotification*)noti
{
    self.searchtext = noti.userInfo[@"searchtext"];
    
    [self requestData];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([self.TYPE isEqualToString:@"0"]) //聊聊
    {
        MYArticleViewController *detailVC = [[MYArticleViewController alloc] init];
        detailVC.deleteBlock = ^(){
            
            MYRandonChatModle *model = self.listArr[indexPath.row];
            [self.listArr removeObject:model];
            [self.tableview reloadData];
            
        };
        MYRandonChatModle *model = self.listArr[indexPath.row];
        detailVC.id = model.id;
        detailVC.headImage = model.homePic;
        detailVC.Path = @"1";
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if([self.TYPE isEqualToString:@"1"])//提问
    {
        MYQuestionViewController *detailVC = [[MYQuestionViewController alloc] init];
        detailVC.deleteBlock = ^(){
            
            MYRequestModle *model = self.listArr[indexPath.row];
            [self.listArr removeObject:model];
            [self.tableview reloadData];
            
        };
        
        MYRequestModle *model = self.listArr[indexPath.row];
        detailVC.id = model.id;
        detailVC.Path = @"1";
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if ([self.classIfy isEqualToString:@"0"]) //医疗美容
    {
        
        MYDetailViewController *detailVC = [[MYDetailViewController alloc] init];
        MYGongLueListModle *model = self.listArr[indexPath.row];
        detailVC.id = model.id;
        detailVC.topPic = model.homePagePic;
        [self.navigationController pushViewController:detailVC animated:YES];

        
    }else if ([self.classIfy isEqualToString:@"1"])//生活美容
    {
        MYDetailViewController *detailVC = [[MYDetailViewController alloc] init];
        MYGongLueListModle *model = self.listArr[indexPath.row];
        detailVC.id = model.id;
        detailVC.topPic = model.homePagePic;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        
        MYDetailViewController *detailVC = [[MYDetailViewController alloc] init];
        MYGongLueListModle *model = self.listArr[indexPath.row];
        detailVC.id = model.id;
        detailVC.topPic = model.homePagePic;
        [self.navigationController pushViewController:detailVC animated:YES];
        
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
