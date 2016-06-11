//
//  MYCalendarView.m
//  魔颜
//
//  Created by Meiyue on 15/10/12.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYCalendarView.h"

@interface MYCalendarView ()

@property (strong, nonatomic) UIButton *coverBtn;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIDatePicker *datePick;

@end

@implementation MYCalendarView
+ (instancetype)popCalendarView
{
    return [[self alloc] init];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *coverBtn = [[UIButton alloc]init];
        coverBtn.backgroundColor = [UIColor blackColor];
        coverBtn.alpha = 0.5;
        [coverBtn addTarget:self action:@selector(clickCover) forControlEvents:UIControlEventTouchUpInside];
        self.coverBtn = coverBtn;
        [self addSubview:coverBtn];
        
        //弹出视图
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius = 10;
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    return self;
}
-(void)showInRect:(CGRect)rect
{
    //设置pop被指定的位置
    self.contentView.frame = rect;
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.frame = window.bounds;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    self.datePick = datePicker;
    datePicker.frame = CGRectMake(5, 0, self.width - 75, 200);
    
    if (self.isType) {
         [datePicker setDatePickerMode:UIDatePickerModeTime];
    }else{
         [datePicker setDatePickerMode:UIDatePickerModeDate];
    }
    
    //定义最小日期
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter_minDate dateFromString:@"1960-01-01"];
    formatter_minDate = nil;
    //最大日期是今天
//    NSDate *maxDate = [NSDate date];
    NSDate *maxDate = [formatter_minDate dateFromString:@"2017-01-01"];
    
    [datePicker setMinimumDate:minDate];
    [datePicker setMaximumDate:maxDate];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents: UIControlEventValueChanged];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(-20, 205, self.width, 35);
    [self.contentView addSubview:view];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, self.width / 2 - 10, 35);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.backgroundColor = MYColor(109, 109, 109);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(self.width / 2 - 9, 0, self.width / 2, 35);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
  rightBtn.backgroundColor = MYColor(109, 109, 109);
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -27, 0, 0);
    [rightBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    
    self.datePick = datePicker;
    [self.contentView addSubview:datePicker];
    [window addSubview:self];
    
}

- (void)cancel
{
    [MYNotificationCenter postNotificationName:@"cancel" object:nil];
    [self clickCover];
}

- (void)sure
{
    [UIView animateWithDuration:0.1 animations:^{
           self.coverBtn.alpha = 0;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
//    if (self.isType) {
//        
//    }else{
//        
//        [MYNotificationCenter postNotificationName:@"time" object:nil];
//    }
  
}

-(void)clickCover
{
    [MYNotificationCenter postNotificationName:@"cancel" object:nil];
    [UIView animateWithDuration:0.1 animations:^{
        
        self.coverBtn.alpha = 0;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)dateChanged:(UIDatePicker *)datePick
{
    // 通知VC
    if ([self.delegate respondsToSelector:@selector(calendarView:datePick:)]) {
        [self.delegate calendarView:self datePick:datePick];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverBtn.frame = [UIScreen mainScreen].bounds;
    
}

@end
