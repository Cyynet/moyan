//
//  MYProductCell.h
//  魔颜
//
//  Created by Meiyue on 15/10/9.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYOrder.h"


@interface MYProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *finishPayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumPrice;
@property (weak, nonatomic) IBOutlet UIButton *deleteOrder;
@property (copy, nonatomic) NSString *type;
@property (weak, nonatomic) IBOutlet UIButton *goToPayBtn;

@property (strong, nonatomic) MYOrder *order;

+ (instancetype )productCell;


@end
