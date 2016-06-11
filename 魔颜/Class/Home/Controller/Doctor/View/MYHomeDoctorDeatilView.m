//
//  MYHomeDoctorDeatilView.m
//  魔颜

//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYHomeDoctorDeatilView.h"



#define BORDER_COLOR  UIColorFromRGB(0xc9c9c9).CGColor
#define BORDER_WIDTH 0.50f


#define deatiltextcolor  MYColor(109, 109, 109)
#import "DWTagList.h"
#import "MYHeader.h"

#import <CoreLocation/CoreLocation.h>

@interface MYHomeDoctorDeatilView ()
@property(weak, nonatomic) UIImageView *topimageview;
@property(weak,nonatomic) UIImageView *radianimageview;


@property(weak, nonatomic) UILabel *nametitle;
@property(weak, nonatomic) UILabel *namecontent;



@property(weak, nonatomic) UILabel *addresstitle;
@property(weak, nonatomic) UILabel *addresscontent;

@property(weak, nonatomic) UILabel *worktitle;
@property(weak, nonatomic) UILabel *workcontent;

@property(weak, nonatomic) UILabel *overseastitle;
@property(weak, nonatomic) UILabel *overseascontent;

@property(weak, nonatomic) UILabel *awardtitle;
@property(weak, nonatomic) UILabel *awardcontent;

@property(weak, nonatomic) UILabel *goodplacetitle;
@property(weak, nonatomic) UILabel *goodplacecontent;

@property(weak, nonatomic) UILabel *goodprojecttitle;
@property(weak, nonatomic) UILabel *goodprojectcontent;

@property(weak, nonatomic) UILabel *mouthtitle;
@property(weak, nonatomic) UILabel *mouthcontent1;
@property(weak, nonatomic) UILabel *mouthcontent2;

@property (strong, nonatomic) DWTagList *tagList;
@property (strong, nonatomic) UIView *mothcontent;

//距离
@property(weak ,nonatomic) UILabel *distance;
@property(weak,nonatomic) UIImageView *distanceimage;

//高度
@property(assign,nonatomic)int addresscontentHeight;

@property(assign,nonatomic) int overseascontentHeight;
@property(assign,nonatomic) int awardcontentHeight;
@property(assign,nonatomic) int goodplacecontentHeight;
@property(assign,nonatomic) int goodprojectcontentHeight;


@property(strong,nonatomic) UILabel * persontitle;

@property(strong,nonatomic) UILabel * personcontent;


@property(strong,nonatomic) UILabel * toplable;
@property(strong,nonatomic) UILabel * distancelable;

@property(strong,nonatomic) UILabel * renzhengcode;

@property(strong,nonatomic) UILabel * jigoulable;

@property(strong,nonatomic) UILabel * lable1;
@property(strong,nonatomic) UILabel * lable2;


@property(assign,nonatomic) CGFloat  latitudestr;
@property(assign,nonatomic) CGFloat  longitude;

@property(strong,nonatomic) NSString * julistr;

@property(strong,nonatomic) CLLocation * current;
@end


@implementation MYHomeDoctorDeatilView

