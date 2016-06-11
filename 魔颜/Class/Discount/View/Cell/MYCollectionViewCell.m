//
//  MYCollectionViewCell.m
//  魔颜
//
//  Created by Meiyue on 16/1/11.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYCollectionViewCell.h"
#import "MYHeader.h"

@interface MYCollectionViewCell ()

@property(strong,nonatomic) UIView  *topview;
@property(strong,nonatomic) UIView  *boomview;
@end

@implementation MYCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *iconView = [[UIImageView alloc] init];
        self.imagView = iconView;
        [self.contentView addSubview:iconView];
     
        
        
        UIView *topview  = [[UIView alloc]init];
        [self.contentView addSubview:topview];
        self.topview = topview;
        topview.backgroundColor = UIColorFromRGB(0xf7f7f7);
        
        UIView *boomview  = [[UIView alloc]init];
        [self.contentView addSubview:boomview];
        self.boomview = boomview;
        boomview.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSalonMode:(MYSalonModel *)salonMode
{
    _salonMode = salonMode;

    [self.imagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,salonMode.TYPE_PIC]]];
   
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.imagView.frame = CGRectMake(0, 10, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height-20);
    
    self.topview.frame = CGRectMake(0, 0, MYScreenW, 10);
    self.boomview.frame = CGRectMake(0, layoutAttributes.frame.size.height-10, MYScreenW, 10);
}

@end
