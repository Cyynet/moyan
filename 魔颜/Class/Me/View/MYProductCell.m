//
//  MYProductCell.m
//  魔颜
//
//  Created by Meiyue on 15/10/9.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYProductCell.h"
#import "MYHeader.h"

@interface MYProductCell ()

@end

@implementation MYProductCell


+ (instancetype )productCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MYProductCell" owner:nil options:nil] lastObject];
  
}

- (void)awakeFromNib {
    
    self.finishPayLabel.textAlignment = NSTextAlignmentRight;
    
    self.deleteOrder.layer.borderColor = MYColor(193, 177, 122).CGColor;
    self.deleteOrder.layer.borderWidth = 1.0;
    self.deleteOrder.layer.cornerRadius = 3;
    self.deleteOrder.layer.masksToBounds = YES;
    
    self.finishPayLabel.font = leftFont;
    self.finishPayLabel.textColor = MYColor(193, 177, 122);
    self.titleLabel.font = leftFont;
    self.titleLabel.textColor = titlecolor;
    self.desLabel.font = leftFont;
    self.desLabel.textColor = subTitleColor;
    self.priceLabel.font = leftFont;
    self.priceLabel.textColor = MYColor(193, 177, 122);
 
    [self.deleteOrder setTitleColor:titlecolor forState:UIControlStateNormal];
    [self.deleteOrder setTitleColor:titlecolor forState:UIControlStateHighlighted];
    
    self.goToPayBtn.backgroundColor = MYColor(193, 177, 122);
    [self.goToPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.sumPrice.font = leftFont;
    self.sumPrice.textColor = subTitleColor;
    
    
}
- (IBAction)deleteOrder:(id)sender {
       
    [MYNotificationCenter postNotificationName:@"delete" object:nil userInfo:@{@"MYOrderDelete" : self.order.id , @"MYOrderType" : self.order.type}];
  
}
- (IBAction)comment:(id)sender {
    
    if (self.order.status == 2) {
        [MYNotificationCenter postNotificationName:@"comment" object:nil userInfo:@{@"MYOrder" : self.order}];
    }
}

- (void)setOrder:(MYOrder *)order
{
    _order = order;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,order.pic]]];
    
    self.titleLabel.text = order.title;
    
    self.desLabel.text = order.dis;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@ X %@",order.price,order.num];
    
    self.sumPrice.text = [NSString stringWithFormat:@"共计%@件,合计%@",order.num,order.sumall];
    
    self.type = order.type;
    
    if (order.status == 0) {
        self.goToPayBtn.hidden = NO;
        self.goToPayBtn.enabled = NO;
        self.finishPayLabel.text = @"待付款";
    }
    
    if (order.status == 1) {
        self.finishPayLabel.text = @"已付款";
        self.goToPayBtn.enabled = NO;
        self.goToPayBtn.hidden = YES;
    }
    if (order.status == 2){
        
        if ([order.isEvaluat isEqualToString:@"1"]) {
            self.goToPayBtn.hidden = NO;
            self.goToPayBtn.enabled = NO;
            [self.goToPayBtn setTitle:@"已评价" forState:UIControlStateNormal];

        }else{
        
            self.finishPayLabel.text = @"已完成";
            self.goToPayBtn.enabled = YES;
            self.goToPayBtn.hidden = NO;
            [self.goToPayBtn setTitle:@"去评价" forState:UIControlStateNormal];
        }
        
        
    }
}


@end