-(void)setDoctordeatileModel:(doctordeatilListModel *)doctordeatileModel
{
    
    __block MYHomeDoctorDeatilView *weakSelf = self;
    _doctordeatileModel = doctordeatileModel;
    
    [self.topimageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,doctordeatileModel.infoPic]]placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        weakSelf.topimageview.image = image;
        [weakSelf setupPictureFrame];
    } ];
    
    
    //   大标签
    UILabel *toplable = [[UILabel alloc]init];
    [self addSubview:toplable];
    toplable.layer.masksToBounds = YES;
    toplable.layer.cornerRadius = 15;
    toplable.textColor = titlecolor;
    toplable.font = leftFont;
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
    
    if (self.latitudestr == 0)
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
        self.distanceimage = distanceimage;
        [toplable addSubview:distanceimage];
        distanceimage.image = [UIImage imageNamed:@"location2"];
        
        
        //    赋值
        NSString *namestr = doctordeatileModel.name;
        NSString *zhichengstr = doctordeatileModel.qualification;
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


    }else{
    //第一个坐标
    CLLocation *current=[[CLLocation alloc] initWithLatitude: self.latitudestr longitude:self.longitude];
    
    double str11 = doctordeatileModel.hospitallatitude;
    double str22 = doctordeatileModel.hospitalLongitude;

    //第二个坐标
    CLLocation *before=[[CLLocation alloc] initWithLatitude:str11 longitude:str22];
    
    // 计算距离
    CLLocationDistance meters=[current distanceFromLocation:before];
    double distance = meters/1000;
    
    //    距离
    UILabel *distancelable = [[UILabel alloc]init];
    self.distancelable = distancelable;
    [toplable addSubview:distancelable];
    //    distancelable.text = [NSString stringWithFormat:@"%.0fKM",distance];
    distancelable.textAlignment = NSTextAlignmentRight;
    distancelable.textColor = deatiltextcolor;
    distancelable.font = [UIFont systemFontOfSize:13];
    distancelable.textAlignment = NSTextAlignmentLeft;
    
    
    UIImageView *distanceimage = [[UIImageView alloc]init];
    self.distanceimage = distanceimage;
    [toplable addSubview:distanceimage];
    distanceimage.image = [UIImage imageNamed:@"location2"];
    
    
    //    赋值
    NSString *namestr = doctordeatileModel.name;
    NSString *zhichengstr = doctordeatileModel.qualification;
    NSString *julistr =  [NSString stringWithFormat:@"%.0fKM",distance];
    
    
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
    lable2.text = [NSString stringWithFormat:@"%@",julistr];
    lable2.textColor = titlecolor;
    lable2.font = leftFont;
    }
    
    //    名字
    self.namecontent.text = doctordeatileModel.name;
    
    //    认证
    NSString * str  = [NSString stringWithFormat:@"认证编码:   %@",doctordeatileModel.docCode];
    
    NSMutableAttributedString *strcode = [[NSMutableAttributedString alloc]initWithString:str];
    //设置：在0-3个单位长度内的内容显示成红色
    [strcode addAttribute:NSForegroundColorAttributeName value:titlecolor range:NSMakeRange(0, 4)];
    self.renzhengcode.attributedText = strcode;
    
    
    //  机构
    NSString *jigoustr = [NSString stringWithFormat:@"机       构:   %@",doctordeatileModel.hospitalName];
    
    NSMutableAttributedString *strcodejigou = [[NSMutableAttributedString alloc]initWithString:jigoustr];
    //设置：在0-3个单位长度内的内容显示成红色
    [strcodejigou addAttribute:NSForegroundColorAttributeName value:titlecolor range:NSMakeRange(0, 10)];
    [strcodejigou addAttribute:NSForegroundColorAttributeName value:titlecolor range:NSMakeRange(0, 4)];
    self.jigoulable.attributedText = strcodejigou;
    
    
    
    //    地址
    NSString *straddress = doctordeatileModel.address;
    
    NSMutableAttributedString *addressstr = [[NSMutableAttributedString alloc]initWithString:straddress];
    //设置：在0-3个单位长度内的内容显示成红色
    [addressstr addAttribute:NSForegroundColorAttributeName value:titlecolor range:NSMakeRange(0, 4)];
    [addressstr addAttribute:NSFontAttributeName value:leftFont range:NSMakeRange(0, 4)];
    self.addresscontent.attributedText = addressstr;
    
    
    //      工作经验
    NSString *strwork = [NSString stringWithFormat:@"工作经验:   %@年",doctordeatileModel.workexp] ;
    NSMutableAttributedString *workstr = [[NSMutableAttributedString alloc]initWithString:strwork];
    //设置：在0-3个单位长度内的内容显示成红色
    [workstr addAttribute:NSForegroundColorAttributeName value:titlecolor range:NSMakeRange(0, 4)];
    self.workcontent.attributedText = workstr;
    
    
    //   海外经历
    self.overseascontent.text = doctordeatileModel.overseasExp;
    
    //    所获奖项
    self.awardcontent.text = doctordeatileModel.honor;
    
    
    
    //   个人简介
    self.personcontent.text = doctordeatileModel.introduction;
    
    
    
    //擅长项目
    
    self.goodprojectcontent.text = doctordeatileModel.goodProject;
    
    if ([doctordeatileModel.reputation isEqualToString:@""]) {
        
    }else
    {
        NSString * astring = doctordeatileModel.reputation;
        NSArray *array = [astring componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
        UIView *mothcontent = [[UIView alloc]init];
        self.mothcontent = mothcontent;
        [self addSubview:mothcontent];
        //    标签
        DWTagList *tagList = [[DWTagList alloc]init];
        self.tagList = tagList;
        [tagList setTags:array];
        [_mothcontent addSubview:tagList];
        
    }
    
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //图片
        UIImageView *topimageview = [[UIImageView alloc]init];
        self.topimageview = topimageview;
        [self addSubview:topimageview];
        
        
        //名字
        UILabel *namecontent = [[UILabel alloc]init];
        self.namecontent = namecontent;
        [self addSubview:namecontent];
        namecontent.font = leftFont;
        namecontent.textColor = subTitleColor;
        namecontent.textAlignment = NSTextAlignmentLeft;
        
        
        // 认证编码
        UILabel *renzhengcode = [[UILabel alloc]init];
        self.renzhengcode = renzhengcode;
        [self addSubview:renzhengcode];
        renzhengcode.text = @"认证编码:";
        renzhengcode.font = leftFont;
        renzhengcode.textColor = subTitleColor;
        
        
        //        机构
        UILabel *jigoulable = [[UILabel alloc]init];
        self.jigoulable = jigoulable;
        [self addSubview:jigoulable];
        jigoulable.font = leftFont;
        jigoulable.textColor = subTitleColor;
        
        
        
        //        地址
        UILabel *addresstitle = [[UILabel alloc]init];
        self.addresstitle = addresstitle;
        [self addSubview:addresstitle];
        addresstitle.font = leftFont;
        addresstitle.text = @"地       址:";
        addresstitle.textColor = titlecolor;
        
        
        UILabel *addresscontent = [[UILabel alloc]init];
        self.addresscontent = addresscontent;
        [self addSubview:addresscontent];
        addresscontent.numberOfLines = 0;
        addresscontent.font = leftFont;
        addresscontent.textColor = subTitleColor;
        
        
        //        工作经验
        UILabel *workcontent = [[UILabel alloc]init];
        self.workcontent = workcontent;
        [self addSubview:workcontent];
        workcontent.font = leftFont;
        workcontent.textColor = subTitleColor;
        
        
        
        //        海外经历
        UILabel *overseastitle = [[UILabel alloc]init];
        self.overseastitle = overseastitle;
        [self addSubview:overseastitle];
        //        overseastitle.numberOfLines = 0 ;
        overseastitle.text = @"海外经历:";
        overseastitle.font = leftFont;
        overseastitle.textColor = titlecolor;
        
        UILabel *overseascontent = [[UILabel alloc]init];
        self.overseascontent = overseascontent;
        [self addSubview:overseascontent];
        overseascontent.numberOfLines = 0 ;
        overseascontent.font = leftFont;
        overseascontent.textColor = subTitleColor;
        overseascontent.textAlignment = NSTextAlignmentLeft;
        
        
        //        所获奖项
        UILabel *awardtitle = [[UILabel alloc]init];
        self.awardtitle = awardtitle;
        [self addSubview:awardtitle];
        awardtitle.font = leftFont;
        awardtitle.text = @"所获奖项:";
        awardtitle.textColor = titlecolor;
        
        
        UILabel *awardcontent = [[UILabel alloc]init];
        self.awardcontent = awardcontent;
        awardcontent.numberOfLines = 0;
        [self addSubview:awardcontent];
        awardcontent.font = leftFont;
        awardcontent.textColor = subTitleColor;
        
        
        //       个人简介
        UILabel *goodplacetitle = [[UILabel alloc]init];
        self.goodplacetitle = goodplacetitle;
        goodplacetitle.font = leftFont;
        goodplacetitle.text = @"个人简介:";
        [self addSubview:goodplacetitle];
        goodplacetitle.textColor = titlecolor;
        
        
        UILabel *personcontent = [[UILabel alloc]init];
        self.personcontent = personcontent;
        personcontent.font = leftFont;
        [self addSubview:personcontent];
        personcontent.numberOfLines = 0;
        personcontent.textColor = subTitleColor;
        personcontent.adjustsFontSizeToFitWidth = YES;
        
        
        
        
        //        擅长项目
        UILabel *goodprojecttitle = [[UILabel alloc]init];
        self.goodprojecttitle = goodprojecttitle;
        [self addSubview:goodprojecttitle];
        goodprojecttitle.font = leftFont;
        goodprojecttitle.text = @"擅长项目:";
        goodprojecttitle.textColor = titlecolor;
        
        
        UILabel *goodprojectcontent = [[UILabel alloc]init];
        self.goodprojectcontent = goodprojectcontent;
        [self addSubview:goodprojectcontent];
        goodprojectcontent.numberOfLines = 0;
        goodprojectcontent.font = leftFont;
        goodprojectcontent.textColor = subTitleColor;
        
        
        //        口碑
        UILabel *mouthtitle = [[UILabel alloc]init];
        mouthtitle.font = leftFont;
        [self addSubview:mouthtitle];
        mouthtitle.text = @"口碑标签:";
        self.mouthtitle = mouthtitle;
        mouthtitle.textColor = titlecolor;
        
    }
    return self;
}

