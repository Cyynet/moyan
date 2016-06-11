//
//  MYBeautyHeadCollectionReusableView.m
//  魔颜
//
//  Created by Meiyue on 16/4/27.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYBeautyHeadView.h"
#import "MYHeader.h"

@implementation MYBeautyHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        _titleView =[[UIView alloc] init];
//        _titleView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        [self addSubview:_titleView];
        
        _titleLab = [UILabel addLabelWithFrame:CGRectMake(-1, kMargin, self.width + 2, self.height - kMargin) title:@"————  猜你喜欢  ————" titleColor:[UIColor blackColor] font:MYFont(15)];
        _titleLab.layer.borderColor = MYColor(236, 236, 236).CGColor;
        _titleLab.layer.borderWidth = 1.0;
        _titleLab.backgroundColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        
        
        UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 10)];
        [self addSubview:topview];
        topview.backgroundColor = UIColorFromRGB(0xf7f7f7);
    }
    return self;
}


@end
