//
//  MYFloatBar.m
//  魔颜
//
//  Created by Meiyue on 16/4/13.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYFloatBar.h"
#import "UIButton+Extension.h"
#import "UIImageView+Extension.h"
#import "UILabel+Extension.h"

@interface MYFloatBar ()

@end

@implementation MYFloatBar


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
        
    }
    return self;
}

- (void)setupViews
{
    CGFloat barheight = 45;
   
    UIButton *leftBtn = [UIButton addButtonWithFrame:CGRectMake(0,0, 65, barheight) title:@"北京" backgroundColor:nil titleColor:MYRedColor font:MYFont(15) Target:self action:@selector(clickBtn:)];
    leftBtn.tag = 0;
    self.leftBtn = leftBtn;
    [self addSubview:leftBtn];
    
    //购物车
    UIButton *rightBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW-barheight, 5, barheight-10, barheight-10) image:@"bell" highImage:@"bell" backgroundColor:nil Target:self action:@selector(clickBtn:)];
    rightBtn.tag = 3;
    [self addSubview:rightBtn];
    
    //搜索框
    UIView *seachView = [[UIView alloc]initWithFrame:CGRectMake(leftBtn.right, 6, MYScreenW-leftBtn.width - rightBtn.width-10-5, barheight-12)];
    seachView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    seachView.layer.cornerRadius = 2;
    seachView.layer.masksToBounds = YES;
    [self addSubview:seachView];
    
    //放大镜
    UIImageView *searchImage = [UIImageView addImaViewWithFrame:CGRectMake(10, 9, 15, 15) imageName:@"iconfont-search"];
    [seachView addSubview:searchImage];
    
    //扫一扫
    UIButton *scanBtn = [UIButton addButtonWithFrame:CGRectMake(seachView.width-30, 2, 30, 30) image:@"scanAndScan" highImage:@"scanAndScan" backgroundColor:nil Target:self action:@selector(clickBtn:)];
    scanBtn.tag = 2;
    [seachView addSubview:scanBtn];
    
    //占位文字
    UILabel *placeLabel = [UILabel addLabelWithFrame:CGRectMake(searchImage.right +10, 2, 100, 30) title:@"查找美丽秘诀" titleColor:UIColorFromRGB(0x999999) font:MYFont(15)];
    [seachView addSubview:placeLabel];
    
    //点击直接跳转
    UIButton *jumpBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, seachView.width -scanBtn.width, seachView.height)];
    jumpBtn.tag = 1;
    [seachView addSubview:jumpBtn];
    [jumpBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];


}

- (void)clickBtn:(UIButton *)btn
{
    if (self.floatBlock) {
        self.floatBlock(btn.tag);
    }
}


@end