/*
 @brief 图片位置
 */
- (void)setupPictureFrame
{
    CGFloat imaViewH = self.topimageview.image.size.height * MYScreenW / self.topimageview.image.size.width;
    self.topimageview.frame = CGRectMake(0, 0, MYScreenW, imaViewH);
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat titlehight = 15;
    //
    //    CGFloat topimagex = 0;
    //    CGFloat topimagey = 0;
    //    CGFloat topimagew = MYScreenW;
    //    CGFloat topimageh = 280;
    //    self.topimageview.frame = CGRectMake(topimagex, topimagey, topimagew, topimageh);
    self.topimageview.height = 290;
    
    NSDictionary *dict1 = @{NSFontAttributeName:leftFont};
    CGFloat lableY1 =  0;
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
    CGFloat lableX2 =  20+lableSize1.width +distanceiamgew +2 + distanceiamgew +4;
    
    
    CGFloat toplableY =  CGRectGetMaxY(self.topimageview.frame)-20;
    CGFloat toplableh =  30;
    CGFloat toplablew = lableSize1.width + distanceiamgew + lableSize2.width + 50+10;
    CGFloat toplableX =  (MYScreenW - toplablew)/2 ;
    self.toplable.frame = CGRectMake(toplableX, toplableY, toplablew, toplableh);
    
    self.lable1.frame = CGRectMake(lableX1,0, lableSize1.width, lableh1);
    self.distanceimage.frame = CGRectMake(distanceiamgex, distanceiamgey, distanceiamgew, distanceiamgeh);
    self.lable2.frame = CGRectMake(lableX2, lableY2, lableSize2.width, lableh2);
    
    
    //  认证
    CGFloat renzhengcodex = margin;
    CGFloat renzhengcodey = margin*2 + CGRectGetMaxY(self.topimageview.frame);
    CGFloat renzhengcodew = MYScreenW - margin *2;
    CGFloat renzhengcodeh = titlehight;
    self.renzhengcode.frame = CGRectMake(renzhengcodex, renzhengcodey, renzhengcodew, renzhengcodeh);
    
    
    //      机构
    CGFloat jigoulablex = margin;
    CGFloat jigoulabley = margin + CGRectGetMaxY(self.renzhengcode.frame);
    CGFloat jigoulablew = MYScreenW - margin *2;
    CGFloat jigoulableh = titlehight;
    self.jigoulable.frame = CGRectMake(jigoulablex, jigoulabley, jigoulablew, jigoulableh);
    

    
    //    地址
    CGFloat addresstitlex = margin;
    CGFloat addresstitley = margin + CGRectGetMaxY(self.jigoulable.frame);
    CGFloat addresstitlew = 60;
    CGFloat addresstitleh = titlehight;
    self.addresstitle.frame = CGRectMake(addresstitlex, addresstitley, addresstitlew, addresstitleh);
    
    CGFloat addresscontentx =  margin / 2 + addresstitlew ;
    CGFloat addresscontenty = addresstitley -2;
    CGFloat addresscontentw = MYScreenW - addresstitlew - margin * 2 ;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.addresscontent.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.addresscontent.text.length)];
    self.addresscontent.attributedText = attributedString;
    CGSize maxSize = CGSizeMake(addresscontentw, MAXFLOAT);
    CGSize desLabelSize = [self.addresscontent sizeThatFits:maxSize];
    self.addresscontent.frame = CGRectMake(addresscontentx ,addresscontenty, desLabelSize.width, desLabelSize.height);
    
    
    //    工作经历
    CGFloat workcontentx =  margin;
    CGFloat workcontenty =  CGRectGetMaxY(self.addresscontent.frame)+ margin  ;
    CGFloat workcontentw = MYScreenW - margin * 2;
    CGFloat workcontenth = titlehight;
    self.workcontent.frame = CGRectMake(workcontentx, workcontenty, workcontentw, workcontenth);
    
    
    if(![self.doctordeatileModel.overseasExp isEqualToString:@""])
    {
        
        //    海外经历
        
        CGFloat overseastitlex = margin ;
        CGFloat overseastitley = margin + CGRectGetMaxY(self.workcontent.frame);
        CGFloat overseastitlew = 60;
        CGFloat overseastitleh = titlehight;
        self.overseastitle.frame = CGRectMake(overseastitlex, overseastitley, overseastitlew, overseastitleh);
        
        
        CGFloat overseascontentx =   overseastitlew + 5;
        CGFloat overseascontenty =  overseastitley  ;
        CGFloat overseascontentw = MYScreenW - margin * 1 - overseastitlew;
        CGFloat overseascontenth = titlehight;
        self.overseascontent.frame =CGRectMake(overseascontentx, overseascontenty, overseascontentw, overseascontenth);
        
        if (![self.doctordeatileModel.honor isEqualToString:@""]) {

            //    所获奖项
            CGFloat awardtitlex = margin ;
            CGFloat awardtitley = margin + CGRectGetMaxY(self.overseascontent.frame);
            CGFloat awardtitlew = 60;
            CGFloat awardtitleh = titlehight;
            self.awardtitle.frame = CGRectMake(awardtitlex, awardtitley, awardtitlew, awardtitleh);
            
            CGFloat awardcontentx =   awardtitlew +5;
            CGFloat awardcontenty =  awardtitley   ;
            CGFloat awardcontentw = MYScreenW - margin * 1 - awardtitlew;
//            CGFloat awardcontenth = titlehight;
            NSMutableAttributedString *attributedStringaward = [[NSMutableAttributedString alloc]initWithString:self.awardcontent.text];
            NSMutableParagraphStyle *paragraphStyleaward = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyleaward setLineSpacing:6];
            [attributedStringaward addAttribute:NSParagraphStyleAttributeName value:paragraphStyleaward range:NSMakeRange(0, self.awardcontent.text.length)];
            self.awardcontent.attributedText = attributedStringaward;
            CGSize maxSizeaward = CGSizeMake(awardcontentw, MAXFLOAT);
            CGSize desLabelSizeaward = [self.awardcontent sizeThatFits:maxSizeaward];
            self.awardcontent.frame = CGRectMake(awardcontentx, awardcontenty, awardcontentw, desLabelSizeaward.height);
            
            
            //    个人简介
            CGFloat goodplacetitlex = margin ;
            CGFloat goodplacetitley = margin + CGRectGetMaxY(self.awardcontent.frame);
            CGFloat goodplacetitlew = 60;
            CGFloat goodplacetitleh = titlehight;
            self.goodplacetitle.frame = CGRectMake(goodplacetitlex, goodplacetitley, goodplacetitlew, goodplacetitleh);
        }else{
        
        //    个人简介
        CGFloat goodplacetitlex = margin ;
        CGFloat goodplacetitley = margin + CGRectGetMaxY(self.overseascontent.frame);
        CGFloat goodplacetitlew = 60;
        CGFloat goodplacetitleh = titlehight;
        self.goodplacetitle.frame = CGRectMake(goodplacetitlex, goodplacetitley, goodplacetitlew, goodplacetitleh);
        }
        
    }else{
        
        if (![self.doctordeatileModel.honor isEqualToString:@""]) {
            
            //    所获奖项
            CGFloat awardtitlex = margin ;
            CGFloat awardtitley = margin + CGRectGetMaxY(self.workcontent.frame);
            CGFloat awardtitlew = 60;
            CGFloat awardtitleh = titlehight;
            self.awardtitle.frame = CGRectMake(awardtitlex, awardtitley, awardtitlew, awardtitleh);
            
            CGFloat awardcontentx =   awardtitlew +5;
            CGFloat awardcontenty =  awardtitley   ;
            CGFloat awardcontentw = MYScreenW - margin * 1 - awardtitlew;
            //            CGFloat awardcontenth = titlehight;
            NSMutableAttributedString *attributedStringaward = [[NSMutableAttributedString alloc]initWithString:self.awardcontent.text];
            NSMutableParagraphStyle *paragraphStyleaward = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyleaward setLineSpacing:6];
            [attributedStringaward addAttribute:NSParagraphStyleAttributeName value:paragraphStyleaward range:NSMakeRange(0, self.awardcontent.text.length)];
            self.awardcontent.attributedText = attributedStringaward;
            CGSize maxSizeaward = CGSizeMake(awardcontentw, MAXFLOAT);
            CGSize desLabelSizeaward = [self.awardcontent sizeThatFits:maxSizeaward];
            self.awardcontent.frame = CGRectMake(awardcontentx, awardcontenty, awardcontentw, desLabelSizeaward.height);
            
            
            //    个人简介
            CGFloat goodplacetitlex = margin ;
            CGFloat goodplacetitley = margin + CGRectGetMaxY(self.awardcontent.frame);
            CGFloat goodplacetitlew = 60;
            CGFloat goodplacetitleh = titlehight;
            self.goodplacetitle.frame = CGRectMake(goodplacetitlex, goodplacetitley, goodplacetitlew, goodplacetitleh);
        }else{
            
            //    个人简介
            CGFloat goodplacetitlex = margin ;
            CGFloat goodplacetitley = margin + CGRectGetMaxY(self.workcontent.frame);
            CGFloat goodplacetitlew = 60;
            CGFloat goodplacetitleh = titlehight;
            self.goodplacetitle.frame = CGRectMake(goodplacetitlex, goodplacetitley, goodplacetitlew, goodplacetitleh);
        }
        
