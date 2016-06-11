//
//  ColumnReusableView.m
//  Column
//
//  Created by fujin on 15/11/19.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import "ColumnReusableView.h"

@interface ColumnReusableView ()
@property (nonatomic, copy)ClickBlock clickBlock;

@end
@implementation ColumnReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self confingSubViews];
    }
    return self;
}
-(void)confingSubViews{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, self.bounds.size.height)];
    self.titleLabel.font = MYSFont(16);
    self.titleLabel.textColor = titlecolor;
    [self addSubview:self.titleLabel];
    
    self.clickButton = [[UIButton alloc] initWithFrame:CGRectMake(MYScreenW - 80, 10, 50, 25)];
    self.clickButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.clickButton.backgroundColor = [UIColor whiteColor];
    self.clickButton.layer.masksToBounds = YES;
    self.clickButton.layer.cornerRadius = 13;
    self.clickButton.layer.borderColor = MYRedColor.CGColor;
    self.clickButton.layer.borderWidth = 0.7;
    [self.clickButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.clickButton setTitle:@"完成" forState:UIControlStateSelected];
    [self.clickButton setTitleColor:MYRedColor forState:UIControlStateNormal];
    [self.clickButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clickButton];
}
-(void)clickWithBlock:(ClickBlock)clickBlock{
    if (clickBlock) {
        self.clickBlock = clickBlock;
    }
}
-(void)clickAction:(UIButton *)sender{
    self.clickButton.selected = !self.clickButton.selected;
    if (sender.selected) {
        self.clickBlock(StateSortDelete);
    }else{
        self.clickBlock(StateComplish);
    }
    
}
#pragma mark ----------- set ---------------
-(void)setButtonHidden:(BOOL)buttonHidden{
    if (buttonHidden != _buttonHidden) {
        self.clickButton.hidden = buttonHidden;
        _buttonHidden = buttonHidden;
    }
}
@end
