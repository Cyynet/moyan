//
//  MYAttentionCellTableViewCell.m
//  魔颜
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYAttentionCellTableViewCell.h"
#import "DWTagList.h"
#import "MYHeader.h"
@interface MYAttentionCellTableViewCell ()

@property(weak, nonatomic) UIImageView *iconView;
@property(weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIButton *btn;


@property(weak, nonatomic) UILabel *timeLabel;
@property(weak, nonatomic) UILabel *textLab;


@property(strong,nonatomic) UIImageView * clickimage;


@property(strong,nonatomic) UIImageView * topimage;

@property(strong,nonatomic) UILabel *titleLabel;



#pragma mark 

@property(weak,nonatomic)UIImageView    *iconimageview;
@property(strong,nonatomic) UILabel * leftlable;
@property(strong,nonatomic)  UILabel * name;

@property(strong,nonatomic) UIImageView * tagimage;

@property(strong,nonatomic) UILabel * casetitle;

@property(strong,nonatomic) UILabel * casenumber;

@property(strong,nonatomic) UILabel * zhichengtitle;
@property(strong,nonatomic) UILabel * zhichengcontent;

@property(strong,nonatomic) UILabel *codetitle;
@property(strong,nonatomic) UILabel * codecontent;

@property(strong,nonatomic) UILabel * goodtitle;
@property(strong,nonatomic) UILabel * goodcontent;

@property(strong,nonatomic) UILabel * impresstitle;
@property(strong,nonatomic) UILabel * impresscontentlable1;
@property(strong,nonatomic) UILabel * impresscontentlable2;

@property(strong,nonatomic) UIView * taglistview;
@property(strong,nonatomic) DWTagList *tagList;


@end

@implementation MYAttentionCellTableViewCell

#pragma mark - 初始化

- (void)setAttention:(MYAttention *)attention
{
    _attention = attention;
    
    if (attention.CLASSIFICATION == 1) {
        [self setupTieziStatus:attention];
        [self setupTieziFrame];

    }else{
        [self setupDoctorStatus:attention];
        [self setupDoctorFrame];
    }
}

- (void)setupTieziStatus:(MYAttention *)attention
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,attention.userPic]]];
    
    self.nameLabel.text = attention.userName;
    
    self.titleLabel.text = [NSString stringWithFormat:@"【%@】",attention.title];
    self.textLab.text = attention.content;
    
    self.timeLabel.text = attention.createTime;
    
    if ([attention.pic isEqualToString:@""]) {
        
    }else{
        
        NSArray  *pictures = [attention.pic componentsSeparatedByString:@","];
        self.tieziPhotosView.pictures = pictures;
    }
}

- (void)setupTieziFrame
{
    self.iconView.frame = CGRectMake(10, 5, 30, 30);
    
    // name
    CGFloat nameX = CGRectGetMaxX(self.iconView.frame) + kMargin;
    CGFloat nameY = self.iconView.y + 8;
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0]};
    
    CGSize nameSize = [self.nameLabel.text sizeWithAttributes:dict];
    self.nameLabel.frame = (CGRect){nameX,nameY,nameSize};
    
    //标签
    self.btn.frame = CGRectMake(MYScreenW - 80, kMargin + 3,60, 20);
    
    //没有图片
    if ([self.attention.pic isEqualToString:@""]) {
        
        self.titleLabel.frame =  CGRectMake(35, CGRectGetMaxY(self.iconView.frame) + 5, MYScreenW - 35, 30);
    }else{
        
        NSArray  *pictures = [self.attention.pic componentsSeparatedByString:@","];
        CGSize postionViewSize = [MYTieziPhotosView sizeWithItemsCount:pictures.count];
        CGFloat postionViewY = kMargin + CGRectGetMaxY(self.iconView.frame) -5;
        CGFloat postionViewX = CGRectGetMaxX(self.iconView.frame) - 5;
        
        CGFloat postionViewW = postionViewSize.width;
        CGFloat postionViewH = postionViewSize.height;
        
        self.tieziPhotosView.frame = (CGRect){postionViewX,postionViewY,postionViewW,postionViewH};
        
        //有图片时的标题
        self.titleLabel.frame =  CGRectMake(CGRectGetMaxX(self.iconView.frame) - 11, CGRectGetMaxY(self.tieziPhotosView.frame) + 5, self.width - MYMargin, 30);
    }
    
    
    //正文设置
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.textLab.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.textLab.text.length)];
    self.textLab.attributedText = attributedString;
    CGSize maxSize = CGSizeMake(MYScreenW - 2 * MYMargin - 5, MAXFLOAT);
    CGSize textLabSize = [self.textLab sizeThatFits:maxSize];
    self.textLab.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame) - 8, CGRectGetMaxY(self.titleLabel.frame), textLabSize.width, textLabSize.height);
    
    CGFloat clickimagex = CGRectGetMaxX(self.iconView.frame) - 8;
    CGFloat clickimagey = CGRectGetMaxY(self.textLab.frame) + kMargin;
    CGFloat clickimagew = kMargin;
    CGFloat clickimageh = kMargin;
    self.clickimage.frame = CGRectMake(clickimagex, clickimagey, clickimagew, clickimageh);
    
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.clickimage.frame) + 3,clickimagey - 3, 150, 15);
    
    
    self.height = CGRectGetMaxY(self.timeLabel.frame) +kMargin;


}

