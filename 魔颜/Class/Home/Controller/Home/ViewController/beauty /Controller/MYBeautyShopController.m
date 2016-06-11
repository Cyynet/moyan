//
//  MYBeautyShopController.m
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYBeautyShopController.h"
#import "hospitaleListModel.h"
#import "MYSalonSpeViewCell.h"
#import "MYSalonForFirstRowViewCell.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYTopBtn.h"
#import "MYPopView.h"
#import "MYtradingModel.h"
#import "MYAreaNames.h"

@interface MYBeautyShopController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArr;
@property(strong,nonatomic) UIView * headerview;
@property(strong,nonatomic) NSString * SalonADimage;
@property(strong,nonatomic) NSString * SalonADurl;
@property(assign,nonatomic) NSInteger  page;

@property(strong,nonatomic) UITableView * tableview;


@property(strong,nonatomic) UIView * topMenu;
@property(strong,nonatomic) NSArray * titles;
@property (weak, nonatomic) UIView *lastView;
@property (weak, nonatomic) UIButton *lastBtn;
@property(strong,nonatomic) MYTopBtn * topBtn;
@property(strong,nonatomic) MYPopView * popView;

/** 全部项目 */
@property (strong, nonatomic) NSMutableArray *areaNames;

/**项目选择  */
@property (strong, nonatomic) NSMutableArray *progectArr;

@property(copy, nonatomic)  NSString  *areaId;
@property (copy, nonatomic) NSString *tradingId;

/** 分类 */
@property (copy, nonatomic) NSString *feature;

/** <#注释#> */
@property (nonatomic, assign) NSInteger leftReady;
/** <#注释#> */
@property (nonatomic, assign) NSInteger rightReady;

@property (copy, nonatomic) NSString *currentItem;

@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * freshBool;
@property(strong,nonatomic) NSString * order; //排序 人气最高 ==1

@end

//static NSString * const bigCell = @"indentify";

@implementation MYBeautyShopController

- (NSMutableArray *)progectArr
{
    if (!_progectArr) {
        _progectArr = [NSMutableArray arrayWithObject:@"全部"];
    }
    return _progectArr;
}

- (NSMutableArray *)areaNames
{
    if (!_areaNames) {
        _areaNames = [NSMutableArray array];
    }
    return _areaNames;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        
        _dataArr = [NSMutableArray array];
        
    }
    return _dataArr;
}

- (void)setupNotification
{
    /** 左边的通知 */
    [MYNotificationCenter addObserver:self selector:@selector(selectedLeftItem:) name:@"MYSecondTitleChange" object:nil];
    
    /** 右边的通知 */
    [MYNotificationCenter addObserver:self selector:@selector(selectedItem:) name:@"MYBeautyTitleChange" object:nil];
    
}
- (void)selectedLeftItem:(NSNotification *)noti
{
    MYTopBtn *topBtn = noti.userInfo[@"MYTypeBtn"];
    NSString *name = noti.userInfo[@"MYTopTitle"];
    [topBtn setTitle:name forState:UIControlStateNormal];
    self.areaId = noti.userInfo[@"MYType"];
    self.tradingId = noti.userInfo[@"MYTitle"];

    [self.tableview.header endRefreshing];
    [self refreshdata];
    self.freshBool = @"yes";
    
}

