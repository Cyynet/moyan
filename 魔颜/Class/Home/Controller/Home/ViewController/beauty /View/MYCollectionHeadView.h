//
//  MYCollectionHeadView.h
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MYBeautyBlock)(NSArray *tagArr,UIButton *btn);

//typedef void(^MyBtnBlock)(NSInteger btnIndex);

typedef void(^MYBeautyAd)();

@interface MYCollectionHeadView : UICollectionReusableView

@property (retain, nonatomic) NSArray * showItems;

/** 广告图 */
@property (copy, nonatomic) NSString *pic;
/** 抢购 */
@property (strong, nonatomic) NSArray *salonExpand;


//@property (copy, nonatomic)   MyBtnBlock btnIndex;

@property (copy, nonatomic) MYBeautyAd beautyAd;

@property (copy, nonatomic) MYBeautyBlock beautyBlock;

@end