- (void)setupDoctorStatus:(MYAttention *)attention
{
    [self.iconimageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,attention.listPic]]];
    
    
    self.name.text = attention.name;
    
    self.tagimage.image = [UIImage imageNamed:@"weishengburenzheng"];
    
    self.leftlable.text = attention.lable;
    self.zhichengcontent.text = attention.qualification;
    
    self.codecontent.text = attention.docCode;
    
    
    self.goodcontent.text = [NSString stringWithFormat:@"%@",attention.goodProject];
    
    
    //    标签
    UIView* taglistview = [[UIView alloc]init];
    self.taglistview = taglistview;
    [self addSubview:taglistview];
      
    //    标签
    DWTagList *tagList = [[DWTagList alloc]init];
    self.tagList = tagList;
    NSString *astring;
    astring = nil;
    astring = attention.reputation;
    NSArray *array = [astring componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    if (array.count == 0) {
        
        return;
    }
    else if (array.count >2) {
        
        NSString *str1 = array[0];
        NSString *str2 = array[1];
        
        NSArray *arr = [NSArray arrayWithObjects:str1,str2,nil];
        [tagList setTags:arr];
        
        [self.taglistview addSubview:tagList];
        
    }else
    {
        [tagList setTags:array];
        [self.taglistview addSubview:tagList];
    }

    
}

