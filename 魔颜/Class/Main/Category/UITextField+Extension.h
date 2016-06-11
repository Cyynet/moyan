//
//  UITextField+Extension.h
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)<UITextFieldDelegate>

+ (instancetype )addFieldWithFrame:(CGRect)frame
                              text:(NSString *)text
                            font:(UIFont *)font
                       placeholder:(NSString *)placeholder;



@end
