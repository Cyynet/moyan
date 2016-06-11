//
//  MYTieziPhotosView.m
//  魔颜
//
//  Created by Meiyue on 15/10/27.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYTieziPhotosView.h"
#import "MYTieziModel.h"
#import "MYHeader.h"

#define kPicutreW  ((MYScreenW - 2 * 20 - 15) / 2 )
#define kPicutreH kPicutreW


@implementation MYTieziPhotosView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        for (int i = 0; i < 2; i++)
        {
            UIImageView *photoView = [[UIImageView alloc]init];
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.clipsToBounds = YES;
            self.photoView = photoView;
            [self addSubview:photoView];
            
        }
    }
    return self;
}

-(void)setPictures:(NSArray *)pictures
{
    _pictures = pictures;
    
    for (int i = 0; i < 2; i++) {
        
        UIImageView *photoView = self.subviews[i];
        
        if (i >= pictures.count) {
            
            photoView.hidden = YES;
        }
        else
        {
            [photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,pictures[i]]] ];
            photoView.hidden = NO;
        }
     }
    
}

// 根据图片的个数就算大的（红色）view的尺寸
+(CGSize)sizeWithItemsCount:(NSUInteger)count
{
    CGFloat picturesViewW = MYScreenW - 35;
    CGFloat picturesViewH = kPicutreH;
    return CGSizeMake(picturesViewW, picturesViewH);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.subviews.count; i++) {
        
        UIImageView *photo = self.subviews[i];
        
        // 设置frame
        photo.width = kPicutreW;
        photo.height = kPicutreH;
        
        // 列号
        int col = i % 2;
        
        photo.x = col * (photo.width + kMargin);
        photo.y = 0;
        
    }
    
}


@end
