//
//  MYBeautyServiceController.m
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYBeautyServiceController.h"
#import "MYCollectionLikeCell.h"
#import "MYCollectionHeadView.h"
#import "MYBeautyHeadView.h"

#import "MYServiceLike.h"
#import "MYTagTool.h"
#import "UILabel+Extension.h"

#import "MYCollectionViewCell.h"
#import "MYCollectionListCell.h"
#import "MYCollectionLikeCell.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYLifeSecondViewController.h"

#import "MYColumnViewController.h"

#import "MYLifeSecondViewController.h"

#import "MYHomeNewFormMoreBtnCollectionViewController.h"
#import "FmdbTool.h"
#import "MYPicModel.h"
#import "MYHeader.h"

@interface MYBeautyServiceController ()

/** <#注释#> */
@property (strong, nonatomic) MYCollectionHeadView *collectionHeadView;

///** banner图 */
//@property (strong, nonatomic) NSArray *adArr;

/** 广告图 */
@property (strong, nonatomic) MYPicModel *picModel;

/** 大图跟小图 */
@property (strong, nonatomic) NSArray *dataArr;

//抢购
@property(strong,nonatomic) NSArray * expand;

/** 猜你喜欢数据 */
@property (strong, nonatomic) NSArray *likeArr;

@property(strong,nonatomic) FmdbTool * fmdb;
@property(strong,nonatomic) NSString * freshBool;

@end

static NSString * const bigCell = @"indentify";
static NSString * const smallCell = @"indentify1";
static NSString * const ID = @"indentify2";

static NSString * const headView = @"HeaderView";
static NSString * const titleHeadView = @"titleHeadView";

@implementation MYBeautyServiceController

- (NSArray *)dataArr
{
    if (!_dataArr) {
        
        _dataArr = [NSArray array];
        
    }
    return _dataArr;
}

- (NSArray *)likeArr
{
    if (!_likeArr) {
        
        _likeArr = [NSArray array];
        
    }
    return _likeArr;
}

-(instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 10;
#pragma mark -- 头尾部大小设置
//        [flowLayout setHeaderReferenceSize:CGSizeMake(MYScreenW, 180)];
        // flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0 , 5);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FmdbTool *fmdb = [[FmdbTool alloc]init];
    self.fmdb = fmdb;
    [fmdb createFMDBTable:@"meirongfuwu"];
  
    self.collectionView.backgroundColor = [UIColor whiteColor];

    NSMutableDictionary *dict = [fmdb checkoutdata:@"meirongfuwu"];
    if (dict.count) {
        
        self.dataArr = [MYSalonModel objectArrayWithKeyValuesArray:dict[@"toparr"]];
        self.likeArr = [MYServiceLike objectArrayWithKeyValuesArray:dict[@"boomarr"]];
        self.picModel = [MYPicModel objectWithKeyValues:dict[@"meirongAd"]];
        self.expand = dict[@"qianggou"];
        if(self.expand.count){
            [self.collectionView sizeToFit];
        }
        
    }else{
      
        self.freshBool =  @"yes";
    }
    [ self refreshdata];

    self.collectionView.height = self.view.height - 85;
    
#pragma mark -- 注册单元格
    [self.collectionView registerClass:[MYCollectionViewCell class] forCellWithReuseIdentifier:bigCell];
    [self.collectionView registerClass:[MYCollectionListCell class] forCellWithReuseIdentifier:smallCell];
    [self.collectionView registerClass:[MYCollectionLikeCell class] forCellWithReuseIdentifier:ID];
#pragma mark -- 注册头部视图
    [self.collectionView registerClass:[MYCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headView];
    [self.collectionView registerClass:[MYBeautyHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:titleHeadView];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"empty"];
}

#pragma mark--刷新
-(void)refreshdata
{
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (![self.freshBool isEqualToString:@"yes"]) {
            
            
        }else{
            
            [self.collectionView.header beginRefreshing];
        }
    });

}

