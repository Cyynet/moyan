//
//  VierticalScrollView.h
//  上下滚动btn
//
//  Created by 李杨 on 16/2/25.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VierticalScrollViewDelegate <NSObject>

@optional

-(void)clickTitleButton:(UIButton *)button;

@end//
//  VierticalScrollView.h
//  上下滚动btn
//
//  Created by 李杨 on 16/2/25.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBtnBlock)(NSInteger btnIndex);


@interface VierticalScrollView : UIView


-(instancetype)initWithArray:(NSArray *)titles AndFrame:(CGRect)frame;
+(instancetype)initWithTitleArray:(NSArray *)titles AndFrame:(CGRect)frame;

@property (copy, nonatomic)   MyBtnBlock btnIndex;



@end


