//
//  WQCategoryBtn.h
//  魔颜
//
//  Created by 周文静 on 15/9/23.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYCategoryBtn : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+(instancetype)addbtn;

@end
