//
//  WQHomeSeactionControllerViewController.m
//  魔颜
//
//  Created by abc on 15/9/25.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYHomeSeactionControllerViewController.h"
#import "MYIntroduceViewController.h"

#import "MYPositionCell.h"
#import "MYPositionGroup.h"
#import "MYItem.h"
#import "MYHeader.h"

@interface MYHomeSeactionControllerViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) UIScrollView *scrollViewLeft;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *codes;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIButton *leftBtn;

@property (weak, nonatomic) UIButton *lastBtn;

@property (weak, nonatomic) UIButton *womenBtn;
@property (weak, nonatomic) UIButton *manBtn;

@property (strong, nonatomic) NSArray *positions;
@property (strong, nonatomic) NSArray *lastArr;

@property(nonatomic,copy) NSString *sexNum;
@property (nonatomic, assign) NSInteger firstCode;

@property(strong,nonatomic) UIButton * searchBtn;
@property(strong, nonatomic)NSString *kefuid;
@end

@implementation MYHomeSeactionControllerViewController

- (NSArray *)positions
{
    if (!_positions) {
        
        _positions = [NSArray array];
        
    }
    return _positions;
}

- (NSArray *)lastArr
{
    if (!_lastArr) {
        
        _lastArr = [NSArray array];
        
    }
    return _lastArr;
}

- (NSArray *)codes
{
    if (!_codes) {
        
        _codes = [NSArray array];
        
    }
    return _codes;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    [MobClick beginLogPageView:@"部位列表"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"部位列表"];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
      [self addbell];
    [self setupHeadMenu];
    [self setupNotification];
    [self requestLeftData];
    [self setupScrollViewLeft];
    [self setupTableView];
    
    self.sexNum = @"0";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication] .statusBarStyle = UIStatusBarStyleDefault;

}

-(void)addbell
{
    
    UIButton *rightBtn = [[UIButton alloc]init];
    self.searchBtn =rightBtn;
    rightBtn.frame = CGRectMake(MYScreenW - 40, 30, 25, 25);
    [rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

-(void)clickBell
{
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];}


- (void)setupNotification
{
    [MYNotificationCenter addObserver:self selector:@selector(detailPage:) name:@"clickPosition" object:nil];
}
- (void)detailPage:(NSNotification *)noti
{
    MYIntroduceViewController *introduceVC = [[MYIntroduceViewController alloc] init];
    introduceVC.name = noti.userInfo[@"MYPosition"];
    introduceVC.id =  [noti.userInfo[@"secondCode"] intValue];
    [self.navigationController pushViewController:introduceVC animated:YES];
}

- (void)requestLeftData
{
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@project/queryFirstInfoList",kOuternet1] params:nil success:^(id responseObject) {
        
        NSMutableArray *dataArr = [NSMutableArray array];
        NSMutableArray *code = [NSMutableArray array];
        
        for (NSDictionary *dict in responseObject[@"queryFirstInfoList"]) {
            
            [dataArr addObject:dict[@"firstLevel"]];
            [code addObject:dict[@"firstCode"]];
        }
        
        self.titles = dataArr;
        self.codes = code;
        [self setupLeftBtns];
        self.firstCode = [[self.codes firstObject] integerValue];
        [self requestData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

//上面切换按钮
- (void)setupHeadMenu
{
    UIView *navMenu = [[UIView alloc] init];
    navMenu.frame = CGRectMake(self.view.width - 170, 10, 150, 23);
    self.navigationItem.titleView = navMenu;
    
    MYMenuBtn *womenBtn = [[MYMenuBtn alloc] init];
    womenBtn.frame = CGRectMake(0, 0, 75, 23);;
    [womenBtn setTitle:@"女士"];
    [womenBtn addTarget:self action:@selector(clickWomenBtn:)];
    womenBtn.selected = YES;
    self.womenBtn = womenBtn;
    [navMenu addSubview:womenBtn];
    
    MYMenuBtn *manBtn = [[MYMenuBtn alloc] init];
    manBtn.frame = CGRectMake(74, 0, 75, 23);;
    [manBtn setTitle:@"男士"];
    [manBtn addTarget:self action:@selector(clickManBtn:)];
    self.manBtn = manBtn;
    [navMenu addSubview:manBtn];
    
}

//部位列表
- (void)setupScrollViewLeft
{
    UIScrollView *scrollViewLeft = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 50, self.view.height)];
    scrollViewLeft.delegate = self;
    scrollViewLeft.backgroundColor = UIColorFromRGB(0xf5f5f5);
    scrollViewLeft.showsHorizontalScrollIndicator = NO;
    scrollViewLeft.showsVerticalScrollIndicator = NO;
    scrollViewLeft.bounces = NO;
    self.scrollViewLeft = scrollViewLeft;
    [self.view addSubview:scrollViewLeft];
    [self setupLeftBtns];
}

//根据网络添加按钮
- (void)setupLeftBtns
{
    for (int i = 0; i < self.titles.count; i ++ ) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
        btn.frame = CGRectMake(0, 44 * i + 14.5, 50, 44);
        [btn setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:MYColor(82.0, 82.0, 82.0) forState:UIControlStateNormal];
         btn.backgroundColor = [UIColor whiteColor];
        btn.backgroundColor = UIColorFromRGB(0xf5f5f5);
        self.leftBtn = btn;
        [btn addTarget:self action:@selector(clickPosition:) forControlEvents:UIControlEventTouchUpInside];
        btn.adjustsImageWhenHighlighted = YES;
        btn.tag = i;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 0.5, btn.height, 0.5);
        lineView.backgroundColor = lineViewBackgroundColor;
        [btn addSubview:lineView];
        
        if (0 == i) {
            btn.selected = YES;
            self.lastBtn = btn;
        }
        [self.scrollViewLeft addSubview:btn];
    }
    
    self.scrollViewLeft.contentSize = CGSizeMake(0, self.titles.count * 44 + kMargin);
    
}

//展示列表
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(self.scrollViewLeft.width, 64, self.view.width - self.scrollViewLeft.width, self.view.height - 64);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
}

//点击部位
- (void)clickPosition:(UIButton *)btn
{
    
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    
    self.firstCode = [[self.codes objectAtIndex:btn.tag] integerValue];
    self.lastArr = nil;
    [self requestData];
}

//选择女士
- (void)clickWomenBtn:(UIButton *)womenBtn
{
    womenBtn.selected = YES;
    self.manBtn.selected = NO;
    self.sexNum = @"0";
    self.lastArr = nil;
    [self requestData];
    
}

//选择男士
- (void)clickManBtn:(UIButton *)manBtn
{
    manBtn.selected = YES;
    self.womenBtn.selected = NO;
    self.sexNum = @"1";
    self.lastArr = nil;
    [self requestData];
    
}

//请求数据
- (void)requestData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"sex"] = self.sexNum;
    param[@"firstCode"] = @(self.firstCode);
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@project/querySecondInfoList",kOuternet1] params:param success:^(id responseObject) {
        
        NSArray *newStatuses = [MYPositionGroup objectArrayWithKeyValuesArray:responseObject[@"querySecondInfoList"]];
        
        self.positions = newStatuses;
        
        self.lastArr = [NSArray array];
        self.lastArr = self.positions;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.positions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYPositionCell *cell = [MYPositionCell cellWithTableView:tableView index:indexPath];
    cell.groups = self.positions[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYPositionGroup *group = self.positions[indexPath.row];
    CGSize size = [MYPositionView sizeWithItemsCount:group.thirdproject.count];
    return size.height + 25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}


@end
