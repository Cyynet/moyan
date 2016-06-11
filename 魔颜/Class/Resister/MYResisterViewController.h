//
//  MYResignViewController.h
//  魔颜
//
//  Created by Meiyue on 15/9/30.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginBlock)(NSString *codeNum);

@interface MYResisterViewController : UIViewController

/** 账号 */
@property (copy, nonatomic) LoginBlock loginBLock;


@end
