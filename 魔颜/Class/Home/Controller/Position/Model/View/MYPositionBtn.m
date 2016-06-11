//
//  MYPositionBtn.m
//  魔颜
//
//  Created by Meiyue on 15/10/19.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYPositionBtn.h"
#import "MYHeader.h"

@interface MYPositionBtn ()
@property (copy, nonatomic) NSString *id;

@property (nonatomic, assign) NSInteger num;

@property (copy, nonatomic) NSString *second;


@end

@implementation MYPositionBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
        self.titleLabel.textColor = [UIColor blackColor];
        [self addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
     }
    return self;
}

- (void)setSecondCode:(NSInteger)secondCode
{
    _secondCode = secondCode;
    NSString *str = [NSString stringWithFormat:@"%ld",self.secondCode];
    self.second = str;
}

- (void)clickItem:(UIButton *)btn
{
    [MYUserDefaults setObject:self.id forKey:@"btn"];
    [MYUserDefaults setObject:self.second forKey:@"second"];
    [MYUserDefaults synchronize];
    [MYNotificationCenter postNotificationName:@"clickPosition" object:nil userInfo:@{@"MYPosition" : btn.titleLabel.text ,@"secondCode" : @(self.secondCode)}];
}

-(void)setItme:(MYItem *)itme
{
 
    _itme = itme;
    
    // 显示出来,下载
    SDWebImageManager *imageManager = [[SDWebImageManager alloc]init];
    [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,itme.typePic]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (error == nil) {
            
            [self setImage:image forState:UIControlStateNormal];
        }

    }];
    //下边文字
    [self setTitle:itme.thirdLevel forState:UIControlStateNormal];
    self.id = [NSString stringWithFormat:@"%ld",(long)itme.id];
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = 20;
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height - titleH;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height - 30;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
