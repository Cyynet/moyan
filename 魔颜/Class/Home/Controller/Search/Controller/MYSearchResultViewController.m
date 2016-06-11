//
//  MYSearchResultViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/13.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYSearchResultViewController.h"
#import "MYSearchBar.h"

#import "MYSearchResult.h"

#import "MYTieziModel.h"
#import "doctorListModel.h"
#import "designerListModel.h"
#import "hospitaleListModel.h"
#import "MYDiscountListModel.h"
#import "MYLifeSecondModle.h"


#import "MYTieziMyCell.h"
#import "MYHomeDoctorListCell.h"
#import "MYHomeCharaListModel.h"

#import "MYHomeHospitalListCell.h"
#import "MYLifeSecondTableViewCell.h"
#import "MYProgectCell.h"
#import "MYHomeDesignerListCell.h"
#import "MYDetailViewController.h"
#import "MYHomeDoctorDeatilTableViewController.h"
#import "MYHomeDesignerDeatilTableViewController.h"
#import "MYHomeHospitalDeatilViewController.h"

#import "MYSearchMoreController.h"
#import "MYHeader.h"

@interface MYSearchResultViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property(weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *searchList;

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

@property (weak, nonatomic) UIButton *footBtn;


@end

@implementation MYSearchResultViewController

- (NSArray *)searchList
{
    if (!_searchList) {
        _searchList = [NSArray array];
    }
    return _searchList;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    //文本框获取焦点
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self requestSearchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchBar];
    [self setupTableView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupSearchBar
{
    MYSearchBar *searchBar = [[MYSearchBar alloc]init];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    searchBar.frame =  CGRectMake(10, 20, self.view.width - 60, 35);
    searchBar.font = leftFont;
    searchBar.textColor = titlecolor;
    [self.view addSubview:searchBar];
    
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.frame = searchBar.bounds;
    [searchBar addSubview:backbtn];
    [backbtn addTarget:self action:@selector(clicksearchToback) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
-(void)clicksearchToback
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, self.view.width, self.view.height - 70) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 0;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
     tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);

}

/*
 @brief 请求搜索数据
 */
- (void)requestSearchData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"content"] =  self.searchBar.text;
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@search/querySearchContent",kOuternet1] params:params success:^(id responseObject) {
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"-106"]) {
            [MBProgressHUD showError:@"暂无相关信息"];
        }else
        {
        }
        self.searchList = [MYSearchResult objectArrayWithKeyValuesArray:responseObject[@"searchList"]];
        self.tieziLists = [MYTieziModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][0][@"searchInfo"]];
        self.doctorLists = [doctorListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][1][@"searchInfo"]];
        self.designLists = [designerListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][2][@"searchInfo"]];
        self.hospitalLists = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][3][@"searchInfo"]];
        self.discountLists = [MYDiscount objectArrayWithKeyValuesArray:responseObject[@"searchList"][4][@"searchInfo"]];
        self.beautyLists = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"searchList"][5][@"searchInfo"]];
        self.beautyActivityLists = [MYLifeSecondModle objectArrayWithKeyValuesArray:responseObject[@"searchList"][6][@"searchInfo"]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
    }];
}

