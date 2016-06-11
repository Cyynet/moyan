//
//  MYPositionView.m
//  魔颜
//
//  Created by Meiyue on 15/10/19.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYPositionView.h"

#define kPicutreW ((MYScreenW - 10 - 60 - 40 - 4 * kMargin) / 2)
#define kPicutreH (kPicutreW + 30)

@interface MYPositionView ()

@property (weak, nonatomic) UILabel *detailTextLabel;
@property (weak, nonatomic) UIImageView *pictrueView;

@property (strong, nonatomic) MYPositionBtn *positionBtn;

@end

@implementation MYPositionView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        for (int i = 0; i < 9; i ++ ) {
            
            self.userInteractionEnabled = YES;
        
            MYPositionBtn *btn = [[MYPositionBtn alloc] init];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.positionBtn = btn;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.tag = i;
            
            [self addSubview:btn];
        
        }
    }
    return self;
}

- (void)setSecondCode:(NSInteger)secondCode
{
    _secondCode = secondCode;
    self.positionBtn.secondCode = secondCode;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    for (int i = 0; i < 9; i++) {
        
        MYPositionBtn *btn = self.subviews[i];
        //        self.positionBtn.secondCode = self.secondCode;
        
        if (i >= items.count) {
            
            btn.hidden = YES;
            
        }else{
            btn.secondCode = self.secondCode;
            
            btn.itme = items[i];
            btn.hidden = NO;
        }
    }
}

+(CGSize)sizeWithItemsCount:(NSUInteger)count
{
    // 最大列数
    NSUInteger maxCols = 2;
    
    // 总行数   总数  一行显示3个  显示多少行
    NSUInteger totalRows = (count + maxCols - 1) / maxCols;
    // 总列数   1
    CGFloat postionViewW = (kPicutreW + kMargin) * 2 + kMargin;
    CGFloat postionViewH = kPicutreH * totalRows + kMargin * (totalRows + 1);
    
    return CGSizeMake(postionViewW, postionViewH);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.items.count; i++) {
        
        MYPositionBtn *btn = self.subviews[i];
        
        // 列号
        int col = i % 2;
        // 行号
        int row = i / 2;
        
        btn.frame = CGRectMake(col * (btn.width + MYMargin * 1.5) + MYMargin, row * (btn.height + kMargin) + kMargin, kPicutreW, kPicutreH);
        
    }
}

@end
