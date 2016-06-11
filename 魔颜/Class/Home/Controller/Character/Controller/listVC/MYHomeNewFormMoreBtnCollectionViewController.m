//
//  MYHomeNewFormMoreBtnCollectionViewController.m
//  魔颜
//
//  Created by abc on 16/4/27.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYHomeNewFormMoreBtnCollectionViewController.h"
#import "MYCollectionLikeCell.h"
#import "MYLifeSecondModle.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYOwnSpe.h"
#import "MYHosSpe.h"
#import "MYSearchViewController.h"
static NSString * const ID = @"indentify2";
@interface MYHomeNewFormMoreBtnCollectionViewController ()

@property(strong,nonatomic) NSMutableArray *dataArr;
@property(assign,nonatomic) NSInteger page;
@property(strong,nonatomic) UIButton * rightBtn;

@end

@implementation MYHomeNewFormMoreBtnCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 10;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    [self refreshRequsetData];
    self.title = self.titleName;
    
    self.collectionView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.collectionView registerClass:[MYCollectionLikeCell class] forCellWithReuseIdentifier:ID];

    [self addbell];

}

-(void)addbell
{
    UIButton *rightBtn = [[UIButton alloc]init];
    self.rightBtn =rightBtn;
    rightBtn.frame = CGRectMake(MYScreenW - 40, 30, 25, 25);
    [rightBtn setImage:[UIImage imageNamed:@"itemRIght_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:rightBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}
//小铃铛
-(void)clickBell
{
    MYSearchViewController *searchVC = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
#pragma mark--刷新
-(void)refreshRequsetData
{

    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requsetdatas)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.header beginRefreshing];
    });
    
      __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    self.collectionView.footer.automaticallyChangeAlpha = YES;
}

-  (void)requsetdatas
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.modle ==1000) {
        
    }else{
        
    param[@"mold"] = @(self.modle);
        
    }
    
    NSString *url;

    url = [NSString stringWithFormat:@"%@homePage/querySalonSpe",kOuternet1];
    
    param[@"page"] = @"1";

    [MYHttpTool postWithUrl:url params:param success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {

            if (self.section ==0) {
                
                self.dataArr = (NSMutableArray*)[MYServiceLike objectArrayWithKeyValuesArray:responseObject[@"salonSpe"]];
            }else if(self.section ==1)
            {
                self.dataArr = (NSMutableArray*)[MYServiceLike objectArrayWithKeyValuesArray:responseObject[@"hosSpe"]];
            }else {
                self.dataArr = (NSMutableArray*)[MYOwnSpe objectArrayWithKeyValuesArray:responseObject[@"ownSpe"]];
            }
            
            
            [self.collectionView reloadData];
        }
        self.page = 1;
        [self.collectionView.header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.collectionView.header endRefreshing];

    }];
    
}
#pragma mark -- 上啦加载
-(void)setupMoreData
{
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.modle ==1000) {
        
    }else{
        
        param[@"mold"] = @(self.modle);
        
    }
    
    NSString *url;
    if (self.section == 0) {
        url = [NSString stringWithFormat:@"%@homePage/querySalonSpe",kOuternet1];
    }
    else if (self.section == 1){
//        url = [NSString stringWithFormat:@"%@homePage/queryHosSpe",kOuternet1];
//        http://192.168.1.157:8080/shaping/homePage/queryHosSpe?page=1
    }
    else if (self.section == 2){
//        url = [NSString stringWithFormat:@"%@homePage/queryOwnSpe",kOuternet1];
    }
    
    param[@"page"] = @(self.page);

    [MYHttpTool postWithUrl:url params:param success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"-106"]) {
            [self.collectionView.footer endRefreshingWithNoMoreData];

        }else if ([responseObject[@"status"] isEqualToString:@"success"]) {
                
            NSArray *arr ;
            
                arr = (NSMutableArray*)[MYServiceLike objectArrayWithKeyValuesArray:responseObject[@"salonSpe"]];
           
            [self.dataArr addObjectsFromArray:arr];
                
                [self.collectionView reloadData];
            
        }
        [self.collectionView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.collectionView.footer endRefreshing];
        
    }];
    

}
#pragma  mark--代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MYCollectionLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
//    if (indexPath.row==0) {
//        
//        cell.line.hidden = YES;
//    }
    cell.serviceLike = self.dataArr[indexPath.row];

    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(MYScreenW,0);
  
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(MYScreenW,MYScreenW / 3.1+20);
    
}
//cell的整体位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(-10, 0, 0, 0);
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYHomeHospitalDeatilViewController *hopstionVC = [[MYHomeHospitalDeatilViewController alloc]init];
    
    MYServiceLike *listModel = self.dataArr[indexPath.row];
    hopstionVC.id= listModel.id;
    hopstionVC.tag = 6;
    hopstionVC.titleName = listModel.title;
    hopstionVC.imageName = listModel.listPic;
    [self.navigationController pushViewController:hopstionVC animated:YES];
    

}

@end
