//
//  MYSearchMoreController.m
//  魔颜
//
//  Created by Meiyue on 15/11/27.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYSearchMoreController.h"

#import "MYTieziModel.h"
#import "doctorListModel.h"
#import "designerListModel.h"
#import "hospitaleListModel.h"
#import "MYDiscountListModel.h"
#import "MYLifeSecondModle.h"


#import "MYTieziMyCell.h"
#import "MYHomeDoctorListCell.h"
#import "MYLifeSecondTableViewCell.h"
#import "MYHomeDesignerListCell.h"
#import "MYHomeHospitalListCell.h"
#import "MYProgectCell.h"

#import "MYDetailViewController.h"
#import "MYHomeDoctorDeatilTableViewController.h"
#import "MYHomeDesignerDeatilTableViewController.h"
#import "MYHomeHospitalDeatilViewController.h"

#define topviewframe CGRectMake(MYScreenW-60, MYScreenH - 80, 50, 50)

@interface MYSearchMoreController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *
    type =  0  帖子
    type =  1  医生
    type =  2  设计师
    type =  3  医院
    type =  4  特惠
    type =  5  美容院
    type =  6  美容院活动
 *
 */


/*
 @brief 五个列表
 */
@property (strong, nonatomic) NSArray *tieziLists;

@property (strong, nonatomic) NSArray *doctorLists;

@property (strong, nonatomic) NSArray *designLists;

@property (strong, nonatomic) NSArray *hospitalLists;

@property (strong, nonatomic) NSArray *discountLists;

@property (strong, nonatomic) NSArray *beautyLists;

@property (strong, nonatomic) NSArray *beautyActivityLists;

@property (weak, nonatomic) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property(strong,nonatomic) UIButton * topview;

@end

@implementation MYSearchMoreController

-(void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear: YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    [self setupTableView];
    [self reloadMore];
    
    self.page = 2;
    
    
    UIView *headerview = [[UIView alloc]init];
    headerview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerview];
    headerview.frame = CGRectMake(0, 0, MYScreenW, 50);
    
    UILabel *headerlable = [[UILabel alloc]init];
    [headerview addSubview:headerlable];
    headerlable.frame = CGRectMake((MYScreenW - 250)/2 - 20 , 20, 250, 30);
    headerlable.layer.borderColor = subTitleColor.CGColor;
    headerlable.layer.borderWidth = 0.5;
    headerlable.layer.masksToBounds = YES;
    headerlable.layer.cornerRadius = 3;
    headerlable.font = leftFont;
    headerlable.textColor = titlecolor;
    headerlable.textAlignment = NSTextAlignmentCenter;
    headerlable.text = [NSString stringWithFormat:@"搜索: %@",self.keyText];
    headerlable.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *quxiaobtn = [[UIButton alloc]init];
    [headerview addSubview:quxiaobtn];
    [quxiaobtn addTarget:self action:@selector(clickquxiaoBtn) forControlEvents:UIControlEventTouchUpInside];
    quxiaobtn.frame = CGRectMake((MYScreenW - 250)/2 + 250 -10, 20, 30, 30);
    [quxiaobtn setTitle:@"取消" forState:UIControlStateNormal];
    quxiaobtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0];
    [quxiaobtn setTitleColor:titlecolor forState:UIControlStateNormal];
    
    //置顶控件
    [self addGotoTopView];

    

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

