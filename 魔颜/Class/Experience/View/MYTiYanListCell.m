//
//  MYTiYanListCell.m
//  魔颜
//
//  Created by abc on 16/5/3.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYTiYanListCell.h"
#import "NSString+Extension.h"
#import "MYHeader.h"


@interface MYTiYanListCell ()

@property(strong,nonatomic) UIImageView* iconimage;

@property(strong,nonatomic) UILabel * namelable;

@property(strong,nonatomic) UIButton *  xiaobianlable;

@property(strong,nonatomic) UILabel * agelable;

@property(strong,nonatomic) UILabel * fuzhilable;

@property(strong,nonatomic) UILabel * historylable;

@property(strong,nonatomic) UIImageView * bigimage;

@property(strong,nonatomic) UIView * coverview;

@property(strong,nonatomic) UILabel * coverlable;

@property(strong,nonatomic) UILabel * biaoqianlable;

@property(strong,nonatomic) UILabel * timelable;

@property(strong,nonatomic) UILabel * organizationlable;

@property(strong,nonatomic) UIView * line1;

@property(strong,nonatomic) UIView * boomview;

@property(strong,nonatomic) UILabel * readernumber;

@property(strong,nonatomic) UIImageView * readerimage;

@property(strong,nonatomic) UIImageView * markimage;

@end

@implementation MYTiYanListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = [NSString stringWithFormat:@"TiyanList--%ld",(long)[indexPath row]];
    MYTiYanListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MYTiYanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UIImageView *iconimage = [[UIImageView alloc]init];
        [self.contentView addSubview:iconimage];
        iconimage.layer.cornerRadius = 17.5;
        iconimage.layer.masksToBounds = YES;
//        iconimage.image = [UIImage imageNamed:@""];
        self.iconimage =iconimage;
        
        UILabel * namelable  = [[UILabel alloc]init];
        [self.contentView addSubview:namelable];
        namelable.text =@"文森特";
        namelable.font = MYFont(14);
        namelable.textColor = UIColorFromRGB(0x333333);
        self.namelable = namelable;
        
        
        UIButton * xiaobianlable  = [[UIButton alloc]init];
        [self.contentView addSubview:xiaobianlable];
        [xiaobianlable setTitle:@"小编" forState:UIControlStateNormal];
        xiaobianlable.titleLabel.font = MYFont(12);
        [xiaobianlable setTitleColor:UIColorFromRGB(0xed0381) forState:UIControlStateNormal];
        self.xiaobianlable = xiaobianlable;
        [xiaobianlable setImage:[UIImage imageNamed:@"huangguan"] forState:UIControlStateNormal];
        xiaobianlable.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        xiaobianlable.imageEdgeInsets = UIEdgeInsetsMake(-1, 0, 0, 0);
        
        NSMutableAttributedString *agestr = [[NSMutableAttributedString alloc] initWithString:@"年龄 29"];
        UILabel * agelable  = [[UILabel alloc]init];
        [self.contentView addSubview:agelable];
        agelable.attributedText =  agestr;
        agelable.font = MYFont(12);
        agelable.textColor = UIColorFromRGB(0x808080);
        [agestr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4c4c4c) range:NSMakeRange(1,2)];
        self.agelable = agelable;
        
        

//        肤质
          NSMutableAttributedString *fuzhistr = [[NSMutableAttributedString alloc] initWithString:@"肤质 油性"];
        UILabel * fuzhilable  = [[UILabel alloc]init];
        [self.contentView addSubview:fuzhilable];
        fuzhilable.attributedText = fuzhistr;
        fuzhilable.font = MYFont(12);
        fuzhilable.textColor = UIColorFromRGB(0x808080);
        [agestr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4c4c4c) range:NSMakeRange(1,2)];
        self.fuzhilable = fuzhilable;
        
        NSMutableAttributedString *historystr = [[NSMutableAttributedString alloc] initWithString:@"美容史 6年"];
        UILabel * historylable  = [[UILabel alloc]init];
        [self.contentView addSubview:historylable];
        historylable.attributedText = historystr;
        historylable.font = MYFont(12);
        historylable.textColor = UIColorFromRGB(0x808080);
        [agestr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4c4c4c) range:NSMakeRange(1,2)];
        self.historylable = historylable;
        
//        大图
        UIImageView *bigimage = [[UIImageView alloc]init];
        [self.contentView addSubview:bigimage];
