//
//  MYHomeDesignerDeatilView.m
//  魔颜
//
//  Created by abc on 15/9/30.
//  Copyright (c) 2015年 abc. All rights reserved.
//



//#define leftFont  [UIFont systemFontOfSize:14]
//#define DeatilContentFont [UIFont systemFontOfSize:13];
//#define titlecolor  MYColor(50 , 50, 50)

#define designertextcolor
#import "MYHomeDesignerDeatilView.h"
#import "MYHeader.h"
#define BORDER_COLOR  UIColorFromRGB(0xc9c9c9).CGColor
#define BORDER_WIDTH 0.50f
#define deatiltextcolor  MYColor(109, 109, 109)


@interface MYHomeDesignerDeatilView  ()

@property(weak,nonatomic) UILabel *name;
@property(weak,nonatomic) UILabel *zhichenglable;
@property(weak,nonatomic) UILabel *distancelable;
@property(weak,nonatomic) UIImageView *distanceiamge;

@property(weak, nonatomic) UIImageView *topimage;
@property(weak, nonatomic) UILabel *persontitle;
@property(weak, nonatomic) UILabel *personcontent;
@property(weak, nonatomic) UILabel *studytitle;
@property(weak, nonatomic) UILabel *studycontent;
@property(weak, nonatomic) UILabel *worktitle;
@property(weak, nonatomic) UILabel *workcontent;
@property(weak, nonatomic) UIImageView *workimage1;
@property(weak, nonatomic) UIImageView *workimage2;
@property(weak, nonatomic) UILabel *impressiontitle;
@property(weak, nonatomic) UILabel *impressioncontent;


@property(weak, nonatomic) UIImageView *persondoc;
@property(weak, nonatomic) UIImageView *studydoc;
@property(weak, nonatomic) UIImageView *workdoc;
@property(weak, nonatomic) UIImageView *impressiondoc;


@property(weak,nonatomic) UIImageView *radianimageview;




@property(assign,nonatomic) int studycontentlabelHeight;

@property(assign,nonatomic) int personcontentlableHeight;
@property(assign,nonatomic) int workcontentlabelHeight ;
@property(assign,nonatomic) int impressioncontentcontentlabelHeight;



@property(strong,nonatomic) NSString * url0;
@property(strong,nonatomic) NSString * url1;

@property(assign,nonatomic) double  arraypicCount;

@property(strong,nonatomic) UILabel * toplable;


@property(strong,nonatomic) UILabel * lable1;
@property(strong,nonatomic) UILabel * lable2;


@property(assign,nonatomic) CGFloat  latitudestr;
@property(assign,nonatomic) CGFloat   longitude;

@property(strong,nonatomic) NSString * julistr;

@property(strong,nonatomic) CLLocation * current;

@end

@implementation MYHomeDesignerDeatilView


