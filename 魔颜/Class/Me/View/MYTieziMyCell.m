  //
//  MYTieziMyCell.m
//  魔颜
//
//  Created by Meiyue on 15/10/27.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYTieziMyCell.h"
#import "MYHeader.h"
#define textcolor MYColor(100, 100, 100)

#define   DeatilTiltleFont   [UIFont fontWithName:@"GillSans-Light" size:10.f];
@interface MYTieziMyCell ()

@property(weak, nonatomic) UIImageView *iconView;
@property(weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIButton *btn;
@property(strong,nonatomic) UILabel * taglable;


@property(weak, nonatomic) UILabel *timeLabel;
@property(weak, nonatomic) UILabel *textLab;


@property(strong,nonatomic) UIImageView * clickimage;

@property(strong,nonatomic) UIImageView * commentimage;
@property(strong,nonatomic) UILabel  * commentcontent;


@property(strong,nonatomic) UIImageView * likeimage;
@property(strong,nonatomic) UILabel * likecontent;


@property(strong,nonatomic) UIImageView * topimage;

@property(strong,nonatomic) UILabel *titleLabel;

/**底部分割线*/
@property (weak, nonatomic) UIView *lineView;


@end

@implementation MYTieziMyCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = [NSString stringWithFormat:@"Tiezi%ld",(long)[indexPath row]];
    MYTieziMyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MYTieziMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //用户头像
        UIImageView *iconView = [[UIImageView alloc] init];
        self.iconView = iconView;
        [self addSubview:iconView];
        
        //用户名
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = leftFont;
        self.nameLabel = nameLabel;
        nameLabel.textColor = titlecolor;
        [self  addSubview:nameLabel];
        
        //帖子里右上角文字
        UILabel *taglable = [[UILabel alloc]init];
        taglable.font = leftFont;
        taglable.textColor = subTitleColor;
        self.taglable = taglable;
        [self addSubview:taglable];
        
        //图片
        MYTieziPhotosView *positionView = [[MYTieziPhotosView alloc] init];
        self.tieziPhotosView = positionView;
        [self.contentView addSubview:positionView];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = MianFont;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel = titleLabel;
        titleLabel.textColor = MYColor(35, 35, 35);
        [self.contentView addSubview:titleLabel];
        
        //正文
        UILabel *textLab = [[UILabel alloc] init];
        textLab.font = MianFont;
        textLab.numberOfLines = 2;
        self.textLab = textLab;
        textLab.textColor = MYColor(61, 61, 61);
        [self.contentView addSubview:textLab];
        
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
        self.timeLabel = timeLabel;
        timeLabel.textColor = subTitleColor;
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView  addSubview:timeLabel];
        
        
        //时间图片
        UIImageView *clickimage =[[ UIImageView alloc]init];
        clickimage.image =[UIImage imageNamed:@"clock"];
        [self addSubview:clickimage];
        self.clickimage = clickimage;
        
        
        
        UILabel  *commentcontent = [[UILabel alloc]init];
        self.commentcontent = commentcontent;
        [self addSubview:commentcontent];
        commentcontent.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
        commentcontent.textColor = [UIColor lightGrayColor];
        
        UIImageView *commentimage =[[ UIImageView alloc]init];
        self.commentimage = commentimage;
        [self addSubview:commentimage];
        commentimage.image = [UIImage imageNamed:@"commen"];
        
        
        
        UIImageView *likeimage = [[UIImageView alloc]init];
        self.likeimage = likeimage;
        [self addSubview:likeimage];
        likeimage.image = [UIImage imageNamed:@"like"];
        
        
        UILabel *likecontent = [[UILabel alloc]init];
        self.likecontent = likecontent;
        [self addSubview:likecontent];
        likecontent.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
        likecontent.textColor = [UIColor lightGrayColor];
        
        
        UIImageView *topimage = [[UIImageView alloc]init];
        topimage.image = [UIImage imageNamed:@"tag"];
        self.topimage = topimage;
        [self addSubview:topimage];
        
        //个人中心里的删除按钮
        UIButton *btn = [[UIButton alloc] init];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btn = btn;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:btn];
        [self.btn setTitle:@"删除" forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(DeleteMyPushTiezi) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         相关推荐
         */
        MYTieziRelatedView *releatedView = [[MYTieziRelatedView alloc] init];
        self.releatedView = releatedView;
        [self addSubview:releatedView];
        
        
        //下面的分割线
        UIView *lineView = [[UIView alloc] init];
        self.lineView = lineView;
        lineView.backgroundColor = lineViewBackgroundColor;
        [self.contentView addSubview:lineView];
        
        
    }
    return self;
}

