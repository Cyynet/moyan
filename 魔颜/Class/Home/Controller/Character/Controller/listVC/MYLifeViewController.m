
//
//  MYLeftViewController.m
//  魔颜
//
//  Created by Meiyue on 16/2/19.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYLifeViewController.h"
#import "MYCollectionViewCell.h"
#import "MYCollectionListCell.h"
#import "MYSalonModel.h"
#import "MYSalonListModel.h"
#import "MYLifeSecondViewController.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MobClick.h"
@interface MYLifeViewController ()

@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) NSArray *smallArr;


@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * str;
@property(strong,nonatomic) NSString * freshBool;

@end

static NSString * const reuseIdentifier = @"Cell";
static NSString * const ID = @"indentify";

@implementation MYLifeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"促销活动"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"促销活动"];
    
}
- (NSArray *)dataArr
{
    if (!_dataArr) {
        
        _dataArr = [NSArray array];
        
    }
    return _dataArr;
}

- (NSArray *)smallArr
{
    if (!_smallArr) {
        
        _smallArr = [NSArray array];
        
    }
    return _smallArr;
}


-(instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
            flowLayout.minimumLineSpacing = 10;
            flowLayout.minimumInteritemSpacing = 10;
//            flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0 , 5);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = MYColor(245, 245, 245);
    self.collectionView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
    [self.collectionView registerClass:[MYCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[MYCollectionListCell class] forCellWithReuseIdentifier:ID];

    if ([self.vctag isEqualToString:@"1"]) {
        self.collectionView.height = MYScreenH - 64 ;
    }else if([self.vctag isEqualToString:@"TAG"])
    {
        self.collectionView.height = MYScreenH - 64 - 40;

    }else{
    self.collectionView.height = MYScreenH - 64 - 40-50;
    }
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
    
    NSString *str  =  [_fmdb createFMDBTable:@"activelist"];
    self.str = str;
    
    NSArray *dataarr =  [fmdb outdata:@"activelist"];
    if (dataarr.count) {
        
        NSArray *newdotordata = [MYSalonModel  objectArrayWithKeyValuesArray:dataarr];
        
        self.dataArr = (NSMutableArray *)newdotordata;
        
    }else{
        
        //下拉刷新-----------------------------------
        [self setupRefresh];
        self.freshBool =  @"yes";
    
    }
     [self setupRefresh];
   
}

- (void)setupRefresh
{
    //下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestLists)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self.freshBool isEqualToString:@"yes"]) {
            
        }else{
        
            [self.collectionView.header beginRefreshing];
        }
    });

}

- (void)requestLists
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"ver"] = MYVersion;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@salonSpe/queryNewSalonSpeTypeList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.collectionView.footer endRefreshingWithNoMoreData];
            
        }else{
            
            [self.fmdb deleteData:@"activelist"];
            
            self.dataArr = [MYSalonModel objectArrayWithKeyValuesArray:responseObject[@"querySalonSpeTypeList"]];
            [self.collectionView reloadData];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.collectionView.header endRefreshing];

            if ([self.str isEqualToString:@"yes"]) {
                
                [self.fmdb addDataInsetTable:responseObject[@"querySalonSpeTypeList"] page:1 datacount:nil type:@"activelist"];
            }else{
                
                return ;
            }
        }
        
    } failure:^(NSError *error) {
        
        [self.collectionView.header endRefreshing];
    }];
 
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        MYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.salonMode = self.dataArr[indexPath.section];
        return cell;
        
    }else{
        MYCollectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        MYSalonModel *model = self.dataArr[indexPath.section];
        MYSalonListModel *listModel = model.speList[indexPath.row - 1];
        cell.salonListMode = listModel;
    
        return cell;
    }
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 4 == 0) {
        return CGSizeMake(self.view.width,MYScreenW / 2.78);
    }else{
        return CGSizeMake((self.view.width - 40) / 3,MYScreenW / 2.46);
    }
}
//cell的整体位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 0);
}
////cell的最小行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
////cell的最小列间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView  deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        MYLifeSecondViewController *secondVC = [[MYLifeSecondViewController alloc] init];
        MYSalonModel *modle = self.dataArr[indexPath.section];
        secondVC.type = modle.type;
        secondVC.titlename = modle.typeName;
        [self.navigationController pushViewController:secondVC animated:YES];

    }else
    {
        MYHomeHospitalDeatilViewController *hopstionVC = [[MYHomeHospitalDeatilViewController alloc]init];
        
        MYSalonModel *model = self.dataArr[indexPath.section];
        MYSalonListModel *listModel = model.speList[indexPath.row - 1];

        hopstionVC.id= listModel.id;
        hopstionVC.tag = 6;
        hopstionVC.titleName = listModel.title;
        hopstionVC.imageName = listModel.listPic;
        hopstionVC.character = @"";
        
        [self.navigationController pushViewController:hopstionVC animated:YES];
        
    }
    
}



@end