-(void)setDesignerdeatilmodel:(designerdeatilModel *)designerdeatilmodel
{
    _designerdeatilmodel = designerdeatilmodel;
    
    
    //    头部图片
    
    UIImageView *topimage = [[UIImageView alloc]init];
    [self addSubview:topimage];
    //    topimage.image = [UIImage imageNamed:@"dess"];
    self.topimage = topimage;
    
    __block MYHomeDesignerDeatilView *weakSelf = self;
    
    NSString *strtop =  designerdeatilmodel.bigPic;
    NSString *topurl = [NSString stringWithFormat:@"%@%@",kOuternet1,strtop];
    [self.topimage sd_setImageWithURL:[NSURL URLWithString:topurl]];
    
    [self.topimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,designerdeatilmodel.bigPic]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.topimage.image = image;
        [weakSelf setupPictureFrame];
    }];
    

    //   大标签
    UILabel *toplable = [[UILabel alloc]init];
    [self addSubview:toplable];
    toplable.layer.masksToBounds = YES;
    toplable.layer.cornerRadius = 15;
    self.toplable = toplable;
    toplable.backgroundColor = [UIColor whiteColor];
    //        设置边框
    [toplable.layer setBorderColor:BORDER_COLOR];
    [toplable.layer setBorderWidth: BORDER_WIDTH];
    
    
    UILabel *name = [[UILabel alloc]init];
    [toplable addSubview:name];
    name.textColor = titlecolor;
    name.font = leftFont;
    
    
    UILabel *zhichenglable = [[UILabel alloc]init];
    [toplable addSubview:zhichenglable];
    zhichenglable.font = leftFont;
    zhichenglable.textColor = titlecolor;
    
    
    
    //    计算距离
      self.latitudestr =    [[MYUserDefaults objectForKey:@"latitude"]  floatValue]  ;
    self.longitude =    [[MYUserDefaults objectForKey:@"longitude"]  floatValue]  ;
    
    if(self.latitudestr == 0)
    {
        
        
        self.julistr = @"未知";
    
        
        //    距离
        UILabel *distancelable = [[UILabel alloc]init];
        self.distancelable = distancelable;
        [toplable addSubview:distancelable];
        distancelable.textAlignment = NSTextAlignmentRight;
        distancelable.textColor = deatiltextcolor;
        distancelable.font = [UIFont systemFontOfSize:13];
        distancelable.textAlignment = NSTextAlignmentLeft;
        
        
        UIImageView *distanceimage = [[UIImageView alloc]init];
        self.distanceiamge = distanceimage;
        [toplable addSubview:distanceimage];
        distanceimage.image = [UIImage imageNamed:@"location2"];
        
        //    赋值
        NSString *namestr = designerdeatilmodel.name;
        NSString *zhichengstr = designerdeatilmodel.qualification;
        self.julistr =  [NSString stringWithFormat:@"%@",self.julistr];
        
        
        UILabel *lable1 = [[UILabel alloc]init];
        [toplable addSubview:lable1];
        self.lable1 = lable1;
        lable1.text = [NSString stringWithFormat:@"    %@   %@",namestr,zhichengstr];
        lable1.textColor = titlecolor;
        lable1.font = leftFont;
        lable1.textAlignment = NSTextAlignmentLeft;
        
        UILabel *lable2 = [[UILabel alloc]init];
        [toplable addSubview:lable2];
        self.lable2 = lable2;
        lable2.text = [NSString stringWithFormat:@"%@",self.julistr];
        lable2.textColor = titlecolor;
        lable2.font = leftFont;

        
    }else
    {
        //第一个坐标
        self.current=[[CLLocation alloc] initWithLatitude: self.latitudestr longitude:self.longitude];
     
        double str11 = designerdeatilmodel.latitude;
        double str22 = designerdeatilmodel.longitude;
        
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:str11 longitude:str22];
        // 计算距离
        CLLocationDistance meters=[self.current distanceFromLocation:before];
        double distance = meters/1000;
        
        
        
        //    距离
        UILabel *distancelable = [[UILabel alloc]init];
        self.distancelable = distancelable;
        [toplable addSubview:distancelable];
        distancelable.textAlignment = NSTextAlignmentRight;
        distancelable.textColor = deatiltextcolor;
        distancelable.font = [UIFont systemFontOfSize:13];
        distancelable.textAlignment = NSTextAlignmentLeft;
        
        
        UIImageView *distanceimage = [[UIImageView alloc]init];
        self.distanceiamge = distanceimage;
        [toplable addSubview:distanceimage];
        distanceimage.image = [UIImage imageNamed:@"location2"];
        
        
        
        //    赋值
        NSString *namestr = designerdeatilmodel.name;
        NSString *zhichengstr = designerdeatilmodel.qualification;
        self.julistr =  [NSString stringWithFormat:@"%.0fKM",distance];
        
        
        UILabel *lable1 = [[UILabel alloc]init];
        [toplable addSubview:lable1];
        self.lable1 = lable1;
        lable1.text = [NSString stringWithFormat:@"    %@   %@",namestr,zhichengstr];
        lable1.textColor = titlecolor;
        lable1.font = leftFont;
        lable1.textAlignment = NSTextAlignmentLeft;
        
        
        UILabel *lable2 = [[UILabel alloc]init];
        [toplable addSubview:lable2];
        self.lable2 = lable2;
        lable2.text = [NSString stringWithFormat:@"%@",self.julistr];
        lable2.textColor = titlecolor;
        lable2.font = leftFont;
    }
    
    //    个人简历
    self.personcontent.text = designerdeatilmodel.introduction;
    
    //   海外留学
    self.studycontent.text = designerdeatilmodel.overseasExp;
    
    //工作履历
    self.workcontent.text = designerdeatilmodel.buniess;
    
    //设计师印象
    self.impressioncontent.text = designerdeatilmodel.qualification;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //    个人简历
        UIImageView *persondoc = [[UIImageView alloc]init];
        persondoc.image = [UIImage imageNamed:@"main_badge"];
        self.persondoc = persondoc;
        [self addSubview:persondoc];
        
        
        UILabel *persontitle = [[UILabel alloc]init];
        [self addSubview:persontitle];
        self.persontitle = persontitle;
        persontitle.font = leftFont;
        persontitle.text = @"个人简历";
        persontitle.textColor = titlecolor;
        
        
        UILabel *personcontent = [[UILabel alloc]init];
        [self addSubview:personcontent];
        self.personcontent = personcontent;
        personcontent.font = leftFont;
        personcontent.textColor = deatiltextcolor;
        personcontent.numberOfLines = 0;
        
        
        
        //   海外留学
        UIImageView *studydoc = [[UIImageView alloc]init];
        studydoc.image = [UIImage imageNamed:@"main_badge"];
        self.studydoc = studydoc;
        [self addSubview:studydoc];
        
        
        UILabel *studytitle = [[UILabel alloc]init];
        [self addSubview:studytitle];
        self.studytitle = studytitle;
        studytitle.text = @"海外留学";
        studytitle.font = leftFont;
        studytitle.textColor = titlecolor;
        
        
        
        UILabel *studycontent = [[UILabel alloc]init];
        [self addSubview:studycontent];
        self.studycontent = studycontent;
        studycontent.font = leftFont;
        studycontent.textColor = deatiltextcolor;
        studycontent.numberOfLines = 0;
        
        
        
        //        工作履历
        UIImageView *workdoc = [[UIImageView alloc]init];
        workdoc.image = [UIImage imageNamed:@"main_badge"];
        self.workdoc = workdoc;
        [self addSubview:workdoc];
        
        
        UILabel *worktitle = [[UILabel alloc]init];
        [self addSubview:worktitle];
        self.worktitle = worktitle;
        worktitle.text  = @"工作履历";
        worktitle.font = leftFont;
        worktitle.textColor = titlecolor;
        
        
        
        UILabel *workcontent = [[UILabel alloc]init];
        [self addSubview:workcontent];
        self.workcontent = workcontent;
        workcontent.font = leftFont;
        workcontent.textColor = deatiltextcolor;
        workcontent.numberOfLines = 0;
        
        
        
        //        设计师印象
        UIImageView *impressiondoc = [[UIImageView alloc]init];
        impressiondoc.image = [UIImage imageNamed:@"main_badge"];
        self.impressiondoc = impressiondoc;
        [self addSubview:impressiondoc];
        
        
        UILabel *impressiontitle = [[UILabel alloc]init];
        [self addSubview:impressiontitle];
        self.impressiontitle = impressiontitle;
        impressiontitle.text = @"设计师印象";
        impressiontitle.font = leftFont;
        impressiontitle.textColor = titlecolor;
        
        
        UILabel *impressioncontent = [[UILabel alloc]init];
        [self addSubview:impressioncontent];
        self.impressioncontent = impressioncontent;
        impressioncontent.textColor = deatiltextcolor;
        impressioncontent.font = leftFont;
        impressioncontent.numberOfLines = 0;
        
    }
    return self;
}

