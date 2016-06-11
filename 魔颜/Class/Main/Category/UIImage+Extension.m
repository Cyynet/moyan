//
//  UIImage+Extension.m
//  河科院微博
//
//  Created by 👄 on 15/6/4.
//  Copyright (c) 2015年 sczy. All rights reserved.
//

#import "UIImage+Extension.h"
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)

@implementation UIImage (Extension)
// 如果是iOS7，自动在图片名后面加上_os7
+(UIImage *)imageWithName:(NSString *)name
{
    
    
    UIImage *image = nil;
    if (iOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:newName];
    }
    
    // 如果是6或者7（67同用一张）image都为空！
    if (!image) {
        image = [UIImage imageNamed:name];
    }
    return image;
}

+(UIImage *)resizableImage:(NSString *)name
{
    UIImage *image = [UIImage imageWithName:name];
    
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH * 0.5, imageW * 0.5, imageH * 0.5, imageW * 0.5) resizingMode:UIImageResizingModeStretch];
}

- (instancetype)circleImage
{
    // 开启图形上下文(目的:产生一个新的UIImage, 参数size就是新产生UIImage的size)
    UIGraphicsBeginImageContext(self.size);
    
    // 获得上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    
    // 裁剪(根据添加到上下文中的路径进行裁剪)
    // 以后超出裁剪后形状的内容都看不见
    CGContextClip(context);
    
    // 绘制图片到上下文中
    [self drawInRect:rect];
    
    // 从上下文中获得最终的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)circleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] circleImage];
}


@end
