//
//  HGTitleView.m
//  HiGo
//
//  Created by Think_lion on 15/7/25.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "MYBeautyMenuView.h"

@interface MYBeautyMenuView ()

@property(strong,nonatomic) NSString * type;
@end

@implementation MYBeautyMenuView

- (id)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr imageArr:(NSArray *)imageArr type:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        for (int i = 0; i < titleArr.count; i ++) {
            
            [self addButton:titleArr[i] addImage:imageArr[i] addTag:i];
            self.type = type;
         }
     }
    return self;
}


-(void)addButton:(NSString*)title addImage:(NSString *)image addTag:(NSInteger)tag
{
    UIButton *btn=[[UIButton alloc]init];
    
    if (tag == 0) {
        btn.selected = YES;
    }
    
    if (tag == 1) {
        [btn setBackgroundImage:[UIImage imageNamed:@"zuo"] forState:UIControlStateNormal];
    }
    if (tag == 2) {
        [btn setBackgroundImage:[UIImage imageNamed:@"dian"] forState:UIControlStateNormal];
    }
   
    if ([self.type isEqualToString:@"zhengxing"]) {
        
        if (tag == 3) {
            [btn setBackgroundImage:[UIImage imageNamed:@"dian"] forState:UIControlStateNormal];
        }
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
     btn.adjustsImageWhenHighlighted = NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"xuanzhongtiao"] forState:UIControlStateSelected];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.titleLabel.font = MianFont;
    [btn setTitleColor:UIColorFromRGB(0x4c4c4c) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0xcd0831)
              forState:UIControlStateSelected];
    btn.tag = tag;
    [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}

-(void)titleButtonClick:(UIButton*)btn
{
    [self didSelectedItem:btn.tag];

    if (self.titleBlock) {
        self.titleBlock(btn.tag);
    }
}


/**
 *  计算scrollView在屏幕中的偏移位置相对于sliderBar的宽度所对应的X
 */
- (void)sliderMoveToOffsetX:(CGFloat)x {
    
    [self layoutSubviews];
    
    //两个按钮中心点之间的间距
    CGFloat btnOffset = 0;
    UIButton* itemButton1 = [self.subviews firstObject];
    
    if(self.subviews.count > 1){
        UIButton* itemButton2 = [self.subviews objectAtIndex:1];
        btnOffset = itemButton2.center.x - itemButton1.center.x;
    }
    
    CGFloat offsetX = x / self.bounds.size.width * btnOffset;
    [self didSelectedItem:offsetX/btnOffset + 0.5];
    
}
/**
 *  选中Item
 */
- (void)didSelectedItem:(NSInteger)itemIndex{
    
    if (itemIndex == 0) {
        [(UIButton *)(self.subviews[1]) setBackgroundImage:[UIImage imageNamed:@"zuo"] forState:UIControlStateNormal];
        [(UIButton *)(self.subviews[2]) setBackgroundImage:[UIImage imageNamed:@"dian"] forState:UIControlStateNormal];
        if ([self.type isEqualToString:@"zhengxing"]) {
            [(UIButton *)(self.subviews[3]) setBackgroundImage:[UIImage imageNamed:@"dian"] forState:UIControlStateNormal];
        }
    }

    if (itemIndex == 1) {
        [(UIButton *)(self.subviews[0]) setBackgroundImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
        [(UIButton *)(self.subviews[2]) setBackgroundImage:[UIImage imageNamed:@"zuo"] forState:UIControlStateNormal];
        if ([self.type isEqualToString:@"zhengxing"]) {
            [(UIButton *)(self.subviews[3]) setBackgroundImage:[UIImage imageNamed:@"dian"] forState:UIControlStateNormal];
        }
    }
    
    if (itemIndex == 2) {
        [(UIButton *)(self.subviews[0]) setBackgroundImage:[UIImage imageNamed:@"dian"] forState:UIControlStateNormal];
        [(UIButton *)(self.subviews[1]) setBackgroundImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
        if ([self.type isEqualToString:@"zhengxing"]) {
        [(UIButton *)(self.subviews[3]) setBackgroundImage:[UIImage imageNamed:@"zuo"] forState:UIControlStateNormal];
        }
    }
    
    if ([self.type isEqualToString:@"zhengxing"]) {
        
        if (itemIndex == 3) {
            [(UIButton *)(self.subviews[0]) setBackgroundImage:[UIImage imageNamed:@"dian"] forState:UIControlStateNormal];
            [(UIButton *)(self.subviews[1]) setBackgroundImage:[UIImage imageNamed:@"dian"] forState:UIControlStateNormal];
            [(UIButton *)(self.subviews[2]) setBackgroundImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
        }
    }
    
    for (int i = 0; i < self.subviews.count; i++) {
        if(i != itemIndex) {
            [self.subviews[i] setSelected:NO];
            
        }else{
            [self.subviews[i] setSelected:YES];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnY= 0;
    int count= (int)self.subviews.count;
    CGFloat btnX = 0;
    CGFloat btnW = MYScreenW / count;
    CGFloat btnH = self.height;
    for(int i = 0;i < count; i++){
        btnX = btnW * i;
        UIButton *btn= self.subviews[i];
        btn.tag = i;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }

}


@end
