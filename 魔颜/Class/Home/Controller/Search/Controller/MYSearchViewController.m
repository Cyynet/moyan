//
//  MYSearchViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/13.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYSearchViewController.h"
#import "MYSearchResultViewController.h"
#import "MYSearchBar.h"
#import "MYHistoryCell.h"
#import "MYHeader.h"

#define HotCols 4
#define MaxCols 5
#define KMargin 10

//历史搜索记录的文件路径
#define MYSearchHistoryPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hisDatas.data"]

@interface MYSearchViewController ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property(weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) MYSearchBar *searchBar;

//@property (weak, nonatomic) UITextField *searchBar;

@property (strong, nonatomic) NSArray *titles;

/** 热门数据模型 */
@property (nonatomic, strong) NSMutableArray *hotDatas;

/** 历史搜索数据 */
@property (nonatomic, strong) NSMutableArray *hisDatas;

@property (nonatomic, assign) NSInteger tag;

@end

@implementation MYSearchViewController

- (NSMutableArray *)hotDatas
{
    if (_hotDatas == nil) {
        
        _hotDatas = [NSMutableArray array];
    }
    return _hotDatas;
}

- (NSMutableArray *)hisDatas
{
    
    if (_hisDatas == nil) {
        
        _hisDatas = [NSMutableArray arrayWithContentsOfFile:MYSearchHistoryPath];
        
        if (_hisDatas == nil) {
            _hisDatas = [NSMutableArray array];
        }
    }
    return _hisDatas;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"搜索"];
    //文本框获取焦点
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self.searchBar becomeFirstResponder];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.hidden = NO;
    [self.view endEditing:YES];
    [MobClick endLogPageView:@"搜索"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tag = 1;
    
    [self setupSearchBar];
    [self setupTableView];
    [self requestHotData];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
 @brief 请求热门数据
 */
- (void)requestHotData
{
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@search/hotSearch",kOuternet1] params:nil success:^(id responseObject) {
        
        self.hotDatas = responseObject[@"hotSearch"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

- (void)setupSearchBar
{
    MYSearchBar *searchBar = [MYSearchBar searchBar];
    searchBar.delegate = self;
    searchBar.frame =  CGRectMake(15, 25, self.view.width - 70, 35);
    searchBar.font = leftFont;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.placeholder = @"玻尿酸美白针";
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
    btn.titleLabel.font = leftFont;
    [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(searchBar);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(35);
    }];
    
}

- (void)cancel
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
 }

-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, 75, self.view.width, self.view.height - 77);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

