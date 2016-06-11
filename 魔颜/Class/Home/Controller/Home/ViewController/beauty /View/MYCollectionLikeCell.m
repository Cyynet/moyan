//
//  MYCollectionLikeCell.m
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYCollectionLikeCell.h"

#import <CoreLocation/CoreLocation.h>
#import "NSString+Extension.h"
#import "UILabel+Extension.h"
#import "MYHeader.h"

@interface MYCollectionLikeCell ()

/** 左图 */
@property (weak, nonatomic) UIImageView *imgeView;

/** 标题 */
@property (weak, nonatomic) UILabel *titleLabel;

/** 价格 */
@property (weak, nonatomic) UILabel *discountPrice;

/** 价格 */
@property (weak, nonatomic) UILabel *priceLabel;

@property(strong,nonatomic) UILabel * destitleLabel;

/** 描述 */
@property (weak, nonatomic) UILabel *desLabel;

/** 机构 */
@property (weak, nonatomic) UILabel *orgLabel;




//距离
@property(strong,nonatomic) UIImageView * discetionimage;
@property(strong,nonatomic) UILabel * disction;
@property(strong,nonatomic) UIView * lineview;


@end

@implementation MYCollectionLikeCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        //大图
        UIImageView *iconView = [[UIImageView alloc] init];
        self.imgeView = iconView;
        [self.contentView addSubview:iconView];
        
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        titleLabel.textColor =UIColorFromRGB(0x1a1a1a);
        titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0];
        [self.contentView  addSubview:titleLabel];
        
        //价格
        UILabel *priceLabel = [[UILabel alloc] init];
        self.priceLabel = priceLabel;
        priceLabel.textColor = UIColorFromRGB(0x999999);
        priceLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
        [self.contentView addSubview:priceLabel];
        
        
        
        //打折价格
        UILabel *discountPrice = [[UILabel alloc] init];
        self.discountPrice = discountPrice;
        discountPrice.textColor = UIColorFromRGB(0xed0381);
        discountPrice.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0];
        [self.contentView addSubview:discountPrice];
        
        UIView *lineview = [[UIView alloc]init];
        [self.priceLabel addSubview:lineview];
        lineview.backgroundColor = [UIColor grayColor];
        lineview.alpha = 0.5;
        self.lineview = lineview;
        
        
        //推荐有礼
        UILabel *destitleLabel = [[UILabel alloc] init];
        self.destitleLabel = destitleLabel;
        destitleLabel.textColor = UIColorFromRGB(0xed0381);
        destitleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
        destitleLabel.text= @"推荐有礼";
        destitleLabel.layer.cornerRadius = 2;
        destitleLabel.layer.masksToBounds = YES;
        destitleLabel.layer.borderColor = UIColorFromRGB(0xed0381).CGColor;
        destitleLabel.layer.borderWidth = 1;
        [self.contentView addSubview:destitleLabel];
        destitleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        UILabel *desLabel = [[UILabel alloc] init];
        self.desLabel = desLabel;
        desLabel.textColor = UIColorFromRGB(0x999999);
        desLabel.font = leftFont;
        [self.contentView addSubview:desLabel];
        
        
        
        //服务机构
        UILabel *orgLabel = [[UILabel alloc] init];
        self.orgLabel = orgLabel;
        orgLabel.textColor = UIColorFromRGB(0x4c4c4c);
        orgLabel.font = leftFont;
        [self.contentView addSubview:orgLabel];
        
        
        
        
        //        地位距离
        
        
        UILabel *disction = [[UILabel alloc]init];
        [self.contentView addSubview:disction];
        //        disction.text = @"200km";
        disction.textColor = UIColorFromRGB(0x999999);
        disction.font = leftFont;
        self.disction = disction;
        
        UIImageView *discetionimage = [[UIImageView alloc]init];
        [self.contentView addSubview:discetionimage];
        discetionimage.image = [UIImage imageNamed:@"地图"];
        self.discetionimage = discetionimage;
        
        
        
        UIView *line = [[UIView alloc]init];
        [self.contentView addSubview:line];
        line.backgroundColor = UIColorFromRGB(0xf7f7f7);
        self.line = line;
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        
    }
    return self;
}

- (void)setServiceLike:(MYServiceLike *)serviceLike
{
    _serviceLike = serviceLike;
    
    [self.imgeView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,serviceLike.listPic]]];
    
    if ([serviceLike.shortTitle isEqualToString:@""]) {
        
        self.titleLabel.text = serviceLike.title;
    }else{
        self.titleLabel.text = serviceLike.shortTitle;
    }
    
    self.discountPrice.text = [NSString stringWithFormat:@"¥%@",serviceLike.discountPrice];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",serviceLike.price];
    self.desLabel.text = serviceLike.desc;
    self.orgLabel.text = [NSString stringWithFormat:@"[%@]",serviceLike.name];
    
    //    计算距离
    CGFloat lat =  [[MYUserDefaults objectForKey:@"latitude"]  floatValue];
    CGFloat lon =  [[MYUserDefaults objectForKey:@"longitude"]  floatValue];
    
    if(lat == 0 || serviceLike.latitude == 0){
        self.disction.text = @"未知";
    }else{
        
        //第一个坐标
        CLLocation *current=[[CLLocation alloc] initWithLatitude: lat longitude:lon];
        
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:serviceLike.latitude longitude:serviceLike.longitude];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before];
        double distance = meters/1000;
        int disc = (int )distance;
        self.disction.text = [NSString stringWithFormat:@"%dKM",disc];
        
    }
    

    
    [self layoutSubviews];

}




- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgeView.frame = CGRectMake(kMargin, MYMargin, 112, 112);
    
    self.titleLabel.frame = CGRectMake(self.imgeView.right + kMargin, MYMargin, MYScreenW - self.imgeView.right - 3.2 * MYMargin, 20);
    
    CGFloat discountPricewith = [self.discountPrice widthWithHeight:20];
    self.discountPrice.frame = CGRectMake(self.titleLabel.x, self.titleLabel.bottom + kMargin/2, discountPricewith, 20);
    
    
    CGFloat pricewith = [self.priceLabel widthWithHeight:20];
    self.priceLabel.frame = CGRectMake(self.discountPrice.right+kMargin, self.titleLabel.bottom + kMargin/2, pricewith, 20);
    self.lineview.frame = CGRectMake(0, self.priceLabel.height/2, pricewith, 0.5);
    
    
    self.destitleLabel.frame = CGRectMake(self.imgeView.width+20, self.priceLabel.bottom+kMargin/2, 50, 20);
    
    self.desLabel.frame = CGRectMake(self.destitleLabel.right+kMargin, self.priceLabel.bottom + kMargin/2, MYScreenW - self.imgeView.width -70, 20);
    CGFloat width = [self.disction widthWithHeight:20];
    self.orgLabel.frame = CGRectMake(self.imgeView.width + 20,self.desLabel.bottom + kMargin*1.5 , MYScreenW-112-kMargin*4-width, 20);
    
    
    self.disction.frame = CGRectMake(MYScreenW-width-kMargin, self.orgLabel.y, width, 20);
    
    self.discetionimage.frame = CGRectMake(MYScreenW-width-kMargin-10, self.orgLabel.y+2, 8, 13);
    
    self.line.frame = CGRectMake(-10, 0, MYScreenW+10,10);
    
}

@end
