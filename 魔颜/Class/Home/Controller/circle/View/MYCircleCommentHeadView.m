//
//  MYCircleCommentHeadView.m
//  魔颜
//
//  Created by Meiyue on 15/10/31.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYCircleCommentHeadView.h"
#import "UIButton+Extension.h"
#import "MYHeader.h"

@interface MYCircleCommentHeadView ()

/*
 @brief 评论
 */
@property(weak, nonatomic) UIImageView *iconView;
@property(weak, nonatomic) UILabel *nameLabel;
@property(weak, nonatomic) UILabel *timeLabel;
@property(weak, nonatomic) UILabel *textLab;
@property (weak, nonatomic) UIView *view;


/** <#注释#> */
@property (weak, nonatomic) UIButton *btn;


@end

@implementation MYCircleCommentHeadView

//创建一个自定义的头部分组视图
+(instancetype)headerWithTableView:(UITableView *)tableView section:(NSInteger )section
{
    //    static NSString *indentifier = @"header";
    NSString *indentifier = [NSString stringWithFormat:@"header%ld",(long)section];
    
    //先到缓存池中去取数据
    MYCircleCommentHeadView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:indentifier];
    
    //如果没有，则自己创建
    if (headerview == nil) {
        headerview = [[MYCircleCommentHeadView alloc]initWithReuseIdentifier:indentifier];
        
    }
    //返回一个头部视图
    return headerview;
}
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    //初始化父类中的构造方法
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        //用户头像
        UIImageView *iconView = [[UIImageView alloc] init];
        self.iconView = iconView;
        [self addSubview:iconView];
        
        //用户名
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = ThemeFont;
        self.nameLabel = nameLabel;
        nameLabel.textColor = titlecolor;
        [self  addSubview:nameLabel];
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = MYFont(11);
        self.timeLabel = timeLabel;
        timeLabel.textColor = UIColorFromRGB(0xb2b2b2);
//        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self  addSubview:timeLabel];
        
        //正文
        UILabel *textLab = [[UILabel alloc] init];
        textLab.font = MYFont(14);
        textLab.numberOfLines = 0;
        textLab.textColor = subTitleColor;
        self.textLab = textLab;
        [self addSubview:textLab];
        
        
        UIButton *btn = [UIButton addButtonWithFrame:CGRectZero backgroundColor:nil Target:self action:@selector(clickHead)];
        [self.contentView addSubview:btn];
        self.btn = btn;
        
      
    }
    return self;
}

- (void)clickHead
{
    
    if (self.headBlock) {
        self.headBlock(self.nameLabel.text);
    }
    
}

- (void)setComment:(MYCircleComment *)comment
{
    [self setupStatus:comment];
    [self setupFrame];
}

- (void)setupStatus:(MYCircleComment *)comment
{
    _comment = comment;
    
    //******************评论 ********************//
    [self.iconView setHeaderWithURL:[NSString stringWithFormat:@"%@%@",kOuternet1,comment.diaryComments.userPic]];
    
    self.nameLabel.text = comment.diaryComments.userName;
    self.timeLabel.text = [comment.diaryComments.createTime substringWithRange:NSMakeRange(5, 11)];
    self.textLab.text = comment.diaryComments.content;
    
}

- (void)setupFrame
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 1, MYScreenW, 0.4)];
    view.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [self addSubview:view];

    self.iconView.frame = CGRectMake(kMargin, kMargin + 5, 30, 30);
    
    // name
    CGFloat nameX = CGRectGetMaxX(self.iconView.frame) + kMargin;
    CGFloat nameY = kMargin + 5;
    
    NSDictionary *dict = @{NSFontAttributeName:ThemeFont};
    CGSize nameSize = [self.nameLabel.text sizeWithAttributes:dict];
    self.nameLabel.frame = (CGRect){nameX,nameY,nameSize};

    CGFloat timeW = [self.timeLabel.text widthWithFont:MYFont(11)];
    self.timeLabel.frame = CGRectMake(MYScreenW - timeW - kMargin, kMargin, timeW, 20);
    
    //正文
    [self.textLab setRowSpace:5];
    CGFloat width = MYScreenW - 60;
    CGFloat height = [self.textLab heightWithWidth:width];
    self.textLab.frame =  CGRectMake(nameX, self.nameLabel.bottom + 5, width, height);
      
    
    self.height = CGRectGetMaxY(self.textLab.frame) + kMargin + 5;
    self.btn.frame = CGRectMake(0, 0, MYScreenW, self.height);

    
}


@end
