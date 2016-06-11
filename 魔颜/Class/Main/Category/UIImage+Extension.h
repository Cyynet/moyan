//
//  UIImage+Extension.h
//  河科院微博
//
//  Created by 👄 on 15/6/4.
//  Copyright (c) 2015年 sczy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+(UIImage *)imageWithName:(NSString *)name;
+(UIImage *)resizableImage:(NSString *)name;

- (instancetype)circleImage;
+ (instancetype)circleImageNamed:(NSString *)name;

@end
