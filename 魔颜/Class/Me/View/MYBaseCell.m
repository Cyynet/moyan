//
//  WQTabBarController.h
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYBaseCell.h"
#import "MYBaseItem.h"
#import "MYArrowItem.h"
#import "MYHeader.h"

@interface MYBaseCell ()

@property (strong, nonatomic) UIImageView *rightArrow;
@property (weak, nonatomic) UIView *lineView;
@property (weak, nonatomic) UILabel *detailLabel;

@end

@implementation MYBaseCell

// 创建辅助视图并一次性初始化
- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"common_icon_arrow"]];
    }
    return _rightArrow;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    MYBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MYBaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.font = MianFont;
        self.textLabel.textColor = titlecolor;
        self.detailTextLabel.font = MianFont;
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage resizableImage:@"common_card_middle_background"]];
        self.backgroundView = image;
    }
    return self;
  
}

#pragma mark - setter
- (void)setItem:(MYBaseItem *)item
{
    _item = item;
    
    // 1.设置基本数据
    if (item.icon) {
        
        self.imageView.image = [UIImage imageNamed:item.icon];
    }
    if (item.subTitle) {
        
        self.detailTextLabel.text = item.subTitle;
    }
    self.textLabel.text = item.title;
    
    // 设置辅助视图
    
    if ([item isKindOfClass:[MYArrowItem class]]) {
        
        self.accessoryView = self.rightArrow;
        
    } else { // 取消右边的内容
        
        self.accessoryView = nil;
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.item.icon) {
        
        CGFloat maxX = CGRectGetMaxX(self.imageView.frame);
        self.textLabel.x = maxX + 10;
    }
    else{        
        self.textLabel.x = 30;
    }
    
}



@end
