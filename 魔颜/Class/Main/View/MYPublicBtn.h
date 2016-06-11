//
//  MYPublicBtn.h
//  魔颜
//
//  Created by Meiyue on 16/5/10.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYPublicBtn : UIButton


@property (copy, nonatomic) NSString *title;

- (void)setTitle:(NSString *)title;
-(void)addTarget:(id)target action:(SEL)action;
@end
