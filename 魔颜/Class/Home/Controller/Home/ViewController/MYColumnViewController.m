//
//  ColumnViewController.m
//  Column
//
//  Created by fujin on 15/11/18.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import "MYColumnViewController.h"
#import "CoclumnCollectionViewCell.h"
#import "ColumnReusableView.h"
#import "UIButton+Extension.h"
#import "MYHeader.h"
#define SPACE 10.0
static NSString *cellIdentifier = @"CoclumnCollectionViewCell";
static NSString *headOne = @"ColumnReusableViewOne";
static NSString *headTwo = @"ColumnReusableViewTwo";
@interface MYColumnViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DeleteDelegate>
/**
 *  collectionView
 */
@property (nonatomic, strong)UICollectionView *collectionView;
/**
 *  Whether sort
 */
@property (nonatomic, assign)BOOL isSort;
/**
 * Whether hidden the last
 */
@property (nonatomic, assign)BOOL lastIsHidden;
/**
 *  animation label（insert）
 */
@property (nonatomic, strong)UILabel *animationLabel;
/**
 *  attributes of all cells
 */
@property (nonatomic, strong)NSMutableArray *cellAttributesArray;

@end

@implementation MYColumnViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.selectedArray = [[NSMutableArray alloc] init];
        self.optionalArray = [[NSMutableArray alloc] init];
        
        self.cellAttributesArray = [[NSMutableArray alloc] init];
        
        self.animationLabel = [[UILabel alloc] init];
        self.animationLabel.textAlignment = NSTextAlignmentCenter;
        self.animationLabel.font = [UIFont systemFontOfSize:15];
        self.animationLabel.numberOfLines = 1;
        self.animationLabel.adjustsFontSizeToFitWidth = YES;
//        self.animationLabel.minimumScaleFactor = 0.1;
        self.animationLabel.textColor = MYColor(101, 101, 101);
//        self.animationLabel.layer.masksToBounds = YES;
        self.animationLabel.backgroundColor = MYBgColor;
//        self.animationLabel.layer.borderColor = MYColor(211, 211, 211).CGColor;
//        self.animationLabel.layer.borderWidth = 0.45;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setRightItem];
    [self configCollection];
}
-(void)setRightItem{
    
    UIButton *deleteBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 60, 40, 30, 30) image:@"delete" highImage:@"delete" backgroundColor:nil Target:self action:@selector(back:)];
    [self.view addSubview:deleteBtn];
}
-(void)back:(UIButton *)sender{
    
    self.isSort = NO;
    [self.collectionView reloadData];
    
    if (self.myBlock) {
        self.myBlock(self.selectedArray);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma mark ----------------- collectionInscance ---------------------
-(void)configCollection{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, MYScreenW, MYScreenH - 200) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[CoclumnCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[ColumnReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headOne];
    [self.collectionView registerClass:[ColumnReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headTwo];
    [self.collectionView reloadData];
}

- (void)todoSomething:(UIPanGestureRecognizer *)pan{
}

#pragma mark ----------------- sort ---------------------
-(void)sortItem:(UIPanGestureRecognizer *)pan{
    
    CoclumnCollectionViewCell *cell = (CoclumnCollectionViewCell *)pan.view;
    NSIndexPath *cellIndexPath = [self.collectionView indexPathForCell:cell];
    
    //开始  获取所有cell的attributes
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self.cellAttributesArray removeAllObjects];
        for (NSInteger i = 0 ; i < self.selectedArray.count; i++) {
            [self.cellAttributesArray addObject:[self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
        }
    }
    
    CGPoint point = [pan translationInView:self.collectionView];
    cell.center = CGPointMake(cell.center.x + point.x, cell.center.y + point.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.collectionView];
    
    //进行是否排序操作
    BOOL ischange = NO;
    for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
        CGRect rect = CGRectMake(attributes.center.x - 6, attributes.center.y - 6, 12, 12);
        if (CGRectContainsPoint(rect, CGPointMake(pan.view.center.x, pan.view.center.y)) & (cellIndexPath != attributes.indexPath)) {
            
            //后面跟前面交换
            if (cellIndexPath.row > attributes.indexPath.row) {
                //交替操作0 1 2 3 变成（3<->2 3<->1 3<->0）
                for (NSInteger index = cellIndexPath.row; index > attributes.indexPath.row; index -- ) {
                    [self.selectedArray exchangeObjectAtIndex:index withObjectAtIndex:index - 1];
                }
            }
            //前面跟后面交换
            else{
                //交替操作0 1 2 3 变成（0<->1 0<->2 0<->3）
                for (NSInteger index = cellIndexPath.row; index < attributes.indexPath.row; index ++ ) {
                    [self.selectedArray exchangeObjectAtIndex:index withObjectAtIndex:index + 1];
                }
            }
            ischange = YES;
            [self.collectionView moveItemAtIndexPath:cellIndexPath toIndexPath:attributes.indexPath];
        }
        else{
            ischange = NO;
        }
    }
    
    //结束
    if (pan.state == UIGestureRecognizerStateEnded){
        if (ischange) {
            
        }
        else{
            cell.center = [self.collectionView layoutAttributesForItemAtIndexPath:cellIndexPath].center;
        }
    }
}

#pragma mark ----------------- delete ---------------------
-(void)deleteItemWithIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedArray.count <= 5) {
        [MBProgressHUD showHUDWithTitle:@"至少选择5个标签" andImage:nil andTime:1.0];
        return;
    }else{
    
        //数据整理
        [self.optionalArray insertObject:[self.selectedArray objectAtIndex:indexPath.row] atIndex:0];
        [self.selectedArray removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
        //删除之后更新collectionView上对应cell的indexPath
        for (NSInteger i = 0; i < self.selectedArray.count; i++) {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            CoclumnCollectionViewCell *cell = (CoclumnCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:newIndexPath];
            cell.indexPath = newIndexPath;
        }
    }
    
}
#pragma mark ----------------- insert ---------------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    //先将未到时间执行前的任务取消。
//    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(ClickStartload:) object:indexPath];
//    [self performSelector:@selector(ClickStartload:)withObject:indexPath afterDelay:1.2f];
    
    
    if (indexPath.section == 1) {
        
        if (self.selectedArray.count >= 9) {
            [MBProgressHUD showHUDWithTitle:@"最多选择9个标签" andImage:nil andTime:1.0];
            return;
        }else{
            
            self.lastIsHidden = YES;
            CoclumnCollectionViewCell *endCell = (CoclumnCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            endCell.contentLabel.hidden = NO;
            
            [self.selectedArray addObject:[self.optionalArray objectAtIndex:indexPath.row]];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
            //移动开始的attributes
            UICollectionViewLayoutAttributes *startAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
            
            self.animationLabel.frame = CGRectMake(startAttributes.frame.origin.x, startAttributes.frame.origin.y, startAttributes.frame.size.width , startAttributes.frame.size.height);
            self.animationLabel.layer.cornerRadius = CGRectGetHeight(self.animationLabel.bounds) * 0.5;
            self.animationLabel.text = [self.optionalArray objectAtIndex:indexPath.row];
            [self.collectionView addSubview:self.animationLabel];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:self.selectedArray.count-1 inSection:0];
            
            //移动终点的attributes
            UICollectionViewLayoutAttributes *endAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:toIndexPath];
            
            typeof(self) __weak weakSelf = self;
            //移动动画
            [UIView animateWithDuration:0.4 animations:^{
                self.view.userInteractionEnabled = NO;
                
                weakSelf.animationLabel.center = endAttributes.center;
            } completion:^(BOOL finished) {
                //展示最后一个cell的contentLabel
                CoclumnCollectionViewCell *endCell = (CoclumnCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:toIndexPath];
                endCell.contentLabel.hidden = NO;
                
                weakSelf.lastIsHidden = NO;
                [weakSelf.animationLabel removeFromSuperview];
                [weakSelf.optionalArray removeObjectAtIndex:indexPath.row];
                [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                 self.view.userInteractionEnabled = YES;
            }];
        }
    }
}

