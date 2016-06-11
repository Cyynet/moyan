//
//  MYHomeDesignerCell.m
//  魔颜
//
//  Created by abc on 15/11/20.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYHomeDesignerListCell.h"
#import "MYHeader.h"
#define titlefont [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
#define deatiltextcolor  MYColor(109, 109, 109)

@interface MYHomeDesignerListCell ()


@property(weak,nonatomic)UIImageView    *iconimageview;

@property(strong,nonatomic)  UILabel * name;

@property(strong,nonatomic) UIImageView * renzheng;

@property(strong,nonatomic) UILabel * zhizititle;
@property(strong,nonatomic) UILabel * zhizicontent;

@property(strong,nonatomic) UILabel * jigoutitle;
@property(strong,nonatomic) UILabel * jigoucontent;

@property(strong,nonatomic) UILabel * timetitle;
@property(strong,nonatomic) UILabel * timecontent;

@property(strong,nonatomic) UILabel * casetitle;
@property(strong,nonatomic) UILabel * casecontent;


@property(strong,nonatomic) UILabel * teselable;


@property(strong,nonatomic) UIView * line;


@property(assign,nonatomic) int  height;

@end

@implementation MYHomeDesignerListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = [NSString stringWithFormat:@"Design%ld",(long)[indexPath row]];
    MYHomeDesignerListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[MYHomeDesignerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        
        
        //      name
        UILabel *name = [[UILabel alloc]init];
        self.name = name;
        [self addSubview:name];
        name.textColor = titlecolor;
        name.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
        name.textAlignment = NSTextAlignmentLeft;
        
        
        //       认证
        UIImageView *renzheng = [[UIImageView alloc]init];
        renzheng.contentMode = UIViewContentModeScaleAspectFill;
        self.renzheng = renzheng;
        [self addSubview:renzheng];
        renzheng.image = [UIImage resizableImage:@"moyanrenzheng"];
        
        
        //        资质
        UILabel *zhizititle= [[UILabel alloc]init];
        self.zhizititle = zhizititle;
        [self addSubview:zhizititle];
        zhizititle.text = @"资质:";
        zhizititle.textColor = subTitleColor;
        zhizititle.font = titlefont
        
        
        UILabel *zhizicontent= [[UILabel alloc]init];
        self.zhizicontent = zhizicontent;
        [self addSubview:zhizicontent];
        zhizicontent.numberOfLines = 2;
        zhizicontent.textColor = subTitleColor;
        zhizicontent.font = titlefont;
        
        
        //      机构
        UILabel *jigoutitle= [[UILabel alloc]init];
        self.jigoutitle = jigoutitle;
        [self addSubview:jigoutitle];
        jigoutitle.text = @"机构:";
        jigoutitle.textColor =  subTitleColor;
        jigoutitle.font = titlefont
        
        
        
        UILabel *jigoucontent= [[UILabel alloc]init];
        self.jigoucontent = jigoucontent;
        [self addSubview:jigoucontent];
        jigoucontent.numberOfLines = 0;
        jigoucontent.textColor = subTitleColor;
        jigoucontent.font = titlefont;
        
        
        
        //     时间
        UILabel * timetitle= [[UILabel alloc]init];
        self.timetitle = timetitle;
        [self addSubview:timetitle];
        timetitle.text = @"时间:";
        timetitle.textColor = subTitleColor;
        timetitle.numberOfLines = 2;
        timetitle.textAlignment = NSTextAlignmentLeft;
        timetitle.font = titlefont;
        
        
        UILabel *timecontent= [[UILabel alloc]init];
        self.timecontent = timecontent;
        [self addSubview:timecontent];
        timecontent.numberOfLines = 0;
        timecontent.textColor = subTitleColor;
        timecontent.font = titlefont;
        
        
//        案例
        UILabel * casetitle= [[UILabel alloc]init];
        self.casetitle = casetitle;
        [self addSubview:casetitle];
        casetitle.text = @"案例:";
        casetitle.textColor = subTitleColor;
        casetitle.numberOfLines = 2;
        casetitle.textAlignment = NSTextAlignmentLeft;
        casetitle.font = titlefont;

        
        UILabel *teselable = [[UILabel alloc]init];
        self.teselable = teselable;
        [self addSubview:teselable];
        teselable.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:9.0];
        teselable.textColor = deatiltextcolor;
        teselable.textAlignment = NSTextAlignmentCenter;
        
        
        
        UIView *line = [[UIView alloc]init];
        self.line = line;
        [self addSubview:line];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.4;
    }
    
    return self;
    
}

-(void)setDesignerModel:(designerListModel *)designerModel
{

    [self setupListdesignermodel:designerModel];
    [self setupFrame];
    
}


-(void)setupListdesignermodel:(designerListModel *)designermodel
{

    _designerModel = designermodel;
    
    [self.iconimageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,designermodel.avatar]]];
    self.name.text = designermodel.name;
    self.renzheng.image = [UIImage imageNamed:@"moyanrenzheng"];
    self.zhizicontent.text = designermodel.qualification;
    self.jigoucontent.text = designermodel.agency;
    self.timetitle.text = [NSString stringWithFormat:@"时间:   %@-%@",designermodel.startTime,designermodel.endTime] ;
    self.casetitle.text = [NSString stringWithFormat:@"案例:   %@个案例",designermodel.caseNum] ;
    self.teselable.text = designermodel.features;
    
}

