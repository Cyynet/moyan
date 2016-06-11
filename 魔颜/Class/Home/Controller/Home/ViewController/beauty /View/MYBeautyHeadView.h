//
//  MYBeautyHeadCollectionReusableView.h
//  魔颜
//
//  Created by Meiyue on 16/4/27.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYBeautyHeadView : UICollectionReusableView

@property(strong,nonatomic)UIView *titleView;
//添加一个lable 用于显示内容
@property(strong,nonatomic)UILabel *titleLab;

@end
