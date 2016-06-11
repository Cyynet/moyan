//
//  MYPublicView.m
//  魔颜
//
//  Created by Meiyue on 16/5/12.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYPublicView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MYHeader.h"

#define kPicutreW  ((MYScreenW - 4 * 10) / 3 )
#define kPicutreH kPicutreW

@implementation MYPublicView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        for (int i = 0; i < 6; i ++) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.tag = i;
            [self addSubview:imageView];
            
            // 一个手势对应一个view
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
            [imageView addGestureRecognizer:recognizer];

            
        }
    }
    return self;
}
-(void)clickImageView:(UITapGestureRecognizer *)gesRecognizer
{
      // 创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc]init];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (int i = 0; i < self.pictures.count; i++) {
        
        MJPhoto *photo = [[MJPhoto alloc]init];
        
        // 图片的路径
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,self.pictures[i]]];
        
        // 指定来自哪个小View，之后回到指定的View
        photo.srcImageView = self.subviews[i];
        
        [tempArr addObject:photo];
    }
    
    browser.currentPhotoIndex = gesRecognizer.view.tag;
    
    // 给浏览器设置要显示的图片数组
    browser.photos = tempArr;
    
    //显示
    [browser show];
    
    
}


- (void)setPictures:(NSArray *)pictures
{
    _pictures = pictures;
    
    for (int i = 0; i < 6; i++) {
        
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
    
    [self setupFrame];

}

+ (CGSize)sizeWithPicturesCount:(NSUInteger)count
{
    CGFloat picturesViewH;
    
    if (count <= 3) {
        picturesViewH = kPicutreH + kMargin;
    }else{
        picturesViewH = kPicutreH * 2 + MYMargin;
    }
    
    CGFloat picturesViewW = MYScreenW - MYMargin;
    return CGSizeMake(picturesViewW, picturesViewH);
}

- (void)setupFrame
{
    for (int i = 0; i < self.subviews.count; i++) {
        
        UIImageView *photo = self.subviews[i];
        
        // 设置frame
        photo.width = kPicutreW;
        photo.height = kPicutreH;
          
        // 列号
        int col = i % 3;
        // 行号
        int row = i / 3;
        
        photo.x = col * (photo.width + kMargin);
        photo.y = row * (photo.height + kMargin);
        
    }
    
}

@end
