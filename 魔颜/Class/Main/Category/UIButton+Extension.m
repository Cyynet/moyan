//
//  UIButton+Extension.m
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "UIButton+Extension.h"

#pragma mark 内部类 MYExButton
@interface MYExButton : UIButton
@property (copy, nonatomic) TapButtonActionBlock action;
@end

//static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
//static const char *uxy_acceptedEventTime = "uxy_acceptedEventTime";


@implementation MYExButton

- (instancetype)init
{
    if(self = [super init])
    {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)btnClick:(UIButton *)button
{
    if(self.action)
    {
        self.action(self);
    }
}

//@property (nonatomic, assign) NSTimeInterval uxy_acceptEventInterval;   // 可以用这个给重复点击加间隔
//@property (nonatomic, assign) NSTimeInterval uxy_acceptedEventTime;   // 可以用这个给重复点击加间隔

@end

@implementation UIButton (MYExtension)


+ (instancetype)addButtonWithFrame:(CGRect)frame
                   backgroundColor:(UIColor *)backgroundColor
                            Target:(id)target action:(SEL)action{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = backgroundColor;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.clipsToBounds = YES;
    return btn;

}


/*
 @brief 文字按钮
 */
+ (instancetype)addButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                   backgroundColor:(UIColor *)backgroundColor
                        titleColor:(UIColor *)titleColor
                              font:(UIFont *)font
                            Target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = backgroundColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.clipsToBounds = YES;
    
//    btn.layer.borderWidth = 0.6;
//    btn.layer.cornerRadius = 3;
    //    btn.layer.borderColor = MYColor(193, 177, 122).CGColor;
    
    return btn;
    
}



/*
 @brief 图片按钮
 */
+ (instancetype)addButtonWithFrame:(CGRect)frame
                             image:(NSString *)image
                         highImage:(NSString *)highImage
                   backgroundColor:(UIColor *)backgroundColor
                            Target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = backgroundColor;
    // 设置图片
    
    if (image) {
        
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (highImage) {
        
        [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.clipsToBounds = YES;
    return btn;
    
}

+ (instancetype)addButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                        titleColor:(UIColor *)titleColor
                              font:(UIFont *)font
                             image:(NSString *)image
                         highImage:(NSString *)highImage
                   backgroundColor:(UIColor *)backgroundColor
                            Target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = backgroundColor;
    
    //设置文字
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
     btn.titleLabel.font = font;
    
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.clipsToBounds = YES;
    return btn;
    
    
}


//  创建普通按钮
+ (instancetype)addCustomButtonWithFrame:(CGRect)frame
                                         title:(NSString *)title
                               backgroundColor:(UIColor *)backgroundColor
                                    titleColor:(UIColor *)titleColor
                                     tapAction:(TapButtonActionBlock)tapAction
{
    MYExButton *btn = [MYExButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = backgroundColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.action = tapAction;
    return btn;
}

//  创建图片按钮
+ (instancetype)addSystemButtonWithFrame:(CGRect)frame
                   NormalBackgroundImageString:(NSString *)imageString
                                     tapAction:(TapButtonActionBlock)tapAction
{
    MYExButton *btn = [MYExButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.action = tapAction;
    return btn;
}

//- (NSTimeInterval)uxy_acceptEventInterval
//{
//    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
//}
//
//- (void)setUxy_acceptEventInterval:(NSTimeInterval)uxy_acceptEventInterval
//{
//    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(uxy_acceptEventInterval), OBJC_ASSOCIATION_ASSIGN);
//}
//
//
//+ (void)load
//{
//    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    Method b = class_getInstanceMethod(self, @selector(__uxy_sendAction:to:forEvent:));
//    method_exchangeImplementations(a, b);
//}
//
//- (void)__uxy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
//{
//    if (NSDate.date.timeIntervalSince1970 - self.uxy_acceptedEventTime < self.uxy_acceptEventInterval) return;
//    
//    if (self.uxy_acceptEventInterval > 0)
//    {
//        self.uxy_acceptedEventTime = NSDate.date.timeIntervalSince1970;
//    }
//    
//    [self __uxy_sendAction:action to:target forEvent:event];
//}
//
@end
