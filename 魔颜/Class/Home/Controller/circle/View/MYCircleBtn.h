//
//  MYCircleBtn.h
//  魔颜
//
//  Created by Meiyue on 15/11/20.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYCircleBtn : UIButton

/**评论回复的id*/
@property (nonatomic, assign) NSInteger ID;
/**评论回复的状态*/
@property (nonatomic, assign) NSInteger commentPraiseStatus;

@property (copy, nonatomic) NSString *title;

- (void)setTitle:(NSString *)title;

-(void)addTarget:(id)target action:(SEL)action;


@end