//        bigimage.image = [UIImage imageNamed:@"big"];
        self.bigimage  = bigimage;
        
        UIImageView *markimage = [[UIImageView alloc]init];
        [self.contentView addSubview:markimage];
        self.markimage = markimage;
//        markimage.image = [UIImage imageNamed:@"qianggou"];
        
        
        UIView *coverview = [[UIView alloc]init];
        coverview.backgroundColor  =[UIColor whiteColor];
        coverview.alpha = 0.7;
        [bigimage addSubview:coverview];
        self.coverview = coverview;
        
        
        UILabel * coverlable  = [[UILabel alloc]init];
        [coverview addSubview:coverlable];
        coverlable.text =@"传说中的永久脱毛是真的吗?";
        coverlable.font = MYFont(14);
        coverlable.textColor = UIColorFromRGB(0x1a1a1a);
        self.coverlable = coverlable;
        
        UILabel * biaoqianlable  = [[UILabel alloc]init];
        [self.contentView addSubview:biaoqianlable];
//        biaoqianlable.text =@"永久脱毛";
        biaoqianlable.layer.cornerRadius = 3;
        biaoqianlable.layer.borderWidth = 1;
        biaoqianlable.layer.masksToBounds = YES;
        biaoqianlable.layer.borderColor = UIColorFromRGB(0xed0381).CGColor;
        biaoqianlable.font = leftFont;
        biaoqianlable.textColor = UIColorFromRGB(0xed0381);
        self.biaoqianlable = biaoqianlable;
        biaoqianlable.textAlignment = NSTextAlignmentCenter;
        
        
        
        UILabel * timelable  = [[UILabel alloc]init];
        [self.contentView addSubview:timelable];
        timelable.text =@"2016.05.23";
        timelable.font = MYFont(11);
        timelable.textColor = UIColorFromRGB(0x4c4c4c);
        self.timelable = timelable;
        
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = UIColorFromRGB(0x969696);
        [self.contentView addSubview:line1];
        self.line1 = line1;
        
        
        UILabel *readernumber = [[UILabel alloc]init];
        [self.contentView addSubview:readernumber];
        self.readernumber = readernumber;
        readernumber.font = MYFont(11);
        readernumber.textColor = UIColorFromRGB(0x4c4c4c);
        
        
        UIImageView *readerimage = [[UIImageView alloc]init];
        [self.contentView addSubview:readerimage];
        self.readerimage = readerimage;
        readerimage.image = [UIImage imageNamed:@"eye"];
        
//        [readernumber setTitleColor:UIColorFromRGB(0x4c4c4c) forState:UIControlStateNormal];
//        [self.readernumber setImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateNormal];
//        self.readernumber.imageEdgeInsets = UIEdgeInsetsMake(3, -8, 0, -5);
        
        
        UILabel * organizationlable  = [[UILabel alloc]init];
        [self.contentView addSubview:organizationlable];
        organizationlable.text =@"［咪咪国际美容服务机构］";
        organizationlable.font = leftFont;
        organizationlable.textColor = UIColorFromRGB(0x808080);
        self.organizationlable = organizationlable;
        
        
        
        UIView *boomview = [[UIView alloc]init];
        [self.contentView addSubview:boomview];
        boomview.backgroundColor = UIColorFromRGB(0xf7f7f7);
        self.boomview = boomview;
    }
    return self;
}

