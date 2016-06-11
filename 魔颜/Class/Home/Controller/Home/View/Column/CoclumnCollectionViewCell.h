//
//  CoclumnCollectionViewCell.h
//  Column
//
//  Created by fujin on 15/11/18.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeleteDelegate <NSObject>
-(void)deleteItemWithIndexPath:(NSIndexPath *)indexPath;
@end
@interface CoclumnCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign)id<DeleteDelegate> deleteDelegate;

@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIButton *deleteButton;
@property (nonatomic, strong)NSIndexPath *indexPath;
-(void)configCell:(NSArray *)dataArray withIndexPath:(NSIndexPath *)indexPath;
@end
