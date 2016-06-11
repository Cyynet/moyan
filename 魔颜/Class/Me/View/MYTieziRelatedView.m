//
//  MYTieziRelatedView.m
//  魔颜
//
//  Created by Meiyue on 16/1/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYTieziRelatedView.h"
#import "MYRelatedBtn.h"
#import <QuartzCore/QuartzCore.h>
#import "MYHeader.h"


#define COUNT 3
#define MaxCols 3
#define picMargin 25
#define picWidth  ((MYScreenW - picMargin * (MaxCols + 1)) / MaxCols)

@interface MYTieziRelatedView ()

@property (strong, nonatomic) MYRelatedBtn *releatedBtn;

@property (strong, nonatomic) NSMutableArray *doctArr;
@property (strong, nonatomic) NSMutableArray *speArr;

/**
 *  工作年限
 */
@property (weak, nonatomic) UILabel *experienceLab;

@property (copy, nonatomic) NSString *id;

@property (nonatomic, assign) CGFloat lastHeight;

@end

@implementation MYTieziRelatedView

- (NSMutableArray *)doctArr
{
    if (!_doctArr) {
        _doctArr = [NSMutableArray array];
    }
    return _doctArr;
}

- (NSMutableArray *)speArr
{
    if (!_speArr) {
        _speArr = [NSMutableArray array];
    }
    return _speArr;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
     for (int i = 0; i < COUNT; i ++) {
        
        MYRelatedBtn *btn = [[MYRelatedBtn alloc] init];
         btn.tag = i + 1;
         btn.type = MYDOCTORTYPE;
        self.releatedBtn = btn;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.doctArr addObject:btn];
         
    }
    
    
    for (int i = 0; i < COUNT; i ++) {
        
        MYRelatedBtn *btn = [[MYRelatedBtn alloc] init];
        btn.tag = i + 3;
        btn.type = MYDISCOUNTTYPE;
        self.releatedBtn = btn;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.speArr addObject:btn];
        
    }

}

- (void)setDoctorItem:(NSArray *)doctorItem
{
    _doctorItem = doctorItem;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kMargin, MYScreenW - MYMargin, 0.6)];
    [self addSubview:lineView];
    [self drawDashLine:lineView lineLength:5 lineSpacing:5 lineColor:MYColor(193, 177, 122)];
    
    UILabel *label = [UILabel addLabelWithFrame:CGRectMake((MYScreenW - 110) / 2, 0, 105, 20) title:@"【 最擅长的医生 】" titleColor:MYColor(193, 177, 122) font:leftFont];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    [self addSubview:label];

    
    CGFloat btnW = picWidth;
    CGFloat btnH = btnW;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    for (int i = 0; i < COUNT; i++) {
        
        MYRelatedBtn *btn = self.doctArr[i];

        if (i >= doctorItem.count) {
            
            btn.hidden = YES;
            
        }else{
             btn.hidden = NO;
            // 显示出来,下载
            SDWebImageManager *imageManager = [[SDWebImageManager alloc]init];
            [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,[doctorItem[i] objectForKey:@"listPic"]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    
                    [btn setImage:image forState:UIControlStateNormal];
                }
            }];
            
            NSString *name = [NSString stringWithFormat:@"%@ %@",[doctorItem[i] objectForKey:@"name"],[doctorItem[i] objectForKey:@"qualification"]];
            [btn setTitle:name forState:UIControlStateNormal];
            
            int col = i % MaxCols;
            btnX = picMargin + col * (picMargin + btnW);
            btnY = 30;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            self.lastHeight = btn.bottom + 40;
           
            
            /**工作经验*/
            UILabel *experienceLab = [UILabel addLabelWithFrame:CGRectMake(btn.right - 15, btn.top + 5, MYMargin, MYMargin) title:[doctorItem[i] objectForKey:@"workexp"] titleColor:[UIColor whiteColor] font:leftFont];
            experienceLab.textAlignment = NSTextAlignmentCenter;
            experienceLab.backgroundColor = MYColor(193, 177, 122);
            experienceLab.layer.cornerRadius = MYMargin / 2;
            experienceLab.layer.masksToBounds = YES;
            [self addSubview:experienceLab];
            
            UILabel *year = [UILabel addLabelWithFrame:CGRectMake(btn.right - 10, btn.top + 22, 15, 15)  title:@"年" titleColor:MYColor(193, 177, 122) font:leftFont];
            year.textAlignment = NSTextAlignmentCenter;
            [self addSubview:year];
             btn.id = [NSString stringWithFormat:@"%@",[doctorItem[i] objectForKey:@"id"]];
           }
    }

}