- (void)selectedItem:(NSNotification *)noti
{
    MYTopBtn *topBtn = noti.userInfo[@"MYTypeBtn"];
    self.currentItem = noti.userInfo[@"MYTopTitle"];
    [topBtn setTitle:self.currentItem forState:UIControlStateNormal];
    
    int indexPath = [noti.userInfo[@"MYTitle"] intValue];
    if (topBtn.tag==1) {
        
        if (indexPath == 0) {
            self.feature = nil;
        }else{
            self.feature = self.progectArr[indexPath];
            
        }
    }else if(topBtn.tag==2)
    {
        if (indexPath == 0) {
            self.order = nil;
        }else{
            self.order = @"1";
            
        }
    
    }else{}

    [self.tableview.header endRefreshing];
    [self refreshdata];
    self.freshBool = @"yes";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    
    [self requestAD];
    
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
    [fmdb createFMDBTable:@"meirongyuan"];
    
    
    NSMutableDictionary *dict  = [fmdb checkoutdata:@"meirongyuan"];
    if (dict.count) {
        
        //获取当前页输
        NSString *numstr = [fmdb chekoutcurrpagenum:@"meirongyuan"];
        NSInteger numpage = [numstr integerValue];
        self.page = numpage;
        
         self.dataArr = (NSMutableArray*)[hospitaleListModel objectArrayWithKeyValuesArray:dict[@"toparr"]];
        
    }else{
    
        self.freshBool = @"yes";
    }    
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    [self setupTopMenu];
    
    UITableView *tableview = [[UITableView alloc]init];
    tableview.frame = CGRectMake(0, 45, MYScreenW, MYScreenH-150);
    [self.view addSubview:tableview];
    self.tableview = tableview;
    tableview.delegate =self;
    tableview.dataSource =self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

     [self refreshdata];

    
    MYGlobalGCD(^(){
        
          [self requestMenuList];
          [self requestSortList];
        
    });
    
    [self setupNotification];
    
    
}
#pragma mark--刷新
-(void)refreshdata
{
    // header - 下拉
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requsetdata)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self.freshBool isEqualToString:@"yes"]) {
            
        }else{
            [self.tableview.header beginRefreshing];
        }
    });

    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.tableview.footer.automaticallyChangeAlpha = YES;

}
-(void)requsetdata
{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"ver"] = MYVersion;
    param[@"areaId"] = self.areaId;
    param[@"tradingId"] = self.tradingId;
    param[@"feature"] = self.feature;
    param[@"order"] =  self.order;
    param[@"page"] = @(1);
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@salon/querySalonList",kOuternet1] params:param success:^(id responseObject) {

        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"success"]) {

            if (self.areaId==nil& self.tradingId ==nil&self.feature== nil) {
                
                [self.fmdb deleteData:@"meirongyuan"];
            }
            
            self.dataArr = (NSMutableArray*)[hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"querySalonList"]];
            
            
            if (self.areaId==nil& self.tradingId ==nil&self.feature== nil) {
                
                [self.fmdb addDataInsetTable:nil listArr1:nil listArr2:responseObject[@"querySalonList"] listArr3:nil page:self.page type:@"meirongyuan"];
                
        }
           
            
            [self.tableview reloadData];
        }
        self.page = 1;
        [self.tableview.header endRefreshing];
    } failure:^(NSError *error) {
         [self.tableview.header endRefreshing];
    }];

    
}

