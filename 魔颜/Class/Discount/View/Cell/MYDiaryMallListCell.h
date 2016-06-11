//
//  MYDiaryMallListCell.h
//  魔颜
//
//  Created by abc on 16/2/19.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYHomeStoreDiaryModle.h"

@interface MYDiaryMallListCell : UICollectionViewCell

@property(strong,nonatomic) UIImageView *imageView;
@property(strong,nonatomic) UIImageView * smallimage;

@property(strong,nonatomic) UILabel *descLabel;
@property(strong,nonatomic) UILabel * namelable;

@property(strong,nonatomic) UILabel * pricelable;

@property(strong,nonatomic) UILabel * allpricelable;

@property(strong,nonatomic) MYHomeStoreDiaryModle * diarymodle;

@end
