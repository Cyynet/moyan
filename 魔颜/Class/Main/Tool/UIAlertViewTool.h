//
//  AlertViewController.h
//  BlockAlertViewDemo
//
//  Created by Meiyue on 15/12/23.
//  Copyright © 2015年 fanpyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertViewTool : UIAlertController


/**自定义UIAlertView*/
+ (void)showAlertView:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle otherTitle:(NSString *)otherButtonTitle cancelBlock:(void (^)())cancle confrimBlock:(void (^)())confirm;

@end