- (void)requestAD
{
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@newSalon/toNewSalonAD",kOuternet1] params:nil success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableview.footer endRefreshingWithNoMoreData];
            
        }else{

            for (NSDictionary *dict in responseObject[@"salonAD"])
            {
                self.SalonADimage = dict[@"pic"];
                self.SalonADurl = dict[@"url"];
            }
            [self.tableview reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestMenuList
{
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@salon/queryCityList",kOuternet1] params:nil success:^(id responseObject){

        NSArray *arr = [MYAreaNames objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.areaNames addObjectsFromArray:arr];
        
        self.leftReady = 1;
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)requestSortList
{
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@salon/queryXiangmuList",kOuternet1] params:nil success:^(id responseObject){
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            [self.progectArr addObjectsFromArray:responseObject[@"xiangmu"]];
            self.rightReady = 1;
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)setupMoreData
{
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"ver"] = MYVersion;
    param[@"page"] = @(self.page) ;
    param[@"areaId"] = self.areaId;
    param[@"tradingId"] = self.tradingId;
    param[@"feature"] = self.feature;
    param[@"order"] =  self.order;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@salon/querySalonList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableview.footer endRefreshingWithNoMoreData];

        }else{
            
            NSArray *newdeatildata = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"querySalonList"]];
            
            [self.dataArr  addObjectsFromArray:newdeatildata];
            
            [self.fmdb addDataInsetTable:nil listArr1:nil listArr2:responseObject[@"querySalonList"] listArr3:nil page:self.page type:@"meirongyuan"];

            [self.tableview reloadData];
        }
        [self.tableview.footer endRefreshing];
        
    } failure:^(NSError *error) {
         [self.tableview.footer endRefreshing];
    }];

}
//顶部菜单按钮
- (void)setupTopMenu
{
    UIView *topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.width, 35)];
    self.topMenu = topMenu;
    topMenu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topMenu];
    
    UIView *driverView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 3 - 0.5, 5, 0.5, 25)];
    driverView.backgroundColor = [UIColor lightGrayColor];
    driverView.alpha = 0.4;
    [topMenu addSubview:driverView];
    
    UIView *driverView1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 3 * 2 - 0.5, 5,0.5, 25)];
    driverView1.backgroundColor = [UIColor lightGrayColor];
    driverView1.alpha = 0.4;
    [topMenu addSubview:driverView1];
    
    UIView *boomline = [[UIView alloc] initWithFrame:CGRectMake(0, topMenu.height-0.5,MYScreenW, 0.5)];
    boomline.backgroundColor = [UIColor lightGrayColor];
    boomline.alpha = 0.4;
    [topMenu addSubview:boomline];

    self.titles = @[@"地区",@"分类",@"排序"];
    for (int i = 0; i < self.titles.count; i ++) {
        
        MYTopBtn *topBtn = [[MYTopBtn alloc] init];
        if (i == 0) {
            topBtn.frame = CGRectMake(self.view.width / 3 * i -0.5, 0, self.view.width / 3, 35);
        }else{
            topBtn.frame = CGRectMake(self.view.width / 3 * i + 0.5, 0, self.view.width / 3, 35);
        }
        [topBtn setTitle:[self.titles objectAtIndex:i]];
        [topBtn addTarget:self action:@selector(clickTopBtn:)];
        topBtn.tag = i;
        self.topBtn = topBtn;
        [_topMenu addSubview:topBtn];
    }
    
}
- (void)clickTopBtn:(UIButton *)topBtn
{
    
    if (self.leftReady && self.rightReady) {
        
        self.lastBtn.selected = NO;
        topBtn.selected = YES;
        self.lastBtn = topBtn;
        
        [self.lastView removeFromSuperview];
        
        CGFloat popHeight = 0.0;
        CGFloat popWidth = 0.0;
        CGFloat popX = 0;
        MYPopView *popView = [MYPopView popViewWithTopBtn:topBtn];
        self.popView = popView;
        
        if (topBtn.tag == 0) {
            popView.showStyle = UITableViewShowStyleDouble;
            popHeight = 7 * MYRowHeight;
            popWidth = self.view.width;
        }
        
        if (topBtn.tag == 1) {
            popHeight = 6 * MYRowHeight;
            popWidth = self.view.width ;
            popX = 0;

        }
         if (topBtn.tag == 2) {
            popHeight = 2* MYRowHeight;
            popWidth = self.view.width ;
            popX = 0;
        }
        
        NSArray *rightArr =  @[@"全部项目",@"人气最高"];
        
        popView.chooseArray = [NSMutableArray arrayWithArray:@[
            self.areaNames, self.progectArr,rightArr]];
        popView.tag = 1;
        [popView showInRect:CGRectMake(popX, self.topMenu.bottom + 104, popWidth, popHeight)];
        self.lastView = popView;
    }

}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.SalonADimage) {
        
        return self.dataArr.count+1;
    }else {
        return self.dataArr.count;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.SalonADimage) {
        if (indexPath.row == 0)
        {
            MYSalonForFirstRowViewCell *cell = [MYSalonForFirstRowViewCell cellWithTableView:tableView indexPath:indexPath];
            
            cell.imageurl = self.SalonADimage ;
            return cell;
            
        }else
        {
            MYSalonSpeViewCell *cell = [MYSalonSpeViewCell cellWithTableView:tableView indexPath:indexPath];
            
            //MYsalonSpeModle *modle = self.dataArr[indexPath.row];
            
            cell.salonmodel = self.dataArr[indexPath.row-1];
            
            if (indexPath.row==1) {
                
                cell.boomview.hidden = YES;
            }
            return cell;
        }
        
    }else{
    
        MYSalonSpeViewCell *cell = [MYSalonSpeViewCell cellWithTableView:tableView indexPath:indexPath];
        
        //MYsalonSpeModle *modle = self.dataArr[indexPath.row];
        
        cell.salonmodel = self.dataArr[indexPath.row];
        
        if (indexPath.row==0) {
            
            cell.boomview.hidden = YES;
        }
        return cell;
    

    
    
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.SalonADimage) {
        if(indexPath.row ==0)
        {
            return MYScreenW / 2.5 - 10;
        }else{
            
            return 140;
        }
    }else{
//        if (indexPath.row==0) {
//            return 0;
//        }else{
           return 140;
//        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *menuview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 30)];
    menuview.backgroundColor = MYRandomColor;
    return menuview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.SalonADimage) {
        if (indexPath.row==0) {
            MYHomeHospitalDeatilViewController  *vc= [[MYHomeHospitalDeatilViewController alloc]init];
            vc.tag = 2;
            vc.imageName = self.SalonADimage;
            vc.url = self.SalonADurl;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else
        {
            MYHomeHospitalDeatilViewController  *vc= [[MYHomeHospitalDeatilViewController alloc]init];
            //        vc.tag = 4;
            hospitaleListModel *modle =  self.dataArr[indexPath.row-1];
            vc.id = modle.id;
            vc.imageName = self.SalonADimage;
            [self.navigationController pushViewController:vc animated:YES];
            
            vc.latitude = modle.latitude;
            vc.longitude = modle.longitude;
            
            vc.titleName = modle.name;
            vc.imageName = modle.listPic;
            vc.character = modle.feature;
            //    0 美容院付过费的    1没有
            if ([modle.type isEqualToString:@"0"]) {
                vc.tag = 5;
            }else{
                vc.tag = 4;
            }
            
        }
    }else{
        
     
        MYHomeHospitalDeatilViewController  *vc= [[MYHomeHospitalDeatilViewController alloc]init];
        //        vc.tag = 4;
        hospitaleListModel *modle =  self.dataArr[indexPath.row];
        vc.id = modle.id;
        vc.imageName = self.SalonADimage;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.latitude = modle.latitude;
        vc.longitude = modle.longitude;
        
        vc.titleName = modle.name;
        vc.imageName = modle.listPic;
        vc.character = modle.feature;
        //    0 美容院付过费的    1没有
        if ([modle.type isEqualToString:@"0"]) {
            vc.tag = 5;
        }else{
            vc.tag = 4;
        }
        
    
    }



}




@end
