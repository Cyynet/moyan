//
//  MYCollectionListCell.m
//  魔颜
//
//  Created by Meiyue on 16/2/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYCollectionListCell.h"
#import "NSString+File.h"
#import "MYHeader.h"


@interface MYCollectionListCell ()

@property(strong,nonatomic) UIView *rightview;
@end
@implementation MYCollectionListCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *simageView = [[UIImageView alloc] init];
        simageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        simageView.contentMode = UIViewContentModeScaleAspectFit;
        self.sImagView = simageView;
        [self.contentView addSubview:simageView];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        titleLabel.font = leftFont;
        titleLabel.textColor=titlecolor;
        [self.contentView  addSubview:titleLabel];
        
        //价格
        UILabel *priceLabel = [[UILabel alloc] init];
        self.priceLabel = priceLabel;
        priceLabel.textColor = UIColorFromRGB(0xed0381);
        priceLabel.font = leftFont;
        [self.contentView addSubview:priceLabel];
        
//        self.backgroundColor = [UIColor redColor];
//        UIView *rightview = [[UIView alloc]init];
//        [self.contentView addSubview:rightview];
//        rightview.backgroundColor = [UIColor whiteColor];
//        self.rightview = rightview;
        
    }
    return self;
}

- (void)setSalonListMode:(MYSalonListModel *)salonListMode
{
    _salonListMode = salonListMode;
    
    NSString *des;
    
    if (salonListMode.shortTitle == nil || salonListMode.shortTitle == NULL|| salonListMode.shortTitle.length == 0) {
        
        des = salonListMode.title;
        
    }else{
        
        des = salonListMode.shortTitle;
    }
    
    _salonListMode = salonListMode;
    [self.sImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,salonListMode.listPic]]];
    self.titleLabel.text = des;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",salonListMode.discountPrice];
}

/**
 *  在这里可以布局contentView里面的控件
 *
 *  @param layoutAttributes 直接继承于NSObject 形式上类似于CALayer
 */
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.sImagView.frame = CGRectMake(0, 0, layoutAttributes.frame.size.width, layoutAttributes.frame.size.width);
    self.titleLabel.frame = CGRectMake(5, layoutAttributes.frame.size.width, layoutAttributes.frame.size.width * 0.8, self.height * 0.15);
    self.priceLabel.frame = CGRectMake(5, layoutAttributes.frame.size.height * 0.8+5, layoutAttributes.frame.size.width * 0.95, self.height * 0.15);

//    self.rightview.frame = CGRectMake(self.sImagView.right, 0, 10, layoutAttributes.frame.size.height);
}



@end
