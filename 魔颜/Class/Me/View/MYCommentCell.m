//
//  MYCommentCell.m
//  魔颜
//
//  Created by Meiyue on 15/10/9.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYCommentCell.h"
#import "MYCircleComment.h"
#import "NSString+File.h"
#import "MYHeader.h"

#define  textcolor  MYColor(80, 80, 80)

@interface MYCommentCell ()

/*
 @brief 回复
 */

/** 线条 */
@property (weak, nonatomic) UIView *lineView;
@property(weak, nonatomic) UILabel *nameLabel;
/** 时间标签 */
@property (weak, nonatomic) UILabel *timeLabel;
@property(weak, nonatomic)  UILabel *textLab;

@end

@implementation MYCommentCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"Cell%ld",(long)[indexPath row]];
    MYCommentCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYCommentCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
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

- (void)setHostName:(NSString *)hostName
{
    _hostName = hostName;
}

- (void)setReply:(MYCircleReply *)reply
{
    _reply = reply;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 回复 %@",reply.userName,_hostName]];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xb2b2b2) range:NSMakeRange(reply.userName.length, 3)];
    self.nameLabel.attributedText = str;
    
//    self.nameLabel.text = [NSString stringWithFormat:@"%@ 回复 %@",reply.userName,_hostName];
    
    self.timeLabel.text = [reply.createTime substringWithRange:NSMakeRange(5, 11)];
    self.textLab.text = reply.content;
    [self.textLab setRowSpace:6];
    
    [self layoutSubviews];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat nameW = [self.nameLabel.text widthWithFont:ThemeFont];
    self.nameLabel.frame = CGRectMake(50, kMargin + 5,nameW, 20);
    self.lineView.frame = CGRectMake(self.nameLabel.x, 1, MYScreenW, 0.4);
    
    CGFloat timeW = [self.timeLabel.text widthWithFont:MYFont(11)];
    self.timeLabel.frame = CGRectMake(MYScreenW - timeW - kMargin, kMargin + 5, timeW, 20);
    
    
    CGFloat width = MYScreenW - 60;
    CGFloat height = [self.textLab heightWithWidth:width];
    self.textLab.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom + 5, width, height);
    
    self.height = CGRectGetMaxY(self.textLab.frame) + kMargin + 5;
 
    
}


@end
