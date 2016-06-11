
//
//  MYLeftViewController.m
//  魔颜
//
//  Created by Meiyue on 16/2/19.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYLifeViewController.h"
#import "MYCollectionViewCell.h"

@interface MYLifeViewController ()

@end

static NSString * const reuseIdentifier = @"Cell";

@implementation MYLifeViewController

-(instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        //        flowLayout.minimumLineSpacing = 0;
        //        flowLayout.minimumInteritemSpacing = 0;
            flowLayout.sectionInset = UIEdgeInsetsMake(-5, 10, 0 , 10);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.height = MYScreenH - 64 - 40 ;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MYCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *name = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    
    if (indexPath.row % 4 == 0) {
        cell.imagView.hidden = NO;
        cell.imagView.image =  [UIImage imageWithName:name];
        cell.sImagView.hidden = YES;
        cell.titleLabel.hidden = YES;
    }else{

        cell.imagView.hidden = YES;
        cell.sImagView.hidden = NO;
        cell.titleLabel.hidden = NO;
        cell.sImagView.image = [UIImage imageWithName:name];
        cell.titleLabel.text = @"魔颜网";
    }
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 4 == 0) {
        return CGSizeMake(self.view.width,120);
    }else{
        return CGSizeMake(self.view.width / 3.5,80);
    }
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView  deselectItemAtIndexPath:indexPath animated:YES];
    MYLog(@"您点击的是第%ld组第%ld个按钮",(long)indexPath.section,(long)indexPath.row);
    
}



@end
