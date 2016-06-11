//
//  MYPositionCell.m
//  魔颜
//
//  Created by Meiyue on 15/10/19.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYPositionCell.h"

#define kCellX 60

@interface MYPositionCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *lineView;

@end

@implementation MYPositionCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView  index:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"Cell%ld",(long)[indexPath row]];
//    MYPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
     MYPositionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   
    if (cell == nil) {
        cell = [[MYPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
 }

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = lineViewBackgroundColor;
        self.lineView = lineView;
        [self.contentView addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
        titleLabel.textColor = [UIColor grayColor];
        self.titleLabel = titleLabel;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        
        MYPositionView *positionView = [[MYPositionView alloc] init];
        self.postionView = positionView;
        positionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:positionView];
    }
    return self;
}

- (void)setGroups:(MYPositionGroup *)groups
{
    _groups = groups;
    
    self.postionView.items = nil;
    self.titleLabel.text = nil;
    
    self.titleLabel.text = groups.secondproject;
    self.postionView.secondCode = groups.secondCode;
    self.postionView.items = groups.thirdproject;
   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, 15, self.width, 0.7);

    self.titleLabel.frame = CGRectMake((self.width - 35) / 2 , 3, 35, 25);
        
    CGFloat postionViewY = CGRectGetMaxY(self.titleLabel.frame) - 8;
    CGFloat postionViewX = MYMargin;
    
    // 根据图片的个数计算picturesView的size
    CGSize postionViewSize = [MYPositionView sizeWithItemsCount:self.groups.thirdproject.count];
    
    CGFloat postionViewW = postionViewSize.width;
    CGFloat postionViewH = postionViewSize.height;
    
    self.postionView.frame = (CGRect){postionViewX,postionViewY,postionViewW,postionViewH};
     self.cellHeight = postionViewH + MYMargin * 2 + 25;
}


@end
