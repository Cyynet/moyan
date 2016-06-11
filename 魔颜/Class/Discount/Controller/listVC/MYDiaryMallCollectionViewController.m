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



@interface MYDiaryMallCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic) UICollectionView *collectionView;
@property(strong,nonatomic) NSMutableArray *arr;


@end

@implementation MYDiaryMallCollectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = MYColor(242, 242, 242);
    
    //不要忘记初始化；
    self.arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 9; i++) {
        [self.arr addObject:[UIImage imageNamed:[[NSString alloc] initWithFormat:@"%d",i + 1]]];
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 40 ) collectionViewLayout:flowLayout];
    
    [self.collectionView registerClass:[MYDiaryMallListCell class] forCellWithReuseIdentifier:@"MyCollectionCell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MYDiaryMallListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionCell" forIndexPath:indexPath];
    cell.imageView.image = [self.arr objectAtIndex:indexPath.row];
    return cell;
}

//组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"========%ld---",(long)indexPath.row);
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 30) / 2, (SCREEN_WIDTH - 30) / 2 );
}
//cell的整体位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}



@end