- (void)setSpecialItem:(NSArray *)specialItem
{
    _specialItem = specialItem;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, self.lastHeight, MYScreenW - MYMargin, 0.6)];
    [self addSubview:lineView];
    [self drawDashLine:lineView lineLength:5 lineSpacing:5 lineColor:MYColor(193, 177, 122)];

    UILabel *label = [UILabel addLabelWithFrame:CGRectMake((MYScreenW - 110) / 2, self.lastHeight - kMargin, 105, 20) title:@"【 相关优质服务 】" titleColor:MYColor(193, 177, 122) font:leftFont];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    [self addSubview:label];

    
    CGFloat btnW = picWidth;
    CGFloat btnH = btnW;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    for (int i = 0; i < COUNT; i++) {
        
        MYRelatedBtn *btn = self.speArr[i];
        
        if (i >= specialItem.count) {
            
            btn.hidden = YES;
            
        }else{
            
            btn.hidden = NO;
            // 显示出来,下载
            SDWebImageManager *imageManager = [[SDWebImageManager alloc]init];
            [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,[specialItem[i] objectForKey:@"smallPic"]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    [btn setImage:image forState:UIControlStateNormal];
                    btn.imageURL = [imageURL absoluteString];
                }
                
            }];
            
            NSString *name;
            
            name = [specialItem[i] objectForKey:@"title"];
            NSArray  *arr = [name componentsSeparatedByString:@" "];
            name = arr[0];
            if (name.length > 10) {
               name = [name substringToIndex:9];
            }
            [btn setTitle:name forState:UIControlStateNormal];
            
            int col = i % MaxCols;
            btnX = picMargin + col * (picMargin + btnW);
            btnY = self.lastHeight + 20;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.id = [NSString stringWithFormat:@"%@",[specialItem[i] objectForKey:@"id"]];

            
            UILabel *pricelable = [[UILabel alloc]init];
            pricelable.textAlignment = NSTextAlignmentCenter;
            pricelable.textColor  = UIColorFromRGB(0xf00000);
            NSString * pricestr = [specialItem[i] objectForKey:@"discountPrice"];
            pricelable.text = [NSString stringWithFormat:@"¥%@",pricestr];
            pricelable.frame = CGRectMake(btnX-5-5, btn.bottom + 25, btnW/2+2+9, 15);
            pricelable.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
            [self addSubview:pricelable];

            
            
            UILabel *allprice = [[UILabel alloc]init];
            allprice.textAlignment = NSTextAlignmentLeft;
            allprice.textColor = UIColorFromRGB(0x000000);
            NSString *allpricestr = [NSString stringWithFormat:@"¥%@",[specialItem[i] objectForKey:@"price"]];
            allprice.text = allpricestr;
            allprice.frame = CGRectMake(btnX+btnW/2+2, pricelable.y, btnW/2+10+5+5, 15);

            allprice.alpha = 0.5;
            allprice.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
            [self addSubview:allprice];

            
            //画删除线
            [allprice setCenterLineWithColor:titlecolor];
//            NSUInteger length = [allpricestr length];
//            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:allpricestr];
//            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
//            [attri addAttribute:NSStrikethroughColorAttributeName value:titlecolor range:NSMakeRange(0, length)];
//            [allprice setAttributedText:attri];
            
        }
    }

}

- (void)clickBtn:(MYRelatedBtn *)btn
{    
    if (self.myBlock) {
        self.myBlock(btn.type,btn.id,btn.titleLabel.text,btn.imageURL);
    }
}

- (void)setupDoctorFrame
{
    CGFloat btnW = (MYScreenW - MYMargin * (MaxCols + 1)) / MaxCols;
    CGFloat btnH = btnW;
    CGFloat btnX = 0;
    CGFloat btnY = MYMargin;
    
    if (self.doctorItem.count) {
        
    
         for (int i = 0; i < COUNT; i++) {
            
             MYRelatedBtn *btn = self.doctorItem[i];
             int col = i % MaxCols;
             btnX = MYMargin + col * (MYMargin + btnW);
             btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
         }
    }
 
}

- (void)setupspecialFrame
{
    CGFloat btnW = (MYScreenW - MYMargin * (MaxCols + 1)) / MaxCols;
    CGFloat btnH = btnW;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    if (self.specialItem.count) {
          
        for (int i = 0; i < COUNT; i++) {
            
            MYRelatedBtn *btn = self.specialItem[i];
            int col = i % MaxCols;
            btnX = MYMargin + col * (MYMargin + btnW);
            btnY = 50 + btnH;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }
        
    }
  
}



@end
