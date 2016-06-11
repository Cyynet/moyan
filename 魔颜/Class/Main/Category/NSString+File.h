//
//  NSString+File.h
//  河科院微博
//
//  Created by 👄 on 15/7/31.
//  Copyright (c) 2015年 sczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (File)

- (long long)fileSize;

- (float) heightWithFont: (UIFont *) font withinWidth: (float) width;
- (float) widthWithFont: (UIFont *) font;

/**
 *  判断字符串是否为空
 */
- (BOOL) isBlankString:(NSString *)string;

@end