-(void)setupFrame
{
    CGFloat  heighttext = 15;
    CGFloat   titlewith  = 35;
    
    CGFloat maragin = 10/2;
    CGFloat kmaragin = 20;
    
    CGFloat iconimageviewx = maragin + 5;
    CGFloat iconimageviewy = maragin ;
    CGFloat iconimagevieww = 100;
    CGFloat iconimageviewh = 100;
    self.iconimageview.frame = CGRectMake(iconimageviewx, iconimageviewy, iconimagevieww, iconimageviewh);
    
    
    //  特色
    CGFloat teselablex =  10;
    CGFloat teselabley =  CGRectGetMaxY(self.iconimageview.frame) ;
    CGFloat teselablew =  iconimagevieww;
    CGFloat teselableh = heighttext;
    self.teselable.frame = CGRectMake(teselablex, teselabley, teselablew, teselableh);

    
    //  name
    CGFloat namex = CGRectGetMaxX(self.iconimageview.frame)+ kmaragin/2 ;
    CGFloat namey = maragin;
    CGFloat namew = 120;
    CGFloat nameh = heighttext;
    self.name.frame = CGRectMake(namex, namey, namew, nameh);
    
    //  认证
    CGFloat tagimagex = MYScreenW - 30 - 15;
    CGFloat tagimagey = maragin + 2;
    CGFloat tagimagew = 30;
    CGFloat tagimageh = 12;
    self.renzheng.frame = CGRectMake(tagimagex, tagimagey, tagimagew, tagimageh);
    
    
    //   资质
    CGFloat zhizititlex = namex;
    CGFloat zhizititley = CGRectGetMaxY(self.name.frame)+maragin/2;
    CGFloat zhizititlew = titlewith ;
    CGFloat zhizititleh = heighttext;
    self.zhizititle.frame = CGRectMake(zhizititlex, zhizititley, zhizititlew, zhizititleh);
    
    
    CGFloat zhizicontentx = CGRectGetMaxX(self.zhizititle.frame);
    CGFloat zhizicontenty =  zhizititley+1  ;
    CGFloat zhizicontentw = MYScreenW - iconimagevieww - zhizititlew - maragin *6;
    NSMutableAttributedString *attributedStringzhizi = [[NSMutableAttributedString alloc]initWithString:self.zhizicontent.text];
    NSMutableParagraphStyle *paragraphStylezhizi = [[NSMutableParagraphStyle alloc]init];
    [paragraphStylezhizi setLineSpacing:2];
    [attributedStringzhizi addAttribute:NSParagraphStyleAttributeName value:paragraphStylezhizi range:NSMakeRange(0, self.zhizicontent.text.length)];
    self.zhizicontent.attributedText = attributedStringzhizi;
    CGSize maxSizezhizi = CGSizeMake(zhizicontentw, 28);
    CGSize desLabelSizezhizi = [self.zhizicontent sizeThatFits:maxSizezhizi];
    self.zhizicontent.frame = CGRectMake(zhizicontentx, zhizicontenty, desLabelSizezhizi.width, desLabelSizezhizi.height);
    
    
    
    //    机构
    CGFloat jigoutitlex = namex ;
    CGFloat jigoutitley = CGRectGetMaxY(self.zhizicontent.frame)+5;
    CGFloat jigoutitlew = titlewith;
    CGFloat jigoutitleh = heighttext;
    self.jigoutitle.frame = CGRectMake(jigoutitlex, jigoutitley, jigoutitlew, jigoutitleh);
    
    
    CGFloat jigoucontentx = CGRectGetMaxX(self.jigoutitle.frame);
    CGFloat jigoucontenty =  jigoutitley +2;
    CGFloat jigoucontentw = MYScreenW - iconimagevieww - kmaragin *4 +10+5;
    NSMutableAttributedString *attributedStringjigou = [[NSMutableAttributedString alloc]initWithString:self.jigoucontent.text];
    NSMutableParagraphStyle *paragraphStylejigou = [[NSMutableParagraphStyle alloc]init];
    [paragraphStylejigou setLineSpacing:2];
    [attributedStringjigou addAttribute:NSParagraphStyleAttributeName value:paragraphStylejigou range:NSMakeRange(0, self.jigoucontent.text.length)];
    self.jigoucontent.attributedText = attributedStringjigou;
    CGSize maxSizejigou = CGSizeMake(jigoucontentw, 28);
    CGSize desLabelSizejigou = [self.jigoucontent sizeThatFits:maxSizejigou];
  self.jigoucontent.frame =  CGRectMake(jigoucontentx , jigoucontenty, desLabelSizejigou.width, desLabelSizejigou.height);

 
//    时间
    CGFloat timetitlex = namex  ;
    CGFloat timetitley = CGRectGetMaxY(self.jigoucontent.frame) +5;
    CGFloat timetitlew = MYScreenW - iconimagevieww - tagimagew - maragin *2;
    CGFloat timetitleh = heighttext;
    self.timetitle.frame = CGRectMake(timetitlex, timetitley, timetitlew, timetitleh);
    
   
    //    案例
    CGFloat casetitlex = namex  ;
    CGFloat casetitley = CGRectGetMaxY(self.timetitle.frame) +5;
    CGFloat casetitlew = MYScreenW - iconimagevieww - tagimagew - maragin *2;
    CGFloat casetitleh = heighttext;
    self.casetitle.frame = CGRectMake(casetitlex, casetitley, casetitlew, casetitleh);

    
    
    
    CGFloat heighticon = CGRectGetMaxY(self.iconimageview.frame) + 3*maragin +5;
    
    self.line.frame = CGRectMake(0, heighticon , MYScreenW, 0.5);
    
    self.height = heighticon + maragin ;
    
    
}









@end