//        //    个人简介
//        CGFloat goodplacetitlex = margin ;
//        CGFloat goodplacetitley = margin + CGRectGetMaxY(self.workcontent.frame);
//        CGFloat goodplacetitlew = 60;
//        CGFloat goodplacetitleh = titlehight;
//        self.goodplacetitle.frame = CGRectMake(goodplacetitlex, goodplacetitley, goodplacetitlew, goodplacetitleh);
    }
    
    
    CGFloat goodplacecontentx =  margin;
    CGFloat goodplacecontenty =  CGRectGetMaxY(self.goodplacetitle.frame) + self.goodplacetitle.height ;
    CGFloat goodplacecontentw = MYScreenW - margin * 2;
    NSMutableAttributedString *attributedStringperson = [[NSMutableAttributedString alloc]initWithString:self.personcontent.text];
    NSMutableParagraphStyle *paragraphStyleperson = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyleperson setLineSpacing:6];
    [attributedStringperson addAttribute:NSParagraphStyleAttributeName value:paragraphStyleperson range:NSMakeRange(0, self.personcontent.text.length)];
    self.personcontent.attributedText = attributedStringperson;
    CGSize maxSizeperson = CGSizeMake(goodplacecontentw, MAXFLOAT);
    CGSize desLabelSizeperson = [self.personcontent sizeThatFits:maxSizeperson];
    self.personcontent.frame = CGRectMake(goodplacecontentx, goodplacecontenty, desLabelSizeperson.width, desLabelSizeperson.height);
    
    
    //    擅长项目
    CGFloat goodprojecttitlex = margin ;
    CGFloat goodprojecttitley = margin + CGRectGetMaxY(self.personcontent.frame);
    CGFloat goodprojecttitlew = 70;
    CGFloat goodprojecttitleh = titlehight;
    self.goodprojecttitle.frame = CGRectMake(goodprojecttitlex, goodprojecttitley, goodprojecttitlew, goodprojecttitleh);
    
    
    CGFloat goodprojectcontentx =  margin;
    CGFloat goodprojectcontenty =  CGRectGetMaxY(self.goodprojecttitle.frame)+margin/2;
    CGFloat goodprojectcontentw = MYScreenW - margin * 2;
    
    NSMutableAttributedString *attributedStringgoodproject = [[NSMutableAttributedString alloc]initWithString:self.goodprojectcontent.text];
    NSMutableParagraphStyle *paragraphStylegoodproject = [[NSMutableParagraphStyle alloc]init];
    [paragraphStylegoodproject setLineSpacing:6];
    [attributedStringgoodproject addAttribute:NSParagraphStyleAttributeName value:paragraphStylegoodproject range:NSMakeRange(0, self.goodprojectcontent.text.length)];
    self.goodprojectcontent.attributedText = attributedStringgoodproject;
    CGSize maxSizegoodproject = CGSizeMake(goodprojectcontentw, MAXFLOAT);
    CGSize desLabelSizegoodproject = [self.goodprojectcontent sizeThatFits:maxSizegoodproject];
    self.goodprojectcontent.frame = CGRectMake(goodprojectcontentx  , goodprojectcontenty, desLabelSizegoodproject.width, desLabelSizegoodproject.height);
    
    
    
    //    口碑标签
    CGFloat mouthtitlex = margin ;
    CGFloat mouthtitley = margin + CGRectGetMaxY(self.goodprojectcontent.frame);
    CGFloat mouthtitlew = 70;
    CGFloat mouthtitleh = titlehight;
    self.mouthtitle.frame = CGRectMake(mouthtitlex, mouthtitley, mouthtitlew, mouthtitleh);
    
    
    
    CGFloat mothcontentx = margin ;
    CGFloat mothcontenty = CGRectGetMaxY(self.mouthtitle.frame) +5;
    CGFloat mothcontentw = MYScreenW - margin *2;
    CGFloat mothcontenth = margin *3;
    
    self.mothcontent.frame = CGRectMake(mothcontentx, mothcontenty, mothcontentw, mothcontenth);
    
    
    self.tagList.frame = CGRectMake(0, 0, 20, mothcontenth);
    
    
    if ([self.doctordeatileModel.reputation isEqualToString:@""]) {
        
        self.doctordeatilscrollviewHight = CGRectGetMaxY(self.mouthtitle.frame) +10;
    }else
    {
        self.doctordeatilscrollviewHight = CGRectGetMaxY(self.mothcontent.frame) + 10;
    }
    
    double hight = self.doctordeatilscrollviewHight + 60;
    
    
    if ([self.doctordeatilheigt respondsToSelector:@selector(toVcdoctordeatilHeight:)])
    {
        [self.doctordeatilheigt toVcdoctordeatilHeight:hight];
    }
}

//    代理方法( 点击机构进入店铺 )
-(void)clickorganizationBtn
{
    
    if([self.organizationdelegate respondsToSelector:@selector(organizationPushToVC)] )
    {
        
        [self.organizationdelegate organizationPushToVC];
    }
    
}


@end