- (void)cancel
{
    
    if (self.myBlock) {
        self.myBlock((NSString*)self.searchBar.text);
    }

    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.tieziLists.count;
    }else if (section == 1){
        return self.doctorLists.count;
    }else if (section == 2){
        return self.designLists.count;
    }else if (section == 3){
        return self.hospitalLists.count;
    }else if (section == 4){
        return self.discountLists.count;
    }else if (section == 5){
        return self.beautyLists.count;
    }else {
        return self.beautyActivityLists.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MYTieziMyCell *cell = [MYTieziMyCell cellWithTableView:tableView indexPath:indexPath];
        MYTieziModel  *model = self.tieziLists[indexPath.row];
        cell.tieziModel = model;
        return cell;
        
    }else if (indexPath.section == 1){
        
        
        MYHomeDoctorListCell *cell = [MYHomeDoctorListCell cellWithTableView:tableView indexPath:indexPath] ;
        doctorListModel *doctlistmode = self.doctorLists[indexPath.row];
        cell.doctorListMode = doctlistmode;
        
        return cell;
        
        
    }else if (indexPath.section == 2){
        
        MYHomeDesignerListCell *cell = [MYHomeDesignerListCell cellWithTableView:tableView indexPath:indexPath];
        
        designerListModel *model = self.designLists[indexPath.row];
        cell.designerModel = model;
        return cell;
        
    }else if (indexPath.section == 3){
        
        MYHomeHospitalListCell *cell = [MYHomeHospitalListCell cellWithTableView:tableView indexPath:indexPath];
        cell.controlerStyle = UIControlerStyleHospital;
        hospitaleListModel *model = self.hospitalLists[indexPath.row];
        cell.hospitalmodel = model;
        return cell;
        
    }else if (indexPath.section == 4){
        
        MYProgectCell *cell = [MYProgectCell progectCell];
        cell.progect = self.discountLists[indexPath.row];
        return cell;
        
    }else if (indexPath.section == 5){
        
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
    if (indexPath.section == 1) {
        return 125;
    }else if (indexPath.section == 2){
        return 125;
    }else if (indexPath.section == 3){
        return 120;
    }else if (indexPath.section == 4){
        return 120;
    }else if (indexPath.section == 5){
        return 130;
    }else if (indexPath.section == 6){
        return 120;
    }else{
        
        UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    NSInteger count = 0;
    if (section == 0) {
        count = self.tieziLists.count;
    }else if (section == 1){
        count =  self.doctorLists.count;
    }else if (section == 2){
        count =  self.designLists.count;
    }else if (section == 3){
        count =  self.hospitalLists.count;
    }else if (section == 4){
        count =  self.discountLists.count;
    }else if (section == 5){
        count =  self.beautyLists.count;
    }else{
        count =  self.beautyActivityLists.count;
    }
    
    if (count == 0){
        return nil;
    }else{
        
        UIView *footView = [[UIView alloc] init];
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake((self.view.width - 200) / 2, 0, 200, 25);
        btn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:13.0];
        [btn setTitle:@"查看更多相关项目" forState:UIControlStateNormal];
        [btn setTitleColor:MYColor(82.0, 82.0, 82.0) forState:UIControlStateNormal];
        btn.tag = section;
        [btn addTarget:self action:@selector(lookMoreViews:) forControlEvents:UIControlEventTouchUpInside];
        self.footBtn = btn;
        [footView addSubview:btn];
        return footView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    
    NSInteger count = 0;
    if (section == 0) {
        count = self.tieziLists.count;
    }else if (section == 1){
        count =  self.doctorLists.count;
    }else if (section == 2){
        count =  self.designLists.count;
    }else if (section == 3){
        count =  self.hospitalLists.count;
    }else if (section == 4){
        count =  self.discountLists.count;
    }else if (section == 5){
        count =  self.beautyLists.count;

    }else{
        count =  self.beautyActivityLists.count;
    }
    
    if (count == 0) {
        return 0.01;
    }else{
        return 30;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        MYDetailViewController *circleDeatilVC = [[MYDetailViewController alloc]init];
         MYTieziModel  *model = self.tieziLists[indexPath.row];
        circleDeatilVC.id = model.id;

        [self.navigationController pushViewController:circleDeatilVC animated:YES];
        
    }else if (indexPath.section == 1){
        
        MYHomeDoctorDeatilTableViewController *DoctorDeatilVC = [[MYHomeDoctorDeatilTableViewController alloc]init];
        doctorListModel *doctermodel = self.doctorLists[indexPath.row];
        DoctorDeatilVC.id = doctermodel.id;
        [self.navigationController pushViewController:DoctorDeatilVC animated:YES];
        
    }else if (indexPath.section == 2){
        MYHomeDesignerDeatilTableViewController *designerdeatilVC =[[ MYHomeDesignerDeatilTableViewController alloc]init];
         designerListModel *model = self.designLists[indexPath.row];
        designerdeatilVC.id = model.id;
        [self.navigationController pushViewController:designerdeatilVC animated:YES];
    }else if (indexPath.section == 3){
        MYHomeHospitalDeatilViewController  *hospitaleDeatilVC = [[MYHomeHospitalDeatilViewController alloc]init];
        [self.navigationController pushViewController:hospitaleDeatilVC animated:YES];
        hospitaleListModel *model = self.hospitalLists[indexPath.row];
        hospitaleDeatilVC.id = model.id;
        hospitaleDeatilVC.titleName = model.name;
        hospitaleDeatilVC.imageName = model.listPic;
        hospitaleDeatilVC.character = model.feature;
        hospitaleDeatilVC.latitude = model.latitude;
        hospitaleDeatilVC.longitude = model.longitude;

    }else if (indexPath.section == 4){
        
        MYHomeHospitalDeatilViewController *deatilevc = [[MYHomeHospitalDeatilViewController alloc]init];
        MYDiscountListModel  *model = self.discountLists[indexPath.row];
        deatilevc.tag = 1;
        deatilevc.id = model.id;
        [self.navigationController pushViewController:deatilevc animated:YES];
    }else if (indexPath.section == 5){
        
        MYHomeHospitalDeatilViewController  *hospitaleDeatilVC = [[MYHomeHospitalDeatilViewController alloc]init];
        hospitaleListModel *hospitalemodel = self.beautyLists[indexPath.row];
        hospitaleDeatilVC.id = hospitalemodel.id;
        [self.navigationController pushViewController: hospitaleDeatilVC animated:YES];
           
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

/*
 @brief 查看更多
 */
- (void)lookMoreViews:(UIButton *)btn
{
    MYSearchMoreController *moreVC = [[MYSearchMoreController alloc] init];
    moreVC.keyText = self.searchBar.text;
    moreVC.type = btn.tag;
    [self.navigationController pushViewController:moreVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //点击屏幕搜索框失去焦点
    [self.searchBar resignFirstResponder];
}
@end