- (void)setupDoctorFrame
{
    CGFloat  heighttext = 15;
    CGFloat   titlewith  = 55;
    CGFloat jianju = 3; //上下间距
    CGFloat maragin = 10;
    CGFloat kmaragin = 20;
    
    CGFloat iconimageviewx = maragin;
    CGFloat iconimageviewy =  maragin;
    CGFloat iconimagevieww = 90;
    CGFloat iconimageviewh = 90;
    self.iconimageview.frame = CGRectMake(iconimageviewx, iconimageviewy, iconimagevieww, iconimageviewh);
    
    
    CGFloat leftlabley =   CGRectGetMaxY(self.iconimageview.frame) +3;
    CGFloat leftlablex =    maragin;
    CGFloat leftlablew =    iconimagevieww ;
    CGFloat leftlableh  = maragin*2;
      self.leftlable.frame = CGRectMake(leftlablex, leftlabley, leftlablew, leftlableh);
    
    
    //  name
    CGFloat namex = CGRectGetMaxX(self.iconimageview.frame)+ kmaragin ;
    CGFloat namey = maragin;
    CGFloat namew = titlewith;
    CGFloat nameh = heighttext;
    self.name.frame = CGRectMake(namex, namey, namew, nameh);
    
    //标签
    self.btn.frame = CGRectMake(MYScreenW - 80, kMargin + 3,60, 20);
    
    
    //  职称
    CGFloat zhichengtitlex = CGRectGetMaxX(self.iconimageview.frame) + kmaragin;
    CGFloat zhichengtitley = CGRectGetMaxY(self.name.frame)  + jianju;
    CGFloat zhichengtitlew =  titlewith;
    CGFloat zhichengtitleh =  heighttext;
    self.zhichengtitle.frame = CGRectMake(zhichengtitlex, zhichengtitley, zhichengtitlew, zhichengtitleh);
    
    
    CGFloat zhichengcontentx = CGRectGetMaxX(self.zhichengtitle.frame) ;
    CGFloat zhichengcontenty = zhichengtitley;
    CGFloat zhichengcontentw = MYScreenW - iconimagevieww - zhichengtitlew - maragin *2;
    CGFloat zhichengcontenth = heighttext;
    self.zhichengcontent.frame = CGRectMake(zhichengcontentx, zhichengcontenty, zhichengcontentw, zhichengcontenth);
    
    
    
    // 编号
    CGFloat codetitlex = CGRectGetMaxX(self.iconimageview.frame) + kmaragin;
    CGFloat codetitley = CGRectGetMaxY(self.zhichengtitle.frame) +jianju;
    CGFloat codetitlew = titlewith;
    CGFloat codetitleh = heighttext;
    self.codetitle.frame = CGRectMake(codetitlex, codetitley, codetitlew, codetitleh);
        
    CGFloat codecontentx = CGRectGetMaxX(self.codetitle.frame) ;
    CGFloat codecontenty = codetitley;
    CGFloat codecontentw = MYScreenW - iconimagevieww - codetitlew - maragin  *2;
    CGFloat codecontenth = heighttext;
    self.codecontent.frame = CGRectMake(codecontentx, codecontenty, codecontentw, codecontenth);
    
    
    
    //     擅长
    CGFloat goodtitlex = CGRectGetMaxX(self.iconimageview.frame) + kmaragin;
    CGFloat goodtitley = CGRectGetMaxY(self.codetitle.frame) + jianju;
    CGFloat goodtitlew = titlewith;
    CGFloat goodtitleh = heighttext;
    self.goodtitle.frame = CGRectMake(goodtitlex, goodtitley, goodtitlew, goodtitleh);
    
    
    
    CGFloat goodcontentx = CGRectGetMaxX(self.goodtitle.frame);
    CGFloat goodcontenty =  CGRectGetMaxY(self.codetitle.frame) + jianju;
    CGFloat goodcontentw = MYScreenW - iconimagevieww  - kmaragin *2 - maragin-goodtitlew +10;

    
    NSMutableAttributedString *attributedStringgood = [[NSMutableAttributedString alloc]initWithString:self.goodcontent.text];
    NSMutableParagraphStyle *paragraphStylegood= [[NSMutableParagraphStyle alloc]init];
    [paragraphStylegood setLineSpacing:2];
    [attributedStringgood addAttribute:NSParagraphStyleAttributeName value:paragraphStylegood range:NSMakeRange(0, self.goodcontent.text.length)];
    self.goodcontent.attributedText = attributedStringgood;
    CGSize maxSizegood = CGSizeMake(goodcontentw, 28);
    CGSize desLabelSizegood= [self.goodcontent sizeThatFits:maxSizegood];
    self.goodcontent.frame =  CGRectMake(goodcontentx , goodcontenty, desLabelSizegood.width, desLabelSizegood.height );
    
    
    //  印象
    CGFloat impresstitlex = CGRectGetMaxX(self.iconimageview.frame) +kmaragin;
    CGFloat impresstitley = CGRectGetMaxY(self.goodcontent.frame)+ jianju + 2 ;
    CGFloat impresstitlew = titlewith;
    CGFloat impresstitleh = heighttext;
    self.impresstitle.frame = CGRectMake(impresstitlex, impresstitley, impresstitlew, impresstitleh);
    
    
    CGFloat taglistviewx = CGRectGetMaxX(self.iconimageview.frame) + 8  +titlewith ;
    CGFloat taglistviewy = impresstitley ;
    CGFloat taglistvieww = MYScreenW - iconimagevieww - kmaragin *3;
    CGFloat taglistviewh = maragin - 2;
    self.taglistview.frame = CGRectMake(taglistviewx, taglistviewy, taglistvieww, taglistviewh);
    
    self.height = 125;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = [NSString stringWithFormat:@"Cell%ld",(long)[indexPath row]];
    MYAttentionCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MYAttentionCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initWithTiezi];
        [self initWithDoctor];
      }
    return self;
}

