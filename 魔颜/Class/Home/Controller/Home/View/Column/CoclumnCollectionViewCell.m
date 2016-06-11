//
//  CoclumnCollectionViewCell.m
//  Column
//
//  Created by fujin on 15/11/18.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import "CoclumnCollectionViewCell.h"
#import "MYHeader.h"
@implementation CoclumnCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self confingSubViews];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)confingSubViews{
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width , self.contentView.bounds.size.height)];
    self.contentLabel.center = self.contentView.center;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines = 1;
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    self.contentLabel.minimumScaleFactor = 0.1;
    self.contentLabel.backgroundColor = MYBgColor;
    [self.contentView addSubview:self.contentLabel];
    
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width , self.contentView.bounds.size.height)];
    [self.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    
    UIImageView *imagView = [UIImageView addImaViewWithFrame:CGRectMake(0, 0, 10, 10) imageName:@"delete"];
    [self.deleteButton addSubview:imagView];
    
    
}
-(void)configCell:(NSArray *)dataArray withIndexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    self.contentLabel.hidden = NO;
    self.contentLabel.text = dataArray[indexPath.row];
    if (indexPath.section == 0 & indexPath.row == 0) {
//         self.contentLabel.textColor = MYColor(214, 39, 48);
//         self.contentLabel.layer.masksToBounds = YES;
//         self.contentLabel.layer.borderColor = [UIColor clearColor].CGColor;
//         self.contentLabel.layer.borderWidth = 0.0;
    }
    else{
        self.contentLabel.textColor = MYColor(101, 101, 101);
//        self.contentLabel.layer.masksToBounds = YES;
//        self.contentLabel.layer.cornerRadius = CGRectGetHeight(self.contentView.bounds) * 0.5;
//        self.contentLabel.layer.borderColor = MYColor(211, 211, 211).CGColor;
//        self.contentLabel.layer.borderWidth = 0.45;
    }
}
-(void)deleteAction:(UIButton *)sender{
    if ([self.deleteDelegate respondsToSelector:@selector(deleteItemWithIndexPath:)]) {
        [self.deleteDelegate deleteItemWithIndexPath:self.indexPath];
    }
}
-(void)dealloc{
    for (UIPanGestureRecognizer *pan in self.gestureRecognizers) {
        [self removeGestureRecognizer:pan];
    }
}

@end
