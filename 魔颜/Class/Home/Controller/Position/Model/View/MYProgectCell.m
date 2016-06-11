//
//  MYProgectCell.m
//  魔颜
//
//  Created by Meiyue on 15/10/23.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYProgectCell.h"
#import "MYHeader.h"

@interface MYProgectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imagView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (strong, nonatomic)  UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *hospitalName;

@property (strong, nonatomic)  UILabel *allprice;

@property (weak, nonatomic) IBOutlet UIView *boomview;


@end

@implementation MYProgectCell

- (void)awakeFromNib {
    
    [self layoutSubviews];
    
    UILabel *pricelable = [[UILabel alloc]init];
    self.priceLabel = pricelable;
    self.priceLabel.textColor = UIColorFromRGB(0xed0381);
    self.priceLabel.font = MianFont;
    [self.boomview addSubview:self.priceLabel];
    
    UILabel *allprice = [[UILabel alloc]init];
    self.allprice = allprice;
    self.allprice.textColor = subTitleColor;
    self.allprice.font = MianFont;
    [self.boomview addSubview:self.allprice];
    
    
    self.titleLabel.textColor = UIColorFromRGB(0x1a1a1a);
    self.titleLabel.font = ThemeFont;
    
    self.desLabel.textColor = subTitleColor;
    self.desLabel.font = MianFont;
    
    self.hospitalName.textColor = titlecolor;
    self.hospitalName.font = MianFont;
//    self.allprice.textColor = subTitleColor;
//    self.allprice.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
//    self.allprice.textAlignment = NSTextAlignmentLeft;
    
//    self.allprice.backgroundColor = [UIColor grayColor];
//    self.priceLabel.backgroundColor = [UIColor blueColor];
    
    
    
}

+(instancetype)progectCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MYProgectCell" owner:nil options:nil] firstObject];
}

- (void)setProgect:(MYDiscount *)progect
{
    _progect = progect;
    
    [self.imagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,progect.smallPic]]];
    
    self.titleLabel.text = progect.title;
    self.desLabel.text = progect.advertising;
   
    self.hospitalName.text = progect.hospitalName;
    self.allprice.text = [NSString stringWithFormat:@"￥%@",progect.price];
 
     self.priceLabel.text = [NSString stringWithFormat:@"￥%@",progect.discountPrice];
    CGSize maxYuanPricesize = CGSizeMake(80, 30);
    CGSize maxYuanPriceSize1 = [self.priceLabel.text sizeWithFont:MianFont constrainedToSize:maxYuanPricesize];
    self.priceLabel.frame = CGRectMake(0, 0, maxYuanPriceSize1.width, maxYuanPriceSize1.height);
   
    CGSize maxYuanPriceSize = [self.allprice.text sizeWithFont:MianFont constrainedToSize:maxYuanPricesize];
    self.allprice.frame = CGRectMake(self.priceLabel.right + 5, 0, maxYuanPriceSize.width, maxYuanPriceSize.height);

    UIView *lineview = [[UIView alloc]init];
    [self.allprice addSubview:lineview];
    lineview.frame = CGRectMake(1, 7, maxYuanPriceSize.width , 0.5);
    lineview.backgroundColor = [UIColor blackColor];
    lineview.alpha = 0.5;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10, 10, 105, 105);

}




@end














