//
//  RBCustomDatePickerView.h
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"

@class RBCustomDatePickerView;
@protocol RBCustomDatePickerViewDelegate <NSObject>

- (void)datePickView:(RBCustomDatePickerView *)datePickView  showTimeLabelText:(NSString *)showTimeLabelText;


@end

@interface RBCustomDatePickerView : UIView <MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>

@property (weak, nonatomic) id <RBCustomDatePickerViewDelegate> delegate;

+ (instancetype)dataPickerView;

-(void)showInRect:(CGRect)rect;

@end