//返回
-(void)clickquxiaoBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestData
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms[@"content"] = self.keyText;
    parms[@"page"] = @"2";
    parms[@"searchTable"] = @(self.type);
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@search/querySearchContent",kOuternet1] params:parms success:^(id responseObject) {
        
        if (self.type == 0) {
            self.tieziLists = [MYTieziModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];

        }else if (self.type == 1){
            self.doctorLists = [doctorListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
        }else if (self.type == 2){
        
            self.designLists = [designerListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
        }else if (self.type == 3){
            self.hospitalLists = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];

        }else if (self.type == 4){
            self.discountLists = [MYDiscount objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
        }else if (self.type == 5){
            self.beautyLists = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
        }else{
            self.beautyActivityLists = [MYLifeSecondModle objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
        }

        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
  }

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 35, self.view.width, self.view.height-30);
    tableView.delegate = self;
    tableView.dataSource = self;
     self.tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.type == 0) {
        return self.tieziLists.count;
    }else if (self.type == 1){
        return self.doctorLists.count;
    }else if (self.type == 2){
        return self.designLists.count;
    }else if (self.type == 3){
        return self.hospitalLists.count;
    }else if (self.type == 4){
        return self.discountLists.count;
    }else if (self.type == 5){
        return self.beautyLists.count;
    }else {
        return self.beautyActivityLists.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == 0) {
        MYTieziMyCell *cell = [MYTieziMyCell cellWithTableView:tableView indexPath:indexPath];
        MYTieziModel  *model = self.tieziLists[indexPath.row];
        cell.tieziModel = model;
        return cell;
        
    }else if (self.type == 1){
        
        MYHomeDoctorListCell *cell = [MYHomeDoctorListCell cellWithTableView:tableView indexPath:indexPath] ;
        doctorListModel *doctlistmode = self.doctorLists[indexPath.row];
        cell.doctorListMode = doctlistmode;
        return cell;
        
        
    }else if (self.type == 2){
        
        
        MYHomeDesignerListCell *cell = [MYHomeDesignerListCell cellWithTableView:tableView indexPath:indexPath];
        designerListModel *model = self.designLists[indexPath.row];
        cell.designerModel = model;
        return cell;
        
        
    }else if (self.type == 3){
        
        MYHomeHospitalListCell *cell = [MYHomeHospitalListCell cellWithTableView:tableView indexPath:indexPath];
        cell.controlerStyle = UIControlerStyleHospital;
        hospitaleListModel *model = self.hospitalLists[indexPath.row];
        cell.hospitalmodel = model;
        return cell;
        
    }else if (self.type == 4){
        
        MYProgectCell *cell = [MYProgectCell progectCell];
        cell.progect = self.discountLists[indexPath.row];
        return cell;
        
    }else if (self.type == 5){
    
        MYHomeHospitalListCell *cell = [MYHomeHospitalListCell cellWithTableView:tableView indexPath:indexPath];
        
        cell.controlerStyle = UIControlerStyleSalon;
        hospitaleListModel *model = self.beautyLists[indexPath.row];
        cell.hospitalmodel = model;
        return cell;
        
    }else{
        
        MYLifeSecondTableViewCell *cell = [MYLifeSecondTableViewCell cellWithTableView:tableView index:indexPath];
        MYLifeSecondModle *modle = self.beautyActivityLists[indexPath.row];
        
        cell.lifenmodle = modle;
        return cell;
    
    }


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        return 125;
    }else if (self.type == 2){
        return 125;
    }else if (self.type == 3){
        return 120;
    }else if (self.type == 4){
        return 120;
    }else if (self.type == 5){
        return 120;
    }else if (self.type == 6){
        return 120;
    }else{
        
        UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == 0) {
        
        MYTieziModel  *model = self.tieziLists[indexPath.row];
        MYDetailViewController *circleDeatilVC = [[MYDetailViewController alloc]init];
        circleDeatilVC.id = model.id;

        [self.navigationController pushViewController:circleDeatilVC animated:YES];
    }else if (self.type == 1){
        
        MYHomeDoctorDeatilTableViewController *DoctorDeatilVC = [[MYHomeDoctorDeatilTableViewController alloc]init];
        doctorListModel *doctermodel = self.doctorLists[indexPath.row];
        DoctorDeatilVC.id = doctermodel.id;
        [self.navigationController pushViewController:DoctorDeatilVC animated:YES];
        
    }else if (self.type == 2){
        
        MYHomeDesignerDeatilTableViewController *designerdeatilVC =[[ MYHomeDesignerDeatilTableViewController alloc]init];
        [self.navigationController pushViewController:designerdeatilVC animated:YES];
    }else if (self.type == 3){
        MYHomeHospitalDeatilViewController  *hospitaleDeatilVC = [[MYHomeHospitalDeatilViewController alloc]init];
        [self.navigationController pushViewController:hospitaleDeatilVC animated:YES];
        hospitaleListModel *model = self.hospitalLists[indexPath.row];
        hospitaleDeatilVC.id = model.id;
        hospitaleDeatilVC.latitude = model.latitude;
        hospitaleDeatilVC.longitude = model.longitude;
        
    }else if (self.type == 4){
        
        MYHomeHospitalDeatilViewController *deatilevc = [[MYHomeHospitalDeatilViewController alloc]init];
        MYDiscountListModel  *model = self.discountLists[indexPath.row];
        deatilevc.tag = 1;
        deatilevc.id = model.id;
        [self.navigationController pushViewController:deatilevc animated:YES];
    }else if (self.type == 5){
        
        MYHomeHospitalDeatilViewController  *hospitaleDeatilVC = [[MYHomeHospitalDeatilViewController alloc]init];
        hospitaleListModel *hospitalemodel = self.beautyLists[indexPath.row];
        hospitaleDeatilVC.id = hospitalemodel.id;
        
        hospitaleDeatilVC.latitude = hospitalemodel.latitude;
        hospitaleDeatilVC.longitude = hospitalemodel.longitude;
        
        hospitaleDeatilVC.titleName = hospitalemodel.name;
        hospitaleDeatilVC.imageName = hospitalemodel.listPic;
        hospitaleDeatilVC.character = hospitalemodel.feature;
        //    0 美容院付过费的    1没有
        if ([hospitalemodel.type isEqualToString:@"0"]) {
            hospitaleDeatilVC.tag = 5;
        }else{
            hospitaleDeatilVC.tag = 4;
        }
        [self.navigationController pushViewController: hospitaleDeatilVC animated:YES];
    }else {
        
        MYHomeHospitalDeatilViewController *hosptionVC = [[MYHomeHospitalDeatilViewController alloc]init];
        MYLifeSecondModle *modle = self.beautyActivityLists[indexPath.row];
        hosptionVC.id = modle.id;
        hosptionVC.tag = 6;
        hosptionVC.titleName = modle.title;
        hosptionVC.imageName = modle.listPic;
        hosptionVC.character = modle.desc;
        [self.navigationController pushViewController:hosptionVC animated:YES];
    }
}

