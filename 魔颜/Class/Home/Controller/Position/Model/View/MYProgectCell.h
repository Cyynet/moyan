//
//  MYProgectCell.h
//  魔颜
//
//  Created by Meiyue on 15/10/23.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYDiscount.h"
@interface MYProgectCell : UITableViewCell

@property (strong, nonatomic) MYDiscount *progect;

+(instancetype)progectCell;

@end
