//
//  SCSearchBar.m
//  SCGoJD
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SCSearchBar.h"

@implementation SCSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 设置字体
        self.font = [UIFont systemFontOfSize:13];
        
        // 设置背景
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);

        // 设置左边的view
        [self setLeftView];
        
//        // 设置右边的录音按钮
//        [self setRightView];
        self.returnKeyType = UIReturnKeySearch;
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.delegate = self;
    }
    
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

//    if(self.searchblock){
//        self.searchblock(textField.text);
//    }
//    
    
//    if ([self.searchdelegate respondsToSelector:@selector(gotosearchdelegate:)]) {
//        [self.searchdelegate gotosearchdelegate:textField.text];
//    }

    [MYNotificationCenter postNotificationName:@"searchtext" object:nil userInfo:@{@"searchtext":textField.text}];
    
    [self endEditing:YES];
    
    return YES;
}


// 设置左边的view
- (void)setLeftView {
    
    // initWithImage:默认UIImageView的尺寸跟图片一样
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuo2"]];
    self.leftView = leftImageView;
    //  注意：一定要设置，想要显示搜索框左边的视图，一定要设置左边视图的模式
    self.leftViewMode = UITextFieldViewModeAlways;
}

//// 设置右边的view
//- (void)setRightView {
//    // 创建按钮
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setImage:[UIImage imageNamed:@"audio_nav_icon"] forState:UIControlStateNormal];
//    [rightButton sizeToFit];
//    // 将imageView宽度
//    rightButton.width += 10;
//    //居中
//    rightButton.contentMode = UIViewContentModeCenter;
//    
//    self.rightView.backgroundColor = [UIColor redColor];
//    self.rightView = rightButton;
//    //  注意：一定要设置，想要显示搜索框左边的视图，一定要设置左边视图的模式
//    self.rightViewMode = UITextFieldViewModeAlways;}
//



@end
