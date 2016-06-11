//
//  MYDiaryMallCollectionViewController.m
//  魔颜
//
//  Created by abc on 16/2/19.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYDiaryMallCollectionViewController.h"
#import "MYDiaryMallListCell.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#import "MYHomeStoreDiaryModle.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYHeader.h"
@interface MYDiaryMallCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic) UICollectionView *collectionView;
@property(strong,nonatomic) NSMutableArray *arr;

@property (nonatomic, assign) NSInteger page;

@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * str;
@property(strong,nonatomic) NSString * freshBool;
@end

@implementation MYDiaryMallCollectionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"日常护肤"];
}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"日常护肤"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //3.搜索框
    [self addSearch];
    if (self.titleName) {
        
        self.title = self.titleName;;
    }else{
        self.title = @"护肤品";
    
    }

    [self setupflowlayout];

    //    刷新
    [self refreshData];
    
    self.fmdb = [[FmdbTool alloc]init];
    
    self.str = [self.fmdb createFMDBTable:@"diary"];
    
    NSArray *arr = [self.fmdb outdata:@"diary"];
    if (arr.count) {
        NSArray *dataarr = [MYHomeStoreDiaryModle objectArrayWithKeyValuesArray:arr];
        
        self.arr = (NSMutableArray *)dataarr;
        
    }else{
        //    刷新
        [self refreshData];
        self.freshBool = @"yes";
    }

    
}

- (void)addSearch
{
    UIButton *rightBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 40, 30, 25, 25) image:@"itemRIght_search" highImage:@"itemRIght_search" backgroundColor:nil Target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
//小铃铛
-(void)search
{
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

//刷新
-(void)refreshData
{
    //下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestdata)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self.freshBool isEqualToString:@"yes"]) {
            
        }else{
        [self.collectionView.header beginRefreshing];
        }
    });
    

}

-(void)setMoreData
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMorediaryData];
    }];
    self.collectionView.footer.automaticallyChangeAlpha = YES;


}

-(void)setupMorediaryData
{

    self.page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"ver"] = MYVersion;
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/specialdeals/queryAllProduct",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.collectionView.footer endRefreshingWithNoMoreData];
        }else{
            
            NSArray *dataarr = [MYHomeStoreDiaryModle objectArrayWithKeyValuesArray:responseObject[@"allProduct"]];
            
            [self.arr  addObjectsFromArray:dataarr];
            [self.collectionView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.collectionView.footer endRefreshing];
                [self.collectionView.footer resetNoMoreData];
            });
        }
        
    } failure:^(NSError *error) {
        
        [self.collectionView.footer endRefreshing];
        [self.collectionView.footer resetNoMoreData];
    }];
    
}


-(void)setupflowlayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGRect rect;
    if ([self.TAGVC isEqualToString:@"3"])
    {
        rect = CGRectMake(0, 0, self.view.width, self.view.height-64-40-45 );
    }else if([self.TAGVC isEqualToString:@"TAG"])
    {
        rect = CGRectMake(0, 0, self.view.width, self.view.height-64-40 );
    }else{
        rect = CGRectMake(0, 0, self.view.width, self.view.height);
    }
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[MYDiaryMallListCell class] forCellWithReuseIdentifier:@"MyCollectionCell"];
    self.collectionView.backgroundColor = MYColor(244, 244, 244);
    [self.view addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    flowLayout.minimumInteritemSpacing = 5; //横向
    flowLayout.minimumLineSpacing = 5;//纵向
    
}

-(void)requestdata
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    param[@"ver"] = MYVersion;
    
    [manager GET:[NSString stringWithFormat:@"%@/specialdeals/queryAllProduct",kOuternet1] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *lastObject  = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {

            [self.collectionView.footer endRefreshingWithNoMoreData];
            
        }else{
            [self.fmdb deleteData:@"diary"];
            
            NSArray *dataarr = [MYHomeStoreDiaryModle objectArrayWithKeyValuesArray:responseObject[@"allProduct"]];
            
            self.arr = (NSMutableArray *)dataarr;
            
            if ([self.str isEqualToString:@"yes"]) {
                
                [self.fmdb addDataInsetTable:responseObject[@"allProduct"] page:1 datacount:nil type:@"diary"];
            }else
            {
                return ;
            }
            
            [self.collectionView reloadData];
            
            [self.collectionView.header endRefreshing];
        
        }
        
        self.page = 1;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       
            [self.collectionView.header endRefreshing];

    }];

}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MYDiaryMallListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionCell" forIndexPath:indexPath];
    MYHomeStoreDiaryModle *modle = self.arr[indexPath.row];
    cell.diarymodle = modle;

    return cell;
}

//组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    MYHomeHospitalDeatilViewController *hospitonVC  =[[MYHomeHospitalDeatilViewController alloc]init];
    MYHomeStoreDiaryModle *modle = self.arr[indexPath.row];
    hospitonVC.id = modle.id;
    hospitonVC.tag = 1;
    hospitonVC.titleName = modle.TITLE;
    hospitonVC.imageName = modle.listPic;
    hospitonVC.character = modle.countryTitel;
    hospitonVC.classify = modle.classify;
    [self.navigationController pushViewController: hospitonVC animated:YES];
    

    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 15) / 2, (SCREEN_WIDTH - 15) / 2+43 );
}
//cell的整体位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 0, 5);
}



@end