#pragma mark ----------------- item(样式) ---------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((MYScreenW - (5*SPACE)) / 4.0, 30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(SPACE, SPACE, SPACE, SPACE);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return SPACE;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return SPACE;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(MYScreenW, 40.0);
    }
    else{
        return CGSizeMake(MYScreenW, 30.0);
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return  CGSizeMake(MYScreenW, 0.0);
}

#pragma mark ----------------- collectionView(datasouce) ---------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.isSort) {
        return 1;
    }
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.selectedArray.count;
    }
    else{
        return self.optionalArray.count;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ColumnReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == 0) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headOne forIndexPath:indexPath];
            reusableView.buttonHidden = NO;
            reusableView.clickButton.selected = self.isSort;
            reusableView.backgroundColor = [UIColor whiteColor];
            typeof(self) __weak weakSelf = self;
            [reusableView clickWithBlock:^(ButtonState state) {
                //排序删除
                if (state == StateSortDelete) {
                    weakSelf.isSort = YES;
                }
                //完成
                else{
                    weakSelf.isSort = NO;
                    if (weakSelf.cellAttributesArray.count) {
                        for (UICollectionViewLayoutAttributes *attributes in weakSelf.cellAttributesArray) {
                            CoclumnCollectionViewCell *cell = (CoclumnCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:attributes.indexPath];
                            for (UIPanGestureRecognizer *pan in cell.gestureRecognizers) {
                                [cell removeGestureRecognizer:pan];
                            }
                        }
                    }
                }
                [weakSelf.collectionView reloadData];
            }];
            reusableView.titleLabel.text = @"我的频道";
            
        }else{
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headTwo forIndexPath:indexPath];
            reusableView.buttonHidden = YES;
            reusableView.titleLabel.text = @"推荐频道";
        }
    }
    return (UICollectionReusableView *)reusableView;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CoclumnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        [cell configCell:self.selectedArray withIndexPath:indexPath];
        //头条
        if (indexPath.row == 0) {
           cell.deleteButton.hidden = YES;
        }else{
           cell.deleteDelegate = self;
           cell.deleteButton.hidden = !self.isSort;
            if (self.isSort) {
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sortItem:)];
                [cell addGestureRecognizer:pan];
            }
            else{
                
            }
            //最后一位是否影藏(为了动画效果)
            if (indexPath.row == self.selectedArray.count - 1) {
                cell.contentLabel.hidden = self.lastIsHidden;
            }
        }
        
    }else{
        [cell configCell:self.optionalArray withIndexPath:indexPath];
         cell.deleteButton.hidden = YES;
    }
    return cell;
}
-(void)dealloc{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
