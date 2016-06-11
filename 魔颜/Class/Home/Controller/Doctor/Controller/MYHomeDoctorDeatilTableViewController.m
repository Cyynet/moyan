//
//  MYDroctionDeatilTableViewController.m
//  魔颜
//
//  Created by abc on 15/9/28.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYHomeDoctorDeatilTableViewController.h"

#import "MYHomeDoctorDeatilView.h"

#import "doctordeatilListModel.h"
#import "doctorCaseList.h"
#import "MYLoginViewController.h"
#import "MYHeader.h"


@interface MYHomeDoctorDeatilTableViewController ()<UIScrollViewDelegate,clickOrganizationcontentPushVc,doctordeatilHeight,UITableViewDataSource,UITableViewDelegate>

@property(assign,nonatomic) CGFloat   doctordeatilheight;

@property (strong, nonatomic) UITableView *doctorDeatilTableView;
@property (weak, nonatomic) UIView *doctorDetailView;
@property (strong, nonatomic) NSArray *caseLists;

@property (weak, nonatomic) UIView *topView;
@property (weak, nonatomic) UIView *boomView;
@property (weak, nonatomic) UIButton *attentionBtn;


@property(strong,nonatomic)  doctordeatilListModel *doctordeatileData;


//关注
@property(strong,nonatomic) NSString * focusStatus;


@end

@implementation MYHomeDoctorDeatilTableViewController

- (NSArray *)caseLists
{
    if (!_caseLists) {
        _caseLists = [NSArray array];
    }
    return _caseLists;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"医生详情"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick endLogPageView:@"医生详情"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    导航条
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupAddTopViewBar];
    //    添加下面的viewbar
    [self requestdoctordeatildata];
    
}

//添加tableview视图
-(void)setupTableView
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor whiteColor];
    tableview.dataSource = self;
    tableview.scrollEnabled = YES;
    self.doctorDeatilTableView = tableview;
    [self.view addSubview:tableview];
    
}

/*
 @brief 请求数据
 */

-(void)requestdoctordeatildata
{
    AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc]init];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.id;
    param[@"hospitalId"] = self.hospitalId;
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    [manger GET: [NSString stringWithFormat:@"%@doctor/queryDoctorInfoById",kOuternet1] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.focusStatus = responseObject[@"focusStatus"];
        
        //       暂时不需要 相关案例
        //    self.caseLists = [doctorCaseList objectArrayWithKeyValuesArray:responseObject[@"caseList"]];
        doctordeatilListModel *newdeatildata = [doctordeatilListModel objectWithKeyValues:responseObject[@"doctorInfo"]];
        
        self.doctordeatileData = newdeatildata;
        
        //请求完数据再加载详情视图
        [self setupTableViewData:newdeatildata];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)setupTableViewData:(doctordeatilListModel *)newdeatildata
{
    
    [self setupTableView];
    [self setupAddBoomView];
    [self setupAddTopViewBar];
    
    MYHomeDoctorDeatilView *doctorView = [[MYHomeDoctorDeatilView alloc]init];
    self.doctorDetailView = doctorView;
    doctorView.organizationdelegate = self;
    doctorView.doctordeatilheigt = self;
    doctorView.frame = CGRectMake(0, 0, self.view.width, self.doctordeatilheight);
    [self.view addSubview:doctorView];
    //给详情赋值
    doctorView.doctordeatileModel = newdeatildata;
    
    
    self.doctorDeatilTableView.tableHeaderView = doctorView;
    [self.doctorDeatilTableView reloadData];
    [self.doctorDeatilTableView setNeedsLayout];
    [self.doctorDeatilTableView layoutIfNeeded];
}
//从View传回tableViewHead的高度
-(void)toVcdoctordeatilHeight:(double)height
{
    self.doctorDetailView.frame =  CGRectMake(0, 0, MYScreenW, height);
    self.doctorDeatilTableView.height = self.view.height ;
    
    self.doctorDeatilTableView.tableHeaderView = self.doctorDetailView;
}

