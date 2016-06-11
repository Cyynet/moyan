//
//  AlertViewController.m
//  BlockAlertViewDemo
//
//  Created by Meiyue on 15/12/23.
//  Copyright © 2015年 fanpyi. All rights reserved.
//

#import "UIAlertViewTool.h"

#define IAIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import "UIAlertViewTool.h"

@interface UIAlertViewTool()

@property(copy,nonatomic)void (^cancelClicked)();

@property(copy,nonatomic)void (^confirmClicked)();

@end
@implementation UIAlertViewTool

+ (void)showAlertView:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle otherTitle:(NSString *)otherButtonTitle cancelBlock:(void (^)())cancle confrimBlock:(void (^)())confirm{
    
    if (IAIOS8) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                cancle();
            
            }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                confirm();
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
    else{
        
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle,nil];
        [TitleAlert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex==0) {
        
        if (self.cancelClicked) {
            self.cancelClicked();
        }
    }
    else{
        if (self.confirmClicked) {
            self.confirmClicked();
        }

    }
}

@end
