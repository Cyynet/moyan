//
//  UIImageView+Extension.h
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MYExtension)

/**
 *  创建 UIImageView
 *
 *  @param frame    尺寸
 *  @param imageStr 图片名字(图片在项目中)
 */
+ (instancetype )addImaViewWithFrame:(CGRect)frame
                           imageName:(NSString *)imageName;


/**创建 UIImageView*/
+ (instancetype )addImaViewWithImageName:(NSString *)imageName;

/**
 *  创建 UIImageView
 *
 *  @param frame     尺寸
 *  @param imageStr  图片名字(图片在项目中)
 *  @param tapAction 单击回调
 */
+ (instancetype)addImageViewWithFrame:(CGRect)frame
                             imageStr:(NSString *)imageStr
                            tapAction: ( void(^)(UIImageView *image))tapAction;

/**
 *  用默认的方式设置头像(默认是圆形)
 */
- (void)setHeaderWithURL:(NSString *)url;

/**
 *  设置圆形头像
 */
- (void)setCircleHeaderWithURL:(NSString *)url;

/**
 *  设置方形头像
 */
- (void)setRectHeaderWithURL:(NSString *)url;



@end
