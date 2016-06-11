//
//  UITextField+Extension.m
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "UITextField+Extension.h"

@interface UITextField ()<UITextFieldDelegate>


@end

@implementation UITextField (Extension)

+ (instancetype )addFieldWithFrame:(CGRect)frame
                              text:(NSString *)text
                              font:(UIFont *)font
                       placeholder:(NSString *)placeholder

{
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.placeholder = placeholder;
    textField.font = leftFont;
    textField.text = text;
    textField.textColor = subTitleColor;
    textField.textAlignment = NSTextAlignmentRight;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.frame = frame;
    
    return textField;
}



@end
