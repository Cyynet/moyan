//
//  MYLoginHeadView.h
//  魔颜
//
//  Created by Meiyue on 15/10/21.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYLoginHeadView;
@protocol MYLoginHeadViewDelegate <NSObject>

- (void)loginHeadView:(MYLoginHeadView *)loginHeadView;
@end

@interface MYLoginHeadView : UIView

@property (copy, nonatomic) NSString *iconName;

@property (weak, nonatomic) UIImage *iconImage;
@property (weak, nonatomic) id <MYLoginHeadViewDelegate> delegate;
-(void)setPhone:(NSString*)phone;


@end