//导航条
-(void)setupAddTopViewBar
{
    UIView *topview = [[UIView alloc]init];
    topview.frame = CGRectMake(0, 0, MYScreenW, 64);
    self.topView = topview;
    [self.view addSubview:topview];
    
    UIImageView *doctordeatiltopbackimage = [[UIImageView alloc]initWithFrame:topview.bounds];
    doctordeatiltopbackimage.image =[UIImage imageNamed:@"topshadow.9"];
    [topview addSubview:doctordeatiltopbackimage];
    
    UIButton *dotordeatilbackbtn = [[UIButton alloc]init];
    [dotordeatilbackbtn setImage:[UIImage imageNamed:@"back-1"] forState:UIControlStateNormal];
    dotordeatilbackbtn.frame = CGRectMake(15, 35, 10, 15);
    [dotordeatilbackbtn addTarget:self action:@selector(clickdoctordeatilbackbtn) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:dotordeatilbackbtn];
    UIButton *btn = [[UIButton alloc]init];
    [topview addSubview:btn];
    btn.frame = CGRectMake(0, 0, 100, 80);
    [btn addTarget:self action:@selector(clickdoctordeatilbackbtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
//下面的视图
-(void)setupAddBoomView
{
    
    UIView *BoomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 40, MYScreenW, 40)];
    //    BoomView.backgroundColor = MYColor(240, 240, 240);
    //    self.boomView = BoomView;
    [self.view addSubview:BoomView];
    
    
    //  关注
    UIButton *guanzhubtn = [[UIButton alloc]init];
    self.attentionBtn = guanzhubtn;
    guanzhubtn.frame = CGRectMake(0 , 0, MYScreenW, 40);
    [guanzhubtn setTitle:@"关注" forState:UIControlStateNormal];
    guanzhubtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0];
    guanzhubtn.backgroundColor = MYColor(193, 177, 122);
    [guanzhubtn setTitleColor:MYColor(247, 245, 237) forState:UIControlStateNormal];
    [guanzhubtn addTarget:self action:@selector(clickguanzhubtn:) forControlEvents:UIControlEventTouchUpInside];
    [BoomView addSubview:guanzhubtn];
    
    int intString = [self.focusStatus intValue];
    
    if (intString == 0) {
        
        guanzhubtn.selected = NO;
        
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        
    }else
    {
        guanzhubtn.selected = NO;
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
}
//选择状态
- (void)clickguanzhubtn:(UIButton *)btn
{
    if (MYAppDelegate.isLogin)
    {
        
        if (btn.selected) {
            
            [self canceltAttentionList:btn];
            
        }else{
            
            [self getAttentionList:btn];
            
        }
    }else{
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc]init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
    
}
//关注
- (void)getAttentionList:(UIButton *)btn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    params[@"type"] = @"2";
    params[@"attentionId"] = self.id;
    params[@"msecs"] = [MYStringFilterTool getTimeNow];
    params[@"signature"] = [MYStringFilterTool getSignature];
    
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@diary/focusDiary",kOuternet1] params:params success:^(id responseObject) {
        btn.selected = YES;
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
        
    }];
}
//取消关注
- (void)canceltAttentionList:(UIButton *)btn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    params[@"type"] = @"2";
    params[@"attentionId"] = self.id;
    params[@"msecs"] = [MYStringFilterTool getTimeNow];
    params[@"signature"] = [MYStringFilterTool getSignature];
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@diary/cancelFocusDiary",kOuternet1] params:params success:^(id responseObject) {
        btn.selected = NO;
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
        
    }];
}

/*
 @brief 返回
 */
-(void)clickdoctordeatilbackbtn
{
    
    [self.topView removeFromSuperview];
    [self.boomView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.caseLists.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.doctorDeatilTableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}





@end
