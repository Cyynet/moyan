//
//  MYArticleCell.m
//  魔颜
//
//  Created by Meiyue on 16/5/12.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYArticleCell.h"
#import "NSString+File.h"
#import "MYHeader.h"

@interface MYArticleCell ()

/** 线条 */
@property (weak, nonatomic) UIView *lineView;

@property(weak, nonatomic) UIImageView *iconView;

@property(weak, nonatomic) UILabel *nameLabel;
/** 时间标签 */
@property (weak, nonatomic) UILabel *timeLabel;
@property(weak, nonatomic)  UILabel *textLab;

@end

@implementation MYArticleCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"Cell%ld",(long)[indexPath row]];
    
    MYArticleCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYArticleCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        
        //用户头像
        UIImageView *iconView = [[UIImageView alloc] init];
        self.iconView = iconView;
        [self addSubview:iconView];
        
        //名字描述
        UILabel *nameLabel = [UILabel addLabelWithTitle:nil titleColor:titlecolor font:ThemeFont];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:self.nameLabel];
        
        //标题
        UILabel *textLab = [[UILabel alloc] init];
        textLab.font = MYFont(14);
        textLab.numberOfLines = 0;
        textLab.textColor = subTitleColor;
        self.textLab = textLab;
        [self.contentView addSubview:textLab];
        
        UILabel *timeLabel = [UILabel addLabelWithTitle:@"" titleColor:UIColorFromRGB(0xb2b2b2) font:MYFont(11)];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setCommentsModel:(MYCommentsModel *)commentsModel
{
    _commentsModel = commentsModel;
    
    if ([self.type isEqualToString:@"1"]) {
        self.lineView.frame = CGRectMake(0, 0, MYScreenW, 0.4);
        [self.iconView setCircleHeaderWithURL:[NSString stringWithFormat:@"%@%@",kOuternet1,commentsModel.pic]];
        self.nameLabel.text = commentsModel.name;
    }else{
        
        self.lineView.frame = CGRectMake(50, 0, MYScreenW, 0.4);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 回复 %@",commentsModel.name,commentsModel.fatherCommentUserName]];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xb2b2b2) range:NSMakeRange(commentsModel.name.length, 3)];
        self.nameLabel.attributedText = str;
        
//        self.nameLabel.text = [NSString stringWithFormat:@"%@ 回复 %@",commentsModel.name,commentsModel.fatherCommentUserName];
    }
    
    self.timeLabel.text = commentsModel.createTime;
    self.textLab.text = commentsModel.comment;
    [self.textLab setRowSpace:6];
    [self layoutSubviews];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
 
    self.iconView.frame = CGRectMake(10, kMargin + 5, 30, 30);
    
    CGFloat timeW = [self.timeLabel.text widthWithFont:MYFont(11)];
    self.timeLabel.frame = CGRectMake(MYScreenW - timeW - kMargin, kMargin + 5, timeW, 20);
    
    CGFloat nameW = MYScreenW - 50 - timeW - 10;
    self.nameLabel.frame = CGRectMake(50, self.iconView.y,nameW, 20);
    
    
    CGFloat width = MYScreenW - 60;
    CGFloat height = [self.textLab heightWithWidth:width];
    self.textLab.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom + 10, width, height);
    
    self.height = CGRectGetMaxY(self.textLab.frame) + 15;
    
    
}

@end