- (void)setupPictureFrame
{
    CGFloat imaViewH = self.topimage.image.size.height * MYScreenW / self.topimage.image.size.width;
    self.topimage.frame = CGRectMake(0, 0, MYScreenW, imaViewH);
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    self.topimage.frame = CGRectMake(0, 0, MYScreenW , 300);
    
    NSDictionary *dict1 = @{NSFontAttributeName:leftFont};
    CGFloat lableY1 =  235;
    CGFloat lableh1 =  30;
    CGSize  lableSize1 = [self.lable1.text sizeWithAttributes:dict1];
    CGFloat lableX1 = 10 ;
    
    
    
    CGFloat distanceiamgex = lableSize1.width +10+ 20 ;
    CGFloat distanceiamgey = 9;
    CGFloat distanceiamgew = 7;
    CGFloat distanceiamgeh = 10;
    
    
    NSDictionary *dict2 = @{NSFontAttributeName:leftFont};
    CGFloat lableY2 =  0;
    CGFloat lableh2 =  30;
    CGSize  lableSize2 = [self.lable2.text sizeWithAttributes:dict2];
    CGFloat lableX2 =  20+lableSize1.width +distanceiamgew +2 + distanceiamgew+4 ;
    
    
    CGFloat toplableY =  CGRectGetMaxY(self.topimage.frame) - 20;
    CGFloat toplableh =  30;
    CGFloat toplablew = lableSize1.width + distanceiamgew + lableSize2.width + 50+5;
    CGFloat toplableX =  (MYScreenW - toplablew)/2 ;
    self.toplable.frame = CGRectMake(toplableX, toplableY, toplablew, toplableh);
    
    self.lable1.frame = CGRectMake(lableX1,0, lableSize1.width, lableh1);
    self.distanceiamge.frame = CGRectMake(distanceiamgex, distanceiamgey, distanceiamgew, distanceiamgeh);
    self.lable2.frame = CGRectMake(lableX2, lableY2, lableSize2.width, lableh2);
      
    //    个人简历
    self.persondoc.frame = CGRectMake(10, CGRectGetMaxY(self.topimage.frame) - 3  + 20 + margin, 5, 5);
    
    CGFloat persontitlex = 5 + 5 + 10;
    CGFloat persontitley =  CGRectGetMaxY(self.topimage.frame) + margin*2;
    CGFloat persontitlew = MYScreenW ;
    CGFloat persontileh = 20;
    self.persontitle.frame = CGRectMake(persontitlex, persontitley, persontitlew, persontileh);
      
    
    CGFloat personcontentx = 30;
    CGFloat personcontenty =  CGRectGetMaxY(self.persontitle.frame) + margin;
    CGFloat personcontentw = MYScreenW - margin * 5 ;
    NSMutableAttributedString *attributedStringperson = [[NSMutableAttributedString alloc]initWithString:self.personcontent.text];
    NSMutableParagraphStyle *paragraphStyleperson= [[NSMutableParagraphStyle alloc]init];
    [paragraphStyleperson setLineSpacing:6];
    [attributedStringperson addAttribute:NSParagraphStyleAttributeName value:paragraphStyleperson range:NSMakeRange(0, self.personcontent.text.length)];
    self.personcontent.attributedText = attributedStringperson;
    CGSize maxSizeperson = CGSizeMake(personcontentw, 28);
    CGSize desLabelSizeperson = [self.personcontent sizeThatFits:maxSizeperson];
    self.personcontent.frame =  CGRectMake(personcontentx, personcontenty, desLabelSizeperson.width, desLabelSizeperson.height);
    
    
    if (![self.designerdeatilmodel.overseasExp isEqualToString:@""]) {
        //    留学
        self.studydoc.frame = CGRectMake(10, CGRectGetMaxY(self.personcontent.frame)   + margin * 2 -3   , 5, 5);
        
        
        CGFloat studytitlex = 5 + 5 + 10 ;
        CGFloat studytitley = margin  + CGRectGetMaxY(self.personcontent.frame) ;
        CGFloat studytitlew = MYScreenW ;
        CGFloat studytitleh = 20;
        self.studytitle.frame = CGRectMake(studytitlex, studytitley, studytitlew, studytitleh);
        
        
        CGFloat studycontentx = 30 ;
        CGFloat studycontenty =  CGRectGetMaxY(self.studytitle.frame) + margin ;
        CGFloat studycontentw = MYScreenW - margin * 5  ;
        
        NSMutableAttributedString *attributedStringstudy = [[NSMutableAttributedString alloc]initWithString:self.studycontent.text];
        NSMutableParagraphStyle *paragraphStylestudy = [[NSMutableParagraphStyle alloc]init];
        [paragraphStylestudy setLineSpacing:6];
        [attributedStringstudy addAttribute:NSParagraphStyleAttributeName value:paragraphStylestudy range:NSMakeRange(0, self.studycontent.text.length)];
        self.studycontent.attributedText = attributedStringstudy;
        CGSize maxSizestudy = CGSizeMake(studycontentw, 28);
        CGSize desLabelSizestudy = [self.studycontent sizeThatFits:maxSizestudy];
        self.studycontent.frame = CGRectMake(studycontentx, studycontenty, desLabelSizestudy.width ,desLabelSizestudy.height);
        
        
        //    工作履历
        self.workdoc.frame = CGRectMake(10, CGRectGetMaxY(self.studycontent.frame) + margin * 2 -3, 5, 5);
        
        CGFloat worktitlex = 5 + 5 + 10;
        CGFloat worktitley = margin   + CGRectGetMaxY(self.studycontent.frame)  ;
        CGFloat worktitlew = MYScreenW ;
        CGFloat worktitleh = 20;
        self.worktitle.frame = CGRectMake(worktitlex, worktitley, worktitlew, worktitleh);
        
        
    }else
    {
        
        //    工作履历
        self.workdoc.frame = CGRectMake(10, CGRectGetMaxY(self.personcontent.frame) + margin * 2 -3, 5, 5);
        
        CGFloat worktitlex = 5 + 5 + 10;
        CGFloat worktitley = margin   + CGRectGetMaxY(self.personcontent.frame)  ;
        CGFloat worktitlew = MYScreenW ;
        CGFloat worktitleh = 20;
        self.worktitle.frame = CGRectMake(worktitlex, worktitley, worktitlew, worktitleh);
        
    }
    
    
    
    CGFloat workcontentx = 30;
    CGFloat workcontenty =  CGRectGetMaxY(self.worktitle.frame) + margin;
    CGFloat workcontentw = MYScreenW - margin * 5 ;
    NSMutableAttributedString *attributedStringwork = [[NSMutableAttributedString alloc]initWithString:self.workcontent.text];
    NSMutableParagraphStyle *paragraphStylework = [[NSMutableParagraphStyle alloc]init];
    [paragraphStylework setLineSpacing:6];
    [attributedStringwork addAttribute:NSParagraphStyleAttributeName value:paragraphStylework range:NSMakeRange(0, self.workcontent.text.length)];
    self.workcontent.attributedText = attributedStringwork;
    CGSize maxSizework = CGSizeMake(workcontentw, 28);
    CGSize desLabelSizework = [self.workcontent sizeThatFits:maxSizework];
    self.workcontent.frame =  CGRectMake(workcontentx, workcontenty, desLabelSizework.width, desLabelSizework.height);
    
    
    
    
    if (self.arraypicCount > 1) {
        
        if (MYScreenW >= 414)
        {
            
            CGFloat workimage1x = 15;
            CGFloat workimage1y = CGRectGetMaxY(self.workcontent.frame) + margin ;
            CGFloat workimage1w = 170 ;
            CGFloat worhimage1h = 150 ;
            self.workimage1.frame =  CGRectMake(workimage1x, workimage1y,workimage1w,worhimage1h);
            
            CGFloat workimage2x = 15 + workimage1w + 20;
            CGFloat workimage2y = CGRectGetMaxY(self.workcontent.frame) + margin ;
            CGFloat workimage2w = 170 ;
            CGFloat worhimage2h = 150 ;
            self.workimage2.frame = CGRectMake(workimage2x, workimage2y,workimage2w,worhimage2h);
            
            
        }
        else if(MYScreenW >= 375)
        {
            CGFloat workimage1x = 15;
            CGFloat workimage1y = CGRectGetMaxY(self.workcontent.frame) + margin ;
            CGFloat workimage1w = 150 ;
            CGFloat worhimage1h = 120 ;
            self.workimage1.frame =  CGRectMake(workimage1x, workimage1y,workimage1w,worhimage1h);
            
            CGFloat workimage2x = 15 + workimage1w + 20;
            CGFloat workimage2y = CGRectGetMaxY(self.workcontent.frame) + margin ;
            CGFloat workimage2w = 150 ;
            CGFloat worhimage2h = 120 ;
            self.workimage2.frame = CGRectMake(workimage2x, workimage2y,workimage2w,worhimage2h);
        }
        else {
            
            CGFloat workimage1x = 15;
            CGFloat workimage1y = CGRectGetMaxY(self.workcontent.frame) + margin ;
            CGFloat workimage1w = 125 ;
            CGFloat worhimage1h = 100 ;
            self.workimage1.frame =  CGRectMake(workimage1x, workimage1y,workimage1w,worhimage1h);
            
            CGFloat workimage2x = 15 + workimage1w + 20;
            CGFloat workimage2y = CGRectGetMaxY(self.workcontent.frame) + margin ;
            CGFloat workimage2w = 125 ;
            CGFloat worhimage2h = 100 ;
            self.workimage2.frame = CGRectMake(workimage2x, workimage2y,workimage2w,worhimage2h);
            
        }
        
        
        //    设计师印象
        self.impressiondoc.frame = CGRectMake(10, CGRectGetMaxY(self.workimage1.frame)   + margin * 2 -3  , 5, 5);
        
        
        CGFloat impressiontitlex = 5 + 5 + 10 ;
        CGFloat impressiontitley = margin  + CGRectGetMaxY(self.workimage1.frame) ;
        CGFloat impressiontitlew = MYScreenW ;
        CGFloat impressiontitleh = 20;
        self.impressiontitle.frame = CGRectMake(impressiontitlex, impressiontitley, impressiontitlew, impressiontitleh);
        
        
        CGFloat impressioncontentx = 30 ;
        CGFloat impressioncontenty =  CGRectGetMaxY(self.impressiontitle.frame) + margin  ;
        CGFloat impressioncontentw = MYScreenW - margin * 5  ;
        NSMutableAttributedString *attributedStringimpress = [[NSMutableAttributedString alloc]initWithString:self.impressioncontent.text];
        NSMutableParagraphStyle *paragraphStyleimpress = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyleimpress setLineSpacing:6];
        [attributedStringimpress addAttribute:NSParagraphStyleAttributeName value:paragraphStyleimpress range:NSMakeRange(0, self.impressioncontent.text.length)];
        self.impressioncontent.attributedText = attributedStringimpress;
        CGSize maxSizesimpress = CGSizeMake(impressioncontentw, 28);
        CGSize desLabelSizeimpress = [self.impressioncontent sizeThatFits:maxSizesimpress];
        self.impressioncontent.frame =  CGRectMake(impressioncontentx, impressioncontenty, desLabelSizeimpress.width, desLabelSizeimpress.height);
        
        
    }else
    {
        //    设计师印象
        self.impressiondoc.frame = CGRectMake(10, CGRectGetMaxY(self.workcontent.frame)   + margin * 2 + 7  , 5, 5);
        
        
        CGFloat impressiontitlex = 5 + 5 + 10 ;
        CGFloat impressiontitley = margin * 2 + CGRectGetMaxY(self.workcontent.frame) ;
        CGFloat impressiontitlew = MYScreenW ;
        CGFloat impressiontitleh = 20;
        self.impressiontitle.frame = CGRectMake(impressiontitlex, impressiontitley, impressiontitlew, impressiontitleh);
        
        
        CGFloat impressioncontentx = 30 ;
        CGFloat impressioncontenty =  CGRectGetMaxY(self.impressiontitle.frame) + margin  ;
        CGFloat impressioncontentw = MYScreenW - margin * 5  ;
        NSMutableAttributedString *attributedStringimpress = [[NSMutableAttributedString alloc]initWithString:self.impressioncontent.text];
        NSMutableParagraphStyle *paragraphStyleimpress = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyleimpress setLineSpacing:6];
        [attributedStringimpress addAttribute:NSParagraphStyleAttributeName value:paragraphStyleimpress range:NSMakeRange(0, self.impressioncontent.text.length)];
        self.impressioncontent.attributedText = attributedStringimpress;
        CGSize maxSizesimpress = CGSizeMake(impressioncontentw, 28);
        CGSize desLabelSizeimpress = [self.impressioncontent sizeThatFits:maxSizesimpress];
        self.impressioncontent.frame =  CGRectMake(impressioncontentx, impressioncontenty, desLabelSizeimpress.width, desLabelSizeimpress.height);
        
        
    }
    
    self.scrollviewHight = CGRectGetMaxY(self.impressioncontent.frame);
    double hight = self.scrollviewHight + 90;
    
    if ([self.ScrollViewhight respondsToSelector:@selector(designerScrollViewHight:)])
        
    {
        [self.ScrollViewhight designerScrollViewHight:hight];
        
        
    }
    
}

@end
