//
//  UIImageView+Extension.m
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIImage+Extension.h"
#import "UIImageView+WebCache.h"


#pragma mark 内部类 MYExImageView
@interface MYExImageView : UIImageView
@property (copy,nonatomic) void (^action)(UIImageView *image);

@end

@implementation MYExImageView

- (void)tapImageBtnClick{
    if (self.action) {
        self.action(self);
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageBtnClick)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageBtnClick)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}
@end


@implementation UIImageView (MYExImageView)

- (void)setHeaderWithURL:(NSString *)url
{
    [self setCircleHeaderWithURL:url];
}

- (void)setCircleHeaderWithURL:(NSString *)url
{
    UIImage *placeholder = [UIImage circleImageNamed:@"icon"];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 下载失败, 不做任何处理, 让它显示占位图片
        if (image == nil) return;
        self.image = [image circleImage];
    }];
}

- (void)setRectHeaderWithURL:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon"]];
}

+ (instancetype )addImaViewWithFrame:(CGRect)frame
                            imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = frame;
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

+ (instancetype )addImaViewWithImageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

+ (instancetype)addImageViewWithFrame:(CGRect)frame
                             imageStr:(NSString *)imageStr
                            tapAction:( void(^)(UIImageView *image))tapAction{
    MYExImageView *image = [[MYExImageView alloc] initWithFrame:frame];
    image.image = [UIImage imageNamed:imageStr];
    image.clipsToBounds = YES;
    image.action = tapAction;
    return image;
}



@end
