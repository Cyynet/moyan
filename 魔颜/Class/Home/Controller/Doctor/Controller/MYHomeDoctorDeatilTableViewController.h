//
//  MYDroctionDeatilTableViewController.h
//  魔颜
//
//  Created by abc on 15/9/28.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "doctorListModel.h"
@interface MYHomeDoctorDeatilTableViewController : UIViewController

@property (copy, nonatomic) NSString *id;

/*
 @brief 从webView跳转
 */
@property (copy, nonatomic) NSString *hospitalId;


@end