- (void)initWithTiezi
{
    //用户头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.cornerRadius = 15;
    iconView.layer.masksToBounds = YES;
    iconView.layer.borderColor = [UIColor lightGrayColor] .CGColor;
    iconView.layer.borderWidth = 0.5;
    self.iconView = iconView;
    [self addSubview:iconView];
    
    //用户名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
    self.nameLabel = nameLabel;
    nameLabel.textColor = titlecolor;
    [self  addSubview:nameLabel];
    
    //图片
    MYTieziPhotosView *positionView = [[MYTieziPhotosView alloc] init];
    self.tieziPhotosView = positionView;
    [self.contentView addSubview:positionView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel = titleLabel;
    titleLabel.textColor = MYColor(35, 35, 35);
    [self.contentView addSubview:titleLabel];
    
    //正文
    UILabel *textLab = [[UILabel alloc] init];
    textLab.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
    textLab.numberOfLines = 2;
    self.textLab = textLab;
    textLab.textColor = MYColor(61, 61, 61);
    [self.contentView addSubview:textLab];
    
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
    self.timeLabel = timeLabel;
    timeLabel.textColor = subTitleColor;
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView  addSubview:timeLabel];
    
    
    //时间图片
    UIImageView *clickimage =[[ UIImageView alloc]init];
    clickimage.image =[UIImage imageNamed:@"clock"];
    [self addSubview:clickimage];
    self.clickimage = clickimage;
    
    

    
    //个人中心里的删除按钮
    UIButton *btn = [[UIButton alloc] init];
    btn.layer.borderColor = MYColor(193, 177, 122).CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btn = btn;
    btn.titleLabel.font = leftFont;
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    [self.btn setTitle:@"取消关注" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(DeleteGuanzhuTiezi) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)initWithDoctor
{
    //  左图
    UIImageView *iconimageview = [[UIImageView alloc]init];
    self.iconimageview = iconimageview;
    [self addSubview:iconimageview];
    
    
    UILabel *leftlable = [[UILabel alloc]init];
    self.leftlable = leftlable;
    [self addSubview:leftlable];
    leftlable.numberOfLines = 2;
    leftlable.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:8.0];
    leftlable.textColor = subTitleColor;
    leftlable.textAlignment = NSTextAlignmentCenter;

    
    
    
    //      name
    UILabel *name = [[UILabel alloc]init];
    self.name = name;
    [self addSubview:name];
    name.textColor = titlecolor;
    name.font = leftFont;
    name.textAlignment = NSTextAlignmentLeft;
    
    
    
    //        认证
    UIImageView *tagimage = [[UIImageView alloc]init];
    self.tagimage =tagimage;
    [self addSubview:tagimage];
    
    //        职称
    UILabel *zhichengtitle= [[UILabel alloc]init];
    self.zhichengtitle = zhichengtitle;
    [self addSubview:zhichengtitle];
    zhichengtitle.text = @"职       称:";
    zhichengtitle.textColor = subTitleColor;
    zhichengtitle.font = leftFont;
    
    
    UILabel *zhichengcontent= [[UILabel alloc]init];
    self.zhichengcontent = zhichengcontent;
    [self addSubview:zhichengcontent];
    zhichengcontent.text = @"yishebg ";
    zhichengcontent.textColor = subTitleColor;
    zhichengcontent.font = leftFont;
    
    
    //         编码
    UILabel *codetitle= [[UILabel alloc]init];
    self.codetitle = codetitle;
    [self addSubview:codetitle];
    codetitle.text = @"认证编号:";
    codetitle.textColor = subTitleColor;
    codetitle.font = leftFont;
    
    
    UILabel *codecontent= [[UILabel alloc]init];
    self.codecontent = codecontent;
    [self addSubview:codecontent];
    codecontent.text = @"3231213832300";
    codecontent.textColor = subTitleColor;
    codecontent.font = leftFont;
    
    
    //        擅长
    UILabel *goodtitle= [[UILabel alloc]init];
    self.goodtitle = goodtitle;
    [self addSubview:goodtitle];
    goodtitle.text = @"擅       长:";
    goodtitle.textColor = subTitleColor;
    goodtitle.font = leftFont;
    
    
    UILabel * goodcontent= [[UILabel alloc]init];
    self.goodcontent = goodcontent;
    [self addSubview:goodcontent];
    goodcontent.textColor = subTitleColor;
    goodcontent.numberOfLines = 2;
    goodcontent.textAlignment = NSTextAlignmentLeft;
    goodcontent.font = leftFont;
    
    
    //         编码
    UILabel *impresstitle= [[UILabel alloc]init];
    self.impresstitle = impresstitle;
    [self addSubview:impresstitle];
    impresstitle.text = @"印       象:";
    impresstitle.textColor = subTitleColor;
    impresstitle.font = leftFont;
    
}

-(void)DeleteGuanzhuTiezi
{
    if (self.attention.CLASSIFICATION == 3) {
       
        [MYNotificationCenter postNotificationName:@"cancelTieziAttention" object:nil userInfo:@{@"MYCancelAttention" : self.attention.id , @"type" : @"2" }];
        
    }else if (self.attention.CLASSIFICATION == 1){
    
        [MYNotificationCenter postNotificationName:@"cancelTieziAttention" object:nil userInfo:@{@"MYCancelAttention" : self.attention.id ,@"type" : @"0" }];

    }
    
    
    
}
@end
