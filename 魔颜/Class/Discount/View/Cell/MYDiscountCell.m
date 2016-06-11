//
//  MYDiscountCell.m
//  魔颜
//
//  Created by Meiyue on 15/10/8.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYDiscountCell.h"
#import "MYDiscount.h"
#import "MYHeader.h"

@interface MYDiscountCell ()
@property (weak, nonatomic)  UILabel *titleLabe;
@property (weak, nonatomic)  UIImageView *imaView;

@property (weak, nonatomic)  UILabel *idNumber;


@end

@implementation MYDiscountCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView  index:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"Discount%ld",(long)[indexPath row]];
    MYDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[MYDiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        UILabel *idNumber = [[UILabel alloc] init];
//        self.idNumber = idNumber;
//        idNumber.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:idNumber];
//        idNumber.textColor = titlecolor;
//        idNumber.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
//           
//        UILabel *titleLabel = [[UILabel alloc] init];
//        self.titleLabe = titleLabel;
//        titleLabel.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:titleLabel];
//        titleLabel.textColor = titlecolor;
//        titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        self.imaView.layer.cornerRadius = 5;
        self.imaView.layer.masksToBounds = YES;
        self.imaView = iconView;
        [self addSubview:iconView];
        
    }
    return self;
}

#pragma mark - setter
- (void)setDiscount:(MYDiscount *)discount
{
    [self setupStatus:discount];
}
- (void)setupStatus:(MYDiscount *)discount
{
    _discount = discount;
      __block MYDiscountCell *weakSelf = self;
    //设置基本数据
    [self.imaView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,discount.typePic]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (!error) {
            weakSelf.imaView.image = image;
            [weakSelf setupFrame];
        }

    }];
}


- (void)setupFrame
{
    CGFloat imaViewW = MYScreenW;
//    CGFloat imaViewH = self.imaView.image.size.height * imaViewW / self.imaView.image.size.width;
    
    self.imaView.frame = CGRectMake(0,5, imaViewW, MYScreenW / 2.5);
    
//    self.height = CGRectGetMaxY(self.imaView.frame);
    
    
}




@end