-(void)setTiyanmodle:(MYTiYanListModle *)tiyanmodle
{
    _tiyanmodle = tiyanmodle;
    
//    (0官方 1个人 2美容院 3医院)
    if ([tiyanmodle.type isEqualToString:@"0"]) {
        self.xiaobianlable.hidden = NO;
    }else{
        self.xiaobianlable.hidden = YES;
    }
    
    if (!NULLString(tiyanmodle.marking)) {
            [self.markimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,tiyanmodle.marking]]];
    }
    
    [self.iconimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,tiyanmodle.userPic]]];
    self.namelable.text =  tiyanmodle.userName;
    
    NSString *age = [NSString stringWithFormat:@"年龄  %@",tiyanmodle.age];
    NSMutableAttributedString *agestr = [[NSMutableAttributedString alloc] initWithString:age];
    [agestr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4c4c4c) range:NSMakeRange(0,2)];
    self.agelable.attributedText = agestr;
    
    
    NSString *fuzhi = [NSString stringWithFormat:@"肤质  %@",tiyanmodle.skin];
    NSMutableAttributedString *fuzhistr = [[NSMutableAttributedString alloc] initWithString:fuzhi];
    [fuzhistr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4c4c4c) range:NSMakeRange(0,2)];
    self.fuzhilable.attributedText = fuzhistr;
    
    
    NSString *histroy = [NSString stringWithFormat:@"美容史  %@年",tiyanmodle.beautyHistory];
    NSMutableAttributedString *histroystr = [[NSMutableAttributedString alloc] initWithString:histroy];
    [histroystr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4c4c4c) range:NSMakeRange(0,3)];
    self.historylable.attributedText  = histroystr;
    
    
    [self.bigimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,tiyanmodle.homePic]]];
    
    self.coverlable.text = tiyanmodle.noteTitle;
    
    self.biaoqianlable.text = tiyanmodle.project;
    [_biaoqianlable setColumnSpace:1.5];
    
    self.organizationlable.text = [NSString stringWithFormat:@"[%@]",tiyanmodle.serviceName];
    
    if (!NULLString(tiyanmodle.createTime)) {
        
        NSArray * timearr = [tiyanmodle.createTime componentsSeparatedByString:@" "];
        NSArray *timestr = [timearr[0] componentsSeparatedByString:@"-"];
        self.timelable.text = [NSString stringWithFormat:@"%@.%@.%@",timestr[0],timestr[1],timestr[2]];
    }
    
    self.readernumber.text = tiyanmodle.readNumbers;
    

}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat height = 15;

    self.iconimage.frame = CGRectMake(kMargin, kMargin, 35, 35);
    
    CGFloat namewidth = [self.namelable.text widthWithFont:MYFont(14)];
    self.namelable.frame = CGRectMake(kMargin+self.iconimage.right, kMargin, namewidth, height);
    
    self.xiaobianlable.frame = CGRectMake(kMargin/2+self.namelable.right, kMargin, 60, height);
    
    self.agelable.frame = CGRectMake(kMargin+self.iconimage.right, self.namelable.bottom+kMargin/2, 50, height);

    CGFloat fuzhiwidth = [self.fuzhilable.text widthWithFont:MYFont(12)];
    self.fuzhilable.frame = CGRectMake(kMargin+self.agelable.right, self.agelable.y, fuzhiwidth, height);
    
    CGFloat historywidth = [self.historylable.text widthWithFont:MYFont(12)];
    self.historylable.frame = CGRectMake(kMargin+self.fuzhilable.right, self.agelable.y, historywidth, height);
    
    self.markimage.frame = CGRectMake( kMargin-4,self.iconimage.bottom+kMargin-4,47,48);
    
    self.bigimage.frame = CGRectMake( kMargin,self.iconimage.bottom+kMargin, MYScreenW-MYMargin, 217);
    
    self.coverview.frame = CGRectMake(0, self.bigimage.height - 40, self.bigimage.width, 40);
    
    self.coverlable.frame = CGRectMake(kMargin/2, 0, self.bigimage.width, 40);
    
    CGFloat timewidth = [self.timelable.text widthWithFont:MYFont(11)];
    CGFloat readernumberwidth = [self.readernumber.text widthWithFont:MYFont(11)];
    
    CGFloat biaoqianwidth = [self.biaoqianlable.text widthWithFont:leftFont];
    self.biaoqianlable.frame = CGRectMake(kMargin, self.bigimage.bottom+kMargin,biaoqianwidth+MYMargin+8, height+5);
    
    

    self.timelable.frame = CGRectMake(MYScreenW -kMargin-timewidth,self.bigimage.bottom+kMargin,timewidth ,height);

    self.line1.frame = CGRectMake(MYScreenW-kMargin-timewidth-5, self.timelable.y+2.5, 1, height-5);
    
   
    self.readernumber.frame = CGRectMake(MYScreenW-kMargin*2-timewidth-readernumberwidth, self.timelable.y, readernumberwidth, height);
    
    self.readerimage.frame = CGRectMake(MYScreenW-timewidth-readernumberwidth-kMargin*2-20, self.timelable.y+3, 15, 9);
    
    self.organizationlable.frame = CGRectMake(kMargin,self.biaoqianlable.bottom+kMargin ,200 ,height);
 
    self.boomview.frame = CGRectMake(0,self.organizationlable.bottom+kMargin ,MYScreenW ,kMargin);
    
}

@end