//监听手机键盘点击搜索的事件

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //判断是否有输入,有值的话将新的字符串添加到datas[0]中并且重新写入文件
    /* 发送请求 */
    if (textField.text.length) {
        
        for (NSString *text in self.hisDatas) {
            if ([text isEqualToString:textField.text]) {
                [self PushToResultVC:textField];
                return YES;
            }
        }
        [self.hisDatas insertObject:textField.text atIndex:0];
        [self.hisDatas writeToFile:MYSearchHistoryPath atomically:YES];
        [self.tableView reloadData];
        [self PushToResultVC:textField];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //点击屏幕搜索框失去焦点
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hisDatas.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

/*
 @brief --------------------历史搜索
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MYHistoryCell *cell = [MYHistoryCell historyCellWithTableView:tableView IndexPath:indexPath atNSMutableArr:self.hisDatas];
    cell.textLabel.font = leftFont;
    if (self.hotDatas.count == 0) {
        cell.textLabel.text = self.searchBar.text;
        cell.textLabel.font = leftFont;
        
    }else{
        
        cell.textLabel.text = self.hisDatas[indexPath.row];
    }
    
    return cell;
    
}

#pragma mark -  UITableViewDelegate
/*
 @brief ---------------------热搜
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    self.tableView.tableHeaderView = headView;
    
    //热搜
    UILabel *hotLabel = [[UILabel alloc] init];
    hotLabel.frame = CGRectMake(KMargin + 3, KMargin, 40, 25);
    hotLabel.textAlignment = NSTextAlignmentLeft;
    hotLabel.font = leftFont;
    hotLabel.textColor = titlecolor;
    hotLabel.text = @"热搜";
    [headView addSubview:hotLabel];
    
    //热门标签
    for (int i = 0; i < self.hotDatas.count; i ++ ) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        
        int col = i % HotCols;
        int row = i / HotCols;
        btn.width = (self.view.width - (HotCols + 2) * KMargin - CGRectGetMaxX(hotLabel.frame)) / 4;
        btn.height = 20;
        btn.x = col *  (btn.width + KMargin) + CGRectGetMaxX(hotLabel.frame) + KMargin;
        btn.y = KMargin + row * (btn.height + KMargin);
        btn.tag = i;
        [btn setTitle:[self.hotDatas objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickHotBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [headView addSubview:btn];
    }
    
    
    UILabel *hisLabel = [[UILabel alloc] init];
    hisLabel.frame = CGRectMake(KMargin, CGRectGetMaxY(hotLabel.frame) + MYMargin * 2, 100, 30);
    hisLabel.font = leftFont;
    hisLabel.textColor  = titlecolor;
    hisLabel.text = @"历史记录";
    [headView addSubview:hisLabel];
    
    return headView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
    
}

/*
 @brief ---------------------猜你喜欢
 */

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    footView.userInteractionEnabled = YES;
    self.tableView.tableFooterView = footView;
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake((self.view.width - 200) / 2, MYMargin, 200, 30);
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = leftFont;
    [btn setTitle:@"清除记录" forState:UIControlStateNormal];
    btn.backgroundColor =  MYColor(109, 109, 109);
    [btn addTarget:self action:@selector(clearMemory) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    
    return footView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

/*
 @brief ----------------------清除记录
 */
- (void)clearMemory
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认清除记录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.hisDatas removeAllObjects];
            
            [self.hisDatas writeToFile:MYSearchHistoryPath atomically:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
        }];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

/*
 @brief 点击热搜
 */
- (void)clickHotBtn:(UIButton *)btn
{
    [self checkOut:btn];
}

//点击热搜和猜你喜欢的判断
- (void)checkOut:(UIButton *)btn
{
    if ([self pickOut:btn]) {
        [self StepToResultVC:btn];
    }
    
}

- (BOOL)pickOut:(UIButton *)btn
{
    if (btn.titleLabel.text) {
        
        for (NSString *text in self.hisDatas) {
            
            if ([text isEqualToString:btn.titleLabel.text]) {
                return YES;
            }
        }
        [self.hisDatas insertObject:btn.titleLabel.text atIndex:0];
        [self.hisDatas writeToFile:MYSearchHistoryPath atomically:YES];
        [self.tableView reloadData];
    }
    return YES;
}

- (void)PushToResultVC:(UITextField *)textField
{
    MYSearchResultViewController *searchResultVC = [[MYSearchResultViewController alloc] init];
    searchResultVC.view.backgroundColor = [UIColor whiteColor];
    searchResultVC.searchBar.text = textField.text;
    [self.navigationController pushViewController:searchResultVC animated:YES];
    self.searchBar.text = textField.text;

}

/*
 @brief 按钮跳转
 */
- (void)StepToResultVC:(UIButton *)btn
{
    MYSearchResultViewController *searchResultVC = [[MYSearchResultViewController alloc] init];

    
    searchResultVC.view.backgroundColor = [UIColor whiteColor];
    searchResultVC.searchBar.text = btn.titleLabel.text;
    [self.navigationController pushViewController:searchResultVC  animated:YES];
    self.searchBar.text = btn.titleLabel.text;
}

/*
 @brief 点击历史记录
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MYSearchResultViewController *searchResultVC = [[MYSearchResultViewController alloc] init];
    searchResultVC.view.backgroundColor = [UIColor whiteColor];

    searchResultVC.searchBar.text = self.hisDatas[tag];
    [self.navigationController pushViewController:searchResultVC animated:YES];

    
}


@end
