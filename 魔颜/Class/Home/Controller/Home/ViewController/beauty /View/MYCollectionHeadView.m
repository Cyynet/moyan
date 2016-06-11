//
//  MYCollectionHeadView.m
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYCollectionHeadView.h"
#import "MYTagTool.h"
#import "MYqianggouview.h"
#import "MYSortsModel.h"
#import "UIButton+Extension.h"
#import "MYHeader.h"

#define MaxCols 5
@interface MYCollectionHeadView ()

@property(weak, nonatomic) UIView *iconView;

/** 广告图 */
@property (weak, nonatomic) UIButton *imageBtn;


/** 抢购图 */
@property (weak, nonatomic) UIView *buyView;


/** 上一个按钮 */
@property (weak, nonatomic) UIButton *lastBtn;


@end

@implementation MYCollectionHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
        
        [self addUI];

    }
    return self;
}

- (void)addUI
{
    
    if (self.pic) {
        
        /** 广告按钮 */
        UIButton *btn = [UIButton addButtonWithFrame:CGRectMake(0, kMargin, MYScreenW, MYScreenW / 2.5) backgroundColor:nil Target:self action:@selector(clickAd)];
        btn.hidden = YES;
        self.imageBtn = btn;
        [self addSubview:btn];
        
    }
    
    UIView *iconView = [[UIView alloc] init];
    iconView.frame = CGRectMake(kMargin / 2, self.imageBtn.bottom + kMargin, MYScreenW - kMargin , 80);
    self.iconView = iconView;
    iconView.backgroundColor = [UIColor whiteColor];
    iconView.layer.cornerRadius = 2;
    iconView.layer.masksToBounds = YES;
    [self addSubview:iconView];
    
    NSArray *tempArray;

    if ([MYTagTool readBeautyInfo].count) {
            
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *allArray = [MYTagTool arrayWithString:@"beauty.plist"];
            NSArray *cacheArray = [MYTagTool readBeautyInfo];
            
            for(int i = 0;i < allArray.count;i ++){
                //containsObject 判断元素是否存在于数组中
                if([cacheArray containsObject:allArray[i][@"title"]]) {
                    [arr addObject:allArray[i]];
                }
            }
            tempArray = [MYSortsModel objectArrayWithKeyValuesArray:arr];
            
        }else{
            tempArray = [[MYTagTool beauties] subarrayWithRange:NSMakeRange(0, 5)];
        }
    
    NSMutableArray *allArray = [NSMutableArray array];
    for (MYSortsModel *model in tempArray) {
        [allArray addObject:model.title];
    }
    
    if (allArray.count > 9) {
        allArray = (NSMutableArray *)[allArray subarrayWithRange:NSMakeRange(0, 9)];
    }
    self.showItems = allArray;
 

    for (int i = 0; i < allArray.count + 1; i ++ ) {
        
        UIButton *tagBtn = [[UIButton alloc] init];
        tagBtn.backgroundColor = UIColorFromRGB(0xfafafa);
        
        int col = i % MaxCols;// 列号
        int row = i / MaxCols;
        tagBtn.width = (iconView.width - 6 * kMargin) / MaxCols;
        tagBtn.height = 25;
        tagBtn.x = kMargin + col * (tagBtn.width + kMargin);
        tagBtn.y = kMargin + row *  (tagBtn.height + kMargin);
        
        [tagBtn setTitleColor:titlecolor forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        tagBtn.titleLabel.font = MYFont(12);
        [tagBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setBackgroundImage:[UIImage imageNamed:@"fenbtnback"] forState:UIControlStateSelected];
        
        if (i < allArray.count) {
            MYSortsModel *model = tempArray[i];
            tagBtn.tag = model.id;
            [tagBtn setTitle:model.title forState:UIControlStateNormal];
            
        }else{
            
            [tagBtn setImage:[UIImage imageNamed:@"粉色＋"] forState:UIControlStateNormal];
        }
        
        [self.iconView addSubview:tagBtn];
 
    }
    
    [self addQiangGou];

  
}

- (void)setPic:(NSString *)pic
{
    _pic = pic;
    self.imageBtn.hidden = NO;
    
    SDWebImageManager *imageManager = [[SDWebImageManager alloc]init];
    [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,pic]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (error == nil) {
            
            [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
        
    }];

}

- (void)clickAd
{
    if (self.beautyAd) {
        self.beautyAd();
    }
}

- (void)setSalonExpand:(NSArray *)salonExpand
{
    _salonExpand = salonExpand;
    self.buyView.hidden = NO;
    
    if (self.salonExpand.count) {
        NSMutableArray *imagetitle = [NSMutableArray array];
        NSMutableArray *qianggouUrltitle = [NSMutableArray array];
        NSMutableArray *typearr = [NSMutableArray array];
        
        for (NSDictionary *dict in self.salonExpand) {
            
            [imagetitle addObject:dict[@"bannerPath"]];
            [qianggouUrltitle addObject:dict[@"url"]];
            //            [qianggoutitle addObject:dict[@"title"]];
            
        }
        
        NSArray *imagearr = imagetitle;
        MYqianggouview * qianggouview = [[MYqianggouview alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenH*0.27) imagearr:imagearr imagcount:self.salonExpand.count urlarr:qianggouUrltitle type:typearr];
        qianggouview.model = self.salonExpand;
        [self.buyView addSubview:qianggouview];
    }

}

- (void)addQiangGou
{
    UIView *beautymenuview = [[UIView alloc]initWithFrame:CGRectMake(0, self.iconView.bottom + kMargin, MYScreenW, MYScreenW / 2.0)];
    self.buyView = beautymenuview;
    self.buyView.hidden = YES;
    [self addSubview:beautymenuview];
  
   
}


- (void)clickBtn:(UIButton *)btn
{
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    
    if (self.beautyBlock) {
        self.beautyBlock(self.showItems,btn);
    }
    
}



@end
