//
//  WQCategoryView.m
//  魔颜
//
//  Created by 周文静 on 15/9/23.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYCategoryView.h"
#import "MYCategoryBtn.h"
#import "UIView+Extension.h"

#import "MYHomeSeactionControllerViewController.h"

@interface MYCategoryView ()

@end
//医院 美容院  卖场 医生 部位
@implementation MYCategoryView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addBtnWithTitle:@"医院" imageName:@"hospital" seaction:(@selector(clickHospatalBtn))];
        [self addBtnWithTitle:@"美容院" imageName:@"meirongyuan.jpg" seaction:@selector(clickCharacterBtn)];
        [self addBtnWithTitle:@"卖场" imageName:@"handbag(2)" seaction:@selector(clickMallBtn)];
        [self addBtnWithTitle:@"医生" imageName:@"suxingshi" seaction:@selector(clickDoctorBtn)];
        [self addBtnWithTitle:@"部位" imageName:@"item" seaction:@selector(clickseactionBtn)];
    }
    return self;
}

//记得改label字体
-(void)addBtnWithTitle:(NSString *)title imageName:(NSString *)imageName seaction:(SEL)seaction
{
    MYCategoryBtn *btn = [MYCategoryBtn addbtn];
    btn.titleLabel.text = title;
    btn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
    btn.imageView.image = [UIImage imageNamed:imageName];
    [btn.clickBtn addTarget:self action:seaction forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    
}
-(void)clickseactionBtn
{
    
    
    if ([self.Seactiondelegate respondsToSelector:@selector(clickSeactionBtn)]) {
        [self.Seactiondelegate clickSeactionBtn];
        
    }
    
}
-(void)clickDoctorBtn
{
    
    if ([self.Doctordelegate respondsToSelector:@selector(clickDoctorBtn)]) {
        [self.Doctordelegate clickDoctorBtn];
    }
}
-(void)clickHospatalBtn
{
    if ([self.Hospitaldelegate respondsToSelector:@selector(clickHosptialBtnaddVC)]) {
        [self.Hospitaldelegate clickHosptialBtnaddVC];
    }
    
}
-(void)clickMallBtn
{
    
    if ([self.Malldelegate respondsToSelector:@selector(clickMallBtnaddVC)]) {
        [self.Malldelegate clickMallBtnaddVC];
    }
}
-(void)clickCharacterBtn
{
    if ([self.Charaterdelegate respondsToSelector:@selector(clickCharacterBtnaddVC)]) {
        [self.Charaterdelegate clickCharacterBtnaddVC];
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (MYScreenW  >= 414) {
        
        for (int i = 0; i < self.subviews.count ; i++) {
            MYCategoryBtn *btn = (MYCategoryBtn *)self.subviews[i];
            
            btn.frame = CGRectMake(i * MYScreenW * 0.2 + 5, 0, MYScreenW, self.height );
            
        }
        
    }
    
    else if(MYScreenW >= 375){
        
        for (int i = 0; i < self.subviews.count ; i++) {
            MYCategoryBtn *btn = (MYCategoryBtn *)self.subviews[i];
            
            btn.frame = CGRectMake(i * MYScreenW * 0.2 , 0, MYScreenW, self.height );
        }
    }
    else if(MYScreenW >= 320)
    {
        for (int i = 0; i < self.subviews.count ; i++) {
            MYCategoryBtn *btn = (MYCategoryBtn *)self.subviews[i];
            
            btn.frame = CGRectMake(i * MYScreenW * 0.2 - 6, 0, MYScreenW, self.height );
            
            
        }
        
    }
}


@end