- (void)setTieziModel:(MYTieziModel *)tieziModel
{
    [self setupStatus:tieziModel];
    [self setupFrame];
    
}
- (void)setupStatus:(MYTieziModel *)tieziModel
{
    _tieziModel = tieziModel;
    
    self.iconView.image = nil;
    self.nameLabel.text = nil;
    self.textLab.text = nil;
    self.timeLabel.text = nil;
    self.btn.titleLabel.text = nil;
    self.taglable.text = nil;
    [self.iconView setCircleHeaderWithURL:[NSString stringWithFormat:@"%@%@",kOuternet1,tieziModel.userPic]];
    
    self.nameLabel.text = tieziModel.userName;
    //    右上角标签
    if (tieziModel.isDetail) {
        //删除或提示标签
        self.btn.hidden = NO;
        self.topimage.image = nil;
    }else if(tieziModel.isAttention) {
        self.btn.hidden = NO;
        self.topimage.image = nil;
        [self.btn setTitle:@"取消关注" forState:UIControlStateNormal];
        
    }else{
        self.btn.hidden = YES;
        NSString *tagtext = [tieziModel.secProCode stringByReplacingOccurrencesOfString:@"," withString:@" "];
        _taglable.text = tagtext;
    }
    //    用空格替换逗号
    self.titleLabel.text = [NSString stringWithFormat:@"【%@】",tieziModel.title];
    self.textLab.text = tieziModel.content;
    [self.textLab setRowSpace:5.0];
    self.timeLabel.text = tieziModel.createTime;
    
    if ([tieziModel.pic isEqualToString:@""]) {
        
    }else{
        
        NSArray  *pictures = [tieziModel.pic componentsSeparatedByString:@","];
        self.tieziPhotosView.pictures = pictures;
    }
    
    self.likecontent.text = [NSString stringWithFormat:@"%@",tieziModel.countPraise];
    self.commentcontent.text = [NSString stringWithFormat:@"%@",tieziModel.countComments];
    
    if (tieziModel.doctorList.count) {
        self.releatedView.doctorItem = tieziModel.doctorList;
    }
    if (tieziModel.speList.count) {
        self.releatedView.specialItem = tieziModel.speList;
    }
    

}