//上拉加载更多-----
- (void)setupMoreData
{
    self.page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    params[@"content"] = self.keyText;
    params[@"searchTable"] = @(self.type);
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@search/querySearchContent",kOuternet1] params:params success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            
            [self.tableView.footer endRefreshingWithNoMoreData];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.footer endRefreshing];
        }else{
            
            if (self.type == 0) {
                self.tieziLists = [MYTieziModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
                [(NSMutableArray *)self.tieziLists  addObjectsFromArray:self.tieziLists];
                
            }else if (self.type == 1){
                
                self.doctorLists = [doctorListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
                 [(NSMutableArray *)self.doctorLists  addObjectsFromArray:self.doctorLists];
            }else if (self.type == 2){
                
                self.designLists = [designerListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
                
                  [(NSMutableArray *)self.designLists  addObjectsFromArray:self.designLists];
            }else if (self.type == 3){
                self.hospitalLists = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
                 [(NSMutableArray *)self.hospitalLists  addObjectsFromArray:self.hospitalLists];
                
            }else if (self.type == 4){
                self.discountLists = [MYDiscount objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
                 [(NSMutableArray *)self.discountLists  addObjectsFromArray:self.discountLists];
            }else if (self.type == 5){
                self.beautyLists = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
                [(NSMutableArray *)self.beautyLists  addObjectsFromArray:self.beautyLists];
            }else{
                self.beautyActivityLists = [MYLifeSecondModle objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
                 [(NSMutableArray *)self.beautyActivityLists  addObjectsFromArray:self.beautyActivityLists];
            }

            [self.tableView reloadData];
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.footer endRefreshing];
        
        }
        
    } failure:^(NSError *error) {
        
        MYLog(@"%@",error);
        [self.tableView.footer endRefreshing];
    }];
    
}

//置顶控件
-(void)addGotoTopView
{
    UIButton *topview = [[UIButton alloc]initWithFrame:topviewframe];
    self.topview = topview;
    [self.view addSubview:topview];
    [topview setImage:[UIImage imageNamed:@"totop"] forState:UIControlStateNormal];
    [topview addTarget:self action:@selector(clickTopbtn) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickTopbtn
{
    [self.tableView setContentOffset:CGPointMake(0, -7.5) animated:YES];

}

/**
 *  让组头停留
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y <= 1600)
    {
        self.topview.hidden = YES;
        
    }else{
        self.topview.hidden = NO;
    }
}





@end
