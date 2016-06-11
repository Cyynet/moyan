//
//  MYHomeDoctorListCell.m
//  魔颜
//
//  Created by abc on 15/11/8.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYHomeDoctorListCell.h"

#import "DWTagList.h"
#import "MYHeader.h"

@interface MYHomeDoctorListCell ()

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



@property(assign,nonatomic) int  height;

@property(strong,nonatomic) UIView * taglistview;
@property(strong,nonatomic) DWTagList *tagList;

@property (strong, nonatomic) DWTagList *lastTagList;

@property(strong,nonatomic) UIView * line;

@end

@implementation MYHomeDoctorListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = [NSString stringWithFormat:@"DoctorList%ld",(long)[indexPath row]];
    MYHomeDoctorListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[MYHomeDoctorListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        左图
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
//        leftlable.backgroundColor = [UIColor redColor];

        
        
        //      name
        UILabel *name = [[UILabel alloc]init];
        self.name = name;
        [self addSubview:name];
        name.textColor = UIColorFromRGB(0x1a1a1a);
        name.font = MYFont(14);
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
        zhichengtitle.font = MYFont(12);
        
        
        UILabel *zhichengcontent= [[UILabel alloc]init];
        self.zhichengcontent = zhichengcontent;
        [self addSubview:zhichengcontent];
        zhichengcontent.text = @"yishebg ";
        zhichengcontent.textColor = subTitleColor;
        zhichengcontent.font = MYFont(12);


 //         编码
        UILabel *codetitle= [[UILabel alloc]init];
        self.codetitle = codetitle;
        [self addSubview:codetitle];
        codetitle.text = @"认证编号:";
        codetitle.textColor = subTitleColor;
        codetitle.font = MYFont(12);
        
        
        UILabel *codecontent= [[UILabel alloc]init];
        self.codecontent = codecontent;
        [self addSubview:codecontent];
        codecontent.text = @"3231213832300";
        codecontent.textColor = subTitleColor;
        codecontent.font = MYFont(12);
        
 
    //  擅长
        UILabel *goodtitle= [[UILabel alloc]init];
        self.goodtitle = goodtitle;
        [self addSubview:goodtitle];
        goodtitle.text = @"擅       长:";
        goodtitle.textColor = subTitleColor;
        goodtitle.font = MYFont(12);
        
        
        UILabel * goodcontent= [[UILabel alloc]init];
        self.goodcontent = goodcontent;
        [self addSubview:goodcontent];
        goodcontent.textColor = subTitleColor;
        goodcontent.numberOfLines = 2;
        goodcontent.textAlignment = NSTextAlignmentLeft;
        goodcontent.font = MYFont(12);

        
        //         编码
        UILabel *impresstitle= [[UILabel alloc]init];
        self.impresstitle = impresstitle;
        [self addSubview:impresstitle];
        impresstitle.text = @"印       象:";
        impresstitle.textColor = subTitleColor;
        impresstitle.font = MYFont(12);
    
        UIView *line = [[UIView alloc]init];
        self.line = line;
        [self addSubview:line];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.4;

        
    }
    return self;
}

-(void)setDoctorListMode:(doctorListModel *)doctorListMode
{
    [self setupStatus:doctorListMode];
    [self setupFrame];
}

-(void)setupStatus:(doctorListModel *)doctorList
{
    
    self.goodcontent.text = nil;
    
    _doctorListMode = doctorList;

    [self.iconimageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,doctorList.listPic]]];
    
    
    self.name.text = doctorList.name;
    
    self.tagimage.image = [UIImage imageNamed:@"weishengburenzheng"];
    
    self.leftlable.text = doctorList.lable;
    self.zhichengcontent.text = doctorList.qualification;
    
    self.codecontent.text = doctorList.docCode;
    
    
    self.goodcontent.text = [NSString stringWithFormat:@"%@",doctorList.goodProject];
   

    
//    标签
    UIView* taglistview = [[UIView alloc]init];
    self.taglistview = taglistview;
    [self addSubview:taglistview];
    
     self.tagList = nil;
     self.lastTagList = nil;
    
    
    //    标签
    DWTagList *tagList = [[DWTagList alloc]init];
    self.tagList = tagList;
    NSString *astring;
    astring = nil;
    astring = doctorList.reputation;
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
       
       self.lastTagList = tagList;
       
    }else
    {
        [tagList setTags:array];
        [self.taglistview addSubview:tagList];
        
        self.lastTagList = tagList;
    }
    
}

-(void)setupFrame
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
//    NSMutableAttributedString *attributedStringleft = [[NSMutableAttributedString alloc]initWithString:self.leftlable.text];
//    NSMutableParagraphStyle *paragraphStyleleft = [[NSMutableParagraphStyle alloc]init];
//    [paragraphStyleleft setLineSpacing:1];
//    [attributedStringleft addAttribute:NSParagraphStyleAttributeName value:paragraphStyleleft range:NSMakeRange(0, self.leftlable.text.length)];
//    self.leftlable.attributedText = attributedStringleft;
//    CGSize maxSizeleft = CGSizeMake(leftlablew, 25);
//    CGSize desLabelSizeleft = [self.leftlable sizeThatFits:maxSizeleft];
//    self.leftlable.frame = CGRectMake(leftlablex, leftlabley, desLabelSizeleft.width, desLabelSizeleft.height);

    self.leftlable.frame = CGRectMake(leftlablex, leftlabley, leftlablew, leftlableh);
    
    
    //  name
    CGFloat namex = CGRectGetMaxX(self.iconimageview.frame)+ kmaragin ;
    CGFloat namey = maragin;
    CGFloat namew = titlewith;
    CGFloat nameh = heighttext;
    self.name.frame = CGRectMake(namex, namey, namew, nameh);
   
    //  认证
    CGFloat tagimagex = MYScreenW - 40- 15;
    CGFloat tagimagey = namey  ;
    CGFloat tagimagew = 39;
    CGFloat tagimageh = 12;
    self.tagimage.frame = CGRectMake(tagimagex, tagimagey, tagimagew, tagimageh);
    
    
    
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
    
    
    CGFloat heightline = CGRectGetMaxY(self.leftlable.frame);
    
    self.line.frame = CGRectMake(0, heightline, MYScreenW, 0.5);
    
    self.highlighted = heightline;

    
}




@end