- (void)setupFrame
{
    self.iconView.frame = CGRectMake(10, 5, 30, 30);
    
    // name
    CGFloat nameX = CGRectGetMaxX(self.iconView.frame) + kMargin;
    CGFloat nameY = self.iconView.y + 8;
    
    NSDictionary *dict = @{NSFontAttributeName:leftFont};
    
    CGSize nameSize = [self.nameLabel.text sizeWithAttributes:dict];
    self.nameLabel.frame = (CGRect){nameX,nameY,nameSize};
    
    //标签
    self.btn.frame = CGRectMake(MYScreenW - 100, kMargin + 3,100, 20);
    
    //右上角文字大小
    CGSize tagLabelSize = [self.taglable.text sizeWithAttributes:dict];
    self.taglable.frame = (CGRect){MYScreenW - tagLabelSize.width - kMargin,kMargin + 3,tagLabelSize};
    
    self.topimage.frame = CGRectMake(self.taglable.x - MYMargin, kMargin + 4, 10, 10);
    
    //没有图片
    if ([self.tieziModel.pic isEqualToString:@""]) {
        
        self.titleLabel.frame =  CGRectMake(35, CGRectGetMaxY(self.iconView.frame) + 5, MYScreenW - 35, 30);
    }else{
        
        NSArray  *pictures = [self.tieziModel.pic componentsSeparatedByString:@","];
        CGSize postionViewSize = [MYTieziPhotosView sizeWithItemsCount:pictures.count];
        CGFloat postionViewY = kMargin + CGRectGetMaxY(self.iconView.frame) -5;
        CGFloat postionViewX = CGRectGetMaxX(self.iconView.frame) - 5;
        
        CGFloat postionViewW = postionViewSize.width;
        CGFloat postionViewH = postionViewSize.height;
        
        self.tieziPhotosView.frame = (CGRect){postionViewX,postionViewY,postionViewW,postionViewH};
        
        //有图片时的标题
        self.titleLabel.frame =  CGRectMake(CGRectGetMaxX(self.iconView.frame) - 11, CGRectGetMaxY(self.tieziPhotosView.frame) + 5, MYScreenW - MYMargin, 30);
    }
    
    //正文设置
    CGFloat width = MYScreenW - 2 * MYMargin - 5;
    CGFloat height = [self.textLab heightWithWidth:width];
    self.textLab.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame) - 8, CGRectGetMaxY(self.titleLabel.frame),width, height);
    
    
    CGFloat clickimagex = CGRectGetMaxX(self.iconView.frame) - 8;
    CGFloat clickimagey = CGRectGetMaxY(self.textLab.frame) + kMargin;
    CGFloat clickimagew = kMargin;
    CGFloat clickimageh = kMargin;
    self.clickimage.frame = CGRectMake(clickimagex, clickimagey, clickimagew, clickimageh);
    
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.clickimage.frame) + 3,clickimagey - 3, 150, 15);
    
    
    //    右下角
    CGFloat commentcontenty = clickimagey;
    CGFloat commentcontentw = 20;
    CGFloat commentcontentx = MYScreenW - commentcontentw;
    CGFloat commentcontenth = kMargin;
    self.commentcontent.frame = CGRectMake(commentcontentx, commentcontenty, commentcontentw, commentcontenth);
    
    
    CGFloat commentimagey = clickimagey;
    CGFloat commentimagew = kMargin;
    CGFloat commentimagex = commentcontentx - 13;
    CGFloat commentimageh = kMargin;
    self.commentimage.frame = CGRectMake(commentimagex, commentimagey, commentimagew, commentimageh);
    
    
    CGFloat likecontenty = clickimagey;
    CGFloat likecontentw = 20;
    CGFloat likecontentx = MYScreenW - commentimagew -commentcontentw - likecontentw;
    CGFloat likecontenth = kMargin;
    self.likecontent.frame = CGRectMake(likecontentx, likecontenty, likecontentw, likecontenth);
    
    CGFloat likeimagey = clickimagey;
    CGFloat likeimagew = kMargin;
    CGFloat likeimagex = likecontentx - 13;
    CGFloat likeimageh = kMargin;
    self.likeimage.frame = CGRectMake(likeimagex, likeimagey, likeimagew, likeimageh);

    
    if (self.tieziModel.doctorList.count && self.tieziModel.speList.count) {
        if (MYScreenH==568) {
             self.releatedView.frame = CGRectMake(0, self.timeLabel.bottom + kMargin, MYScreenW, MYScreenH*0.5);
        }else{
        self.releatedView.frame = CGRectMake(0, self.timeLabel.bottom + kMargin, MYScreenW, MYScreenH*0.469);
        }
    }else if(self.tieziModel.doctorList.count == 0 && self.tieziModel.speList.count == 0){
          self.releatedView.frame = CGRectMake(0, self.timeLabel.bottom + kMargin, MYScreenW, 0);
    }else{
        self.releatedView.frame = CGRectMake(0, self.timeLabel.bottom + kMargin, MYScreenW, MYScreenH*0.234);
    }
    
    self.lineView.frame = CGRectMake(0, self.releatedView.height + self.timeLabel.bottom + kMargin, MYScreenW, 0.5);
    self.height = CGRectGetMaxY(self.lineView.frame);


}

//在个人中心 删除我掉发布
-(void)DeleteMyPushTiezi
{
    if (self.tieziModel.isAttention) {
        [MYNotificationCenter postNotificationName:@"cancelTieziAttention" object:nil userInfo:@{@"MYCancelAttention" : self.tieziModel.id }];
    }else{
        
        [MYNotificationCenter postNotificationName:@"deleteMyTiezi" object:nil userInfo:@{@"MyTieziDelete" : self.tieziModel.id }];
    }
    
}
@end