-  (void)initData
{
   
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"ver"] = MYVersion;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/newSalon/toNewSalonSpe",kOuternet1] params:param success:^(id responseObject) {

        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"success"]) {
            
            [self.fmdb deleteData:@"meirongfuwu"];
            
            self.picModel = [MYPicModel objectWithKeyValues:responseObject[@"salonSPEAD"]];
            
            self.dataArr = [MYSalonModel objectArrayWithKeyValuesArray:responseObject[@"querySalonSpeTypeList"]];
            
            self.likeArr = [MYServiceLike objectArrayWithKeyValuesArray:responseObject[@"queryUserLike"]];
            NSArray *expand = responseObject[@"salonExpand"];
            self.expand = expand;
            
            [self.fmdb addDataInsetTable:responseObject[@"salonSPEAD"] listArr1:responseObject[@"salonExpand"] listArr2:responseObject[@"querySalonSpeTypeList"] listArr3:responseObject[@"queryUserLike"] page:1000 type:@"meirongfuwu"];
            
            if(self.expand.count){
                [self.collectionView sizeToFit];
            }
            [self.collectionView reloadData];
        }
        [self.collectionView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.collectionView.header endRefreshing];

    }];

    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.dataArr.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section < self.dataArr.count) {
        return 4;
    }else{
        return self.likeArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section < self.dataArr.count) {
        
        if (indexPath.row  == 0) {
            
            MYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bigCell forIndexPath:indexPath];
            cell.salonMode = self.dataArr[indexPath.section];
            cell.backgroundColor = UIColorFromRGB(0xf7f7f7);
            return cell;
            
        }else{
            
            MYCollectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:smallCell forIndexPath:indexPath];
            MYSalonModel *model = self.dataArr[indexPath.section];
            MYSalonListModel *listModel = model.speList[indexPath.row - 1];
            cell.salonListMode = listModel;
            
            return cell;
        }
    }else{
        
        MYCollectionLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.serviceLike = self.likeArr[indexPath.row];

        if (indexPath.row== 0) {
            
            cell.line.hidden = YES;
        }
        return cell;
    
    }
    

}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
        if (kind == UICollectionElementKindSectionHeader) {
            if (indexPath.section == 0) {
                //定制头部视图的内容
                MYCollectionHeadView *headerV = (MYCollectionHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headView forIndexPath:indexPath];
                
                if (self.picModel.id) {
                    
                    headerV.pic =  self.picModel.pic;
                    headerV.beautyAd = ^(){
                        
                        MYHomeHospitalDeatilViewController *hopstionVC = [[MYHomeHospitalDeatilViewController alloc]init];
                        
                        hopstionVC.id = self.picModel.id;
                        hopstionVC.tag = 2;
                        hopstionVC.titleName = self.picModel.title;
                        hopstionVC.url = self.picModel.url;
                        [self.navigationController pushViewController:hopstionVC animated:YES];
                    
                    
                    };
                    
                }
                
                headerV.beautyBlock = ^(NSArray *tagArr,UIButton *btn){
                    
                    if (btn.tag) {
//                        MYLog(@"您点击的id是%ld",(long)id);
                        
                        MYHomeNewFormMoreBtnCollectionViewController *moreVC = [[MYHomeNewFormMoreBtnCollectionViewController alloc] init];
                        moreVC.modle = btn.tag;
                        moreVC.section = 0;
                        moreVC.titleName = btn.titleLabel.text;
                        [self.navigationController pushViewController:moreVC animated:YES];
                        
                    }
                    else{
                        MYColumnViewController *vc = [[MYColumnViewController alloc] init];
                        vc.myBlock = ^(NSArray *selecedArr){
                            
                            
                            [MYTagTool saveBeauty:selecedArr];
                               //刷新section
                             [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                            
                        };
                        NSArray *selectedArray = tagArr;
                        NSArray *tempArr = [MYTagTool arrayWithString:@"beauty.plist"];
                        
                        NSMutableArray *allArray = [NSMutableArray array];
                        
                        for (NSDictionary *dict in tempArr) {
                            [allArray addObject:dict[@"title"]];
                        }
                        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",tagArr];
                        //从全部数据中过滤掉已经筛选过的数组
                        NSArray *optionalArray = [allArray filteredArrayUsingPredicate:filterPredicate];
                        
                        
                        [vc.selectedArray addObjectsFromArray:selectedArray];
                        [vc.optionalArray addObjectsFromArray:optionalArray];
                        [self.navigationController presentViewController:vc animated:YES completion:nil];
                        
                    }
                };

                if (self.expand.count) {
                    headerV.salonExpand = self.expand;
                }
                
                reusableView = headerV;
            } else if(indexPath.section == self.dataArr.count) {
                
                MYBeautyHeadView *headerV = (MYBeautyHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:titleHeadView forIndexPath:indexPath];
                reusableView = headerV;

            }else{
                reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"empty" forIndexPath:indexPath];
    
            }
    }
    return reusableView;

}

#pragma mark --UICollectionViewDelegateFlowLayout 组头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.picModel.id && self.expand.count) {
            return CGSizeMake(self.view.width, MYScreenW / 2.0 + 100 + MYScreenW / 2.5);
        }else if (self.picModel.id && !self.expand.count){
            return CGSizeMake(self.view.width,100 + MYScreenW / 2.5);
        }else if (!self.picModel && self.expand.count){
            return CGSizeMake(self.view.width,MYScreenW / 2.0 + 90);
        }else{
            return CGSizeMake(self.view.width,80+kMargin);
        }
    }else if (section == self.dataArr.count){
        return CGSizeMake(MYScreenW,50);
    }else{
        return  CGSizeMake(self.view.width,0.00001);
    }
    
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.dataArr.count) {
        
        if (indexPath.row == 0) {
            return CGSizeMake(self.view.width,MYScreenW / 2.5 + 20);
        }else{
            return CGSizeMake((self.view.width - 40) / 3,MYScreenW / 2.46+5);
        }
    }else{
         return CGSizeMake(self.view.width ,124+20);
     }
    
}

//cell的整体位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(0, 10, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView  deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section < self.dataArr.count) {
        
        if (indexPath.row == 0) {
            
            MYLifeSecondViewController *secondVC = [[MYLifeSecondViewController alloc] init];
            MYSalonModel *modle = self.dataArr[indexPath.section];
            secondVC.type = modle.type;
            secondVC.titlename = modle.typeName;
            [self.navigationController pushViewController:secondVC animated:YES];
            
        }else{
            
            MYHomeHospitalDeatilViewController *hopstionVC = [[MYHomeHospitalDeatilViewController alloc]init];
            
            MYSalonModel *model = self.dataArr[indexPath.section];
            MYSalonListModel *listModel = model.speList[indexPath.row - 1];
            
            hopstionVC.id= listModel.id;
            hopstionVC.tag = 6;
            hopstionVC.titleName = listModel.title;
            hopstionVC.imageName = listModel.listPic;
            [self.navigationController pushViewController:hopstionVC animated:YES];

        
        }
    }
    else{
        
        MYHomeHospitalDeatilViewController *hopstionVC = [[MYHomeHospitalDeatilViewController alloc]init];
        
        MYServiceLike *listModel = self.likeArr[indexPath.row];
        hopstionVC.id= listModel.id;
        hopstionVC.tag = 6;
        hopstionVC.titleName = listModel.title;
        hopstionVC.imageName = listModel.listPic;
        [self.navigationController pushViewController:hopstionVC animated:YES];

    
    }
    
    
}

@end
