//
//  MYCalendarView.h
//  魔颜
//
//  Created by Meiyue on 15/10/12.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MYCalendarView;
@protocol MYCalendarViewDelegate <NSObject>

- (void)calendarView:(MYCalendarView *)canendarView datePick:(UIDatePicker *)datePick;

@end

@interface MYCalendarView : UIView

+ (instancetype)popCalendarView;

-(void)showInRect:(CGRect)rect;

@property (nonatomic, assign) BOOL isType;

@property(weak, nonatomic) id<MYCalendarViewDelegate> delegate;

@end
