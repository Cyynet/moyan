//
//  MYHeadView.h
//  魔颜
//
//  Created by Meiyue on 15/9/29.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYHeadView;
@protocol MYHeadViewDelegate <NSObject>

- (void)headView:(MYHeadView *)headView;

@end

@interface MYHeadView : UIView

@property (weak, nonatomic) id <MYHeadViewDelegate>delegate;


@end
