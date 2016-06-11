//
//  MYTableHeadView.m
//  魔颜
//
//  Created by Meiyue on 16/4/11.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYTableHeadView.h"

@implementation MYTableHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addBannerView];
        [self addMenuView];
    }
    return self;
}

- (void)addBannerView
{
    AdView *view = [AdView adScrollViewWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenW / 1.35) imageLinkURL:self.imageArr
                             placeHoderImageName:nil
                            pageControlShowStyle:UIPageControlShowStyleCenter];
    
    [self addSubview:view];
}

- (void)addMenuView
{
    MYHomeMenuView *menuView = [[MYHomeMenuView alloc] initWithFrame:CGRectMake(0, 100, MYScreenW, 100)];
    [self addSubview:menuView];
    
}




@end
