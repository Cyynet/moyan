//
//  MYDiaryCommentCell.m
//  魔颜
//
//  Created by Meiyue on 15/12/22.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYDiaryCommentCell.h"

#import "UIButton+Extension.h"
#import "MYHeader.h"
@interface MYDiaryCommentCell ()

@property(weak,nonatomic) UIImageView *iconimage;
@property(weak,nonatomic) UILabel  * nameLabel;
@property(weak,nonatomic) UILabel * commentText;
@property(weak,nonatomic) UIButton * clearBtn;
@property(weak,nonatomic) UILabel * timeLabeltext;

@property(weak,nonatomic) NSString * commentID;

@end

@implementation MYDiaryCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = [NSString stringWithFormat:@"CommentCell%ld",(long)[indexPath row]];
    MYDiaryCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MYDiaryCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        /**用户头像*/
        UIImageView *iconimage = [[UIImageView alloc]init];
        iconimage.layer.borderColor = MYColor(193, 177, 122).CGColor;
        iconimage.layer.borderWidth = 1.0;
        iconimage.layer.cornerRadius = 15;
        iconimage.layer.masksToBounds = YES;
        self.iconimage = iconimage;
        [self.contentView addSubview:iconimage];
        
        
        /**用户名*/
        UILabel *nameLabel = [UILabel addLabelWithTitle:nil titleColor:titlecolor font:leftFont];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        
        //删除按钮
        UIButton *deleteBtn = [UIButton addButtonWithFrame:CGRectZero title:@"删除" backgroundColor:[UIColor whiteColor] titleColor:subTitleColor font:leftFont Target:self action:@selector(clickClearBtn)];
        self.clearBtn = deleteBtn;
        [self.contentView addSubview:deleteBtn];
        
        
        /**正文*/
        UILabel *commentText = [UILabel addLabelWithTitle:nil titleColor:subTitleColor font:leftFont];
        commentText.numberOfLines = 0;
        self.commentText = commentText;
        [self.contentView addSubview:commentText];
        
        
        /**发布时间*/
        UILabel *timeLabel = [UILabel addLabelWithTitle:nil titleColor:subTitleColor font:leftFont];
        self.timeLabeltext = timeLabel;
        [self.contentView addSubview:timeLabel];
        
    }
    
    return self;
}

- (void)setCommentModel:(MYMyDiaryCommentsModel *)commentModel
{
    [self setStatus:commentModel];
    [self setupFrame];
}

-(void)setStatus:(MYMyDiaryCommentsModel *)commentModel
{
    _commentModel = commentModel;
    
    /**用户头像*/
    [self.iconimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,commentModel.userPic]]];
    
    /**用户名字*/
    self.nameLabel.text = commentModel.userName;
    

    /**用户评论*/
    self.commentText.text = commentModel.content;
    
    /**发布时间*/
    self.timeLabeltext.text = commentModel.createTime;
    
}

- (void)setupFrame
{
    self.iconimage.frame = CGRectMake(kMargin, kMargin, 30, 30);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(_iconimage.frame) + kMargin, MYMargin, 100, MYMargin);
    
    CGFloat clearBtny =  kMargin +5;
    CGFloat clearBtnw =  50;
    CGFloat clearBtnx =  MYScreenW - clearBtnw -kMargin;
    self.clearBtn.frame = CGRectMake(clearBtnx, clearBtny, clearBtnw, MYMargin);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.commentText.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.commentText.text.length)];
    self.commentText.attributedText = attributedString;
    
    CGSize maxSize = CGSizeMake( MYScreenW - MYMargin, MAXFLOAT);
    CGSize desLabelSize = [self.commentText sizeThatFits:maxSize];
    CGFloat commentTexty = CGRectGetMaxY(self.iconimage.frame) + kMargin;
    self.commentText.frame = CGRectMake(kMargin ,commentTexty, desLabelSize.width, desLabelSize.height);
    
    
    //    CGFloat desLabelHeight = [self.commentText.text heightWithFont:DeatilContentFont withinWidth:(MYScreenW - MYMargin)];
    //    self.commentText.frame = CGRectMake(kMargin ,CGRectGetMaxY(self.iconimage.frame) + kMargin/2, MYScreenW - MYMargin, desLabelHeight + kMargin);
    
    
    CGFloat timey =  CGRectGetMaxY(self.commentText.frame) + kMargin+10;
    CGFloat timew =  120;
    CGFloat timex =  MYScreenW - timew;
    CGFloat timeh =  kMargin;
    self.timeLabeltext.frame = CGRectMake(timex, timey, timew, timeh);
    
    self.height =  CGRectGetMaxY(self.timeLabeltext.frame) + kMargin+3;
    
}

-(void)clickClearBtn
{
    [MYNotificationCenter postNotificationName:@"deleteMycomment" object:nil userInfo:@{@"MYMycommentDelete" : self.commentModel.id }];
}


@end
