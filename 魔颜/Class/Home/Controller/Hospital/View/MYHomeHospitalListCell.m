//
//  MYHomeHospitalListCell.m
//  魔颜
//
//  Created by abc on 15/11/17.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYHomeHospitalListCell.h"
#import "MYHeader.h"

#define titlefont [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];



@interface MYHomeHospitalListCell ()

@property(weak,nonatomic) UIImageView *iconimageview;

@property(strong,nonatomic)  UILabel * name;

@property(strong,nonatomic) UIImageView * renzheng;

@property(strong,nonatomic) UILabel * zhizilable;

@property(strong,nonatomic) UILabel *  addretitle;

@property(strong,nonatomic) UILabel * addresscontent;

@property(strong,nonatomic) UILabel * tesetitle;

@property(strong,nonatomic) UILabel * tesecontent;


@property(strong,nonatomic) UILabel * anlilable;

@property(strong,nonatomic) UIImageView * tagimgeview;//活动标签

@property(strong,nonatomic) UILabel * huodong;//活动


@property(strong,nonatomic) UIView * line;
@property(strong,nonatomic) UILabel * desclable;



@property(assign,nonatomic) int  height;


@property(strong,nonatomic) UIImageView * salonrenzheng;

@property(strong,nonatomic) NSArray * iconarr;

@property(assign,nonatomic) CGFloat  lat;
@property(assign,nonatomic) CGFloat  lon;

@property(strong,nonatomic) NSString * disct;

@end

@implementation MYHomeHospitalListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = [NSString stringWithFormat:@"Hospital%ld",(long)[indexPath row]];
    MYHomeHospitalListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MYHomeHospitalListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        iconimageview.layer.masksToBounds = YES;
        iconimageview.layer.cornerRadius = 50;
        
        
        //      name
        UILabel *name = [[UILabel alloc]init];
        self.name = name;
        [self addSubview:name];
        name.textColor = UIColorFromRGB(0x1a1a1a);
        name.font = MYFont(14);
        name.textAlignment = NSTextAlignmentLeft;
        
        
        //        美容院认证
//        UIView *salonrenzhengView = [[UIView alloc]init];
//        [self addSubview:salonrenzhengView];
//        self.salonrenzhengView = salonrenzhengView;

        //       认证
        UIImageView *renzheng = [[UIImageView alloc]init];
        renzheng.contentMode = UIViewContentModeScaleAspectFill;
        self.renzheng = renzheng;
        [self addSubview:renzheng];
        
      
        
        //        地址
        UILabel *addretitle= [[UILabel alloc]init];
        self.addretitle = addretitle;
        [self addSubview:addretitle];
        addretitle.text = @"地址:";
        addretitle.textColor = subTitleColor;
        addretitle.font = MYFont(12);
        
        
        UILabel *addresscontent= [[UILabel alloc]init];
        self.addresscontent = addresscontent;
        [self addSubview:addresscontent];
        addresscontent.numberOfLines = 2;
        addresscontent.textColor = subTitleColor;
        addresscontent.font = MYFont(12);
        
  

        
        //       特色
        UILabel *tesetitle= [[UILabel alloc]init];
        self.tesetitle = tesetitle;
        [self addSubview:tesetitle];
        tesetitle.text = @"特色:";
        tesetitle.textColor =  subTitleColor;
        tesetitle.font = MYFont(12);
        
        
    
        UILabel *tesecontent= [[UILabel alloc]init];
        self.tesecontent = tesecontent;
        [self addSubview:tesecontent];
//        tesecontent.numberOfLines = 1;
        tesecontent.textColor = subTitleColor;
        tesecontent.font = MYFont(12);
        
        
        //        距离
        UILabel *desclable = [[UILabel alloc]init];
        desclable.font = titlefont;
        desclable.textColor = subTitleColor;
        self.desclable  = desclable;
        [self addSubview:desclable];
        
//      活动标签
        UIImageView * tagimgeview= [[UIImageView alloc]init];
        self.tagimgeview = tagimgeview;
        [self addSubview:tagimgeview];


        UILabel * huodong= [[UILabel alloc]init];
        self.huodong = huodong;
        [self addSubview:huodong];
        huodong.textColor = subTitleColor;
        huodong.numberOfLines =1;
        huodong.textAlignment = NSTextAlignmentLeft;
        huodong.font = MYFont(12);

    
        
        UIView *line = [[UIView alloc]init];
        self.line = line;
        [self addSubview:line];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.4;
    }
    return self;
}

-(void)setHospitalmodel:(hospitaleListModel *)hospitalmodel
{

    [self setupListHospitalmodel:hospitalmodel];
    [self setupFrame];
    
}


-(void)setupListHospitalmodel:(hospitaleListModel *)hospitalList
{
    
    _hospitalmodel = hospitalList;
    NSArray *array = [hospitalList.approve componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组

    _iconarr = array;
    
    [self.iconimageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,hospitalList.listPic]]];
    self.name.text = hospitalList.name;
    if([hospitalList.areaName isEqualToString:@""] || hospitalList.areaName==nil)
    {
        self.addresscontent.text = hospitalList.address;

    }else
    {
        self.addresscontent.text = [NSString stringWithFormat:@"%@%@%@",hospitalList.cityName,hospitalList.areaName,hospitalList.tradingName];

    }

    self.tesecontent.text = [NSString stringWithFormat:@"%@",hospitalList.feature];
    self.anlilable.text = [NSString stringWithFormat:@"案例:    %@",hospitalList.casenum];
    
//    判断使用哪个认证图片
    if (self.controlerStyle == UIControlerStyleSalon) {
        self.renzheng.image = [UIImage imageNamed:@"salonmoyanrenzheng"];
        if ([hospitalList.type isEqualToString:@"0"]) {
            
            self.renzheng.hidden = NO;
            
        }else
        {
            self.renzheng.hidden = YES;
        }
        
    }else{
        
        self.renzheng.image = [UIImage resizableImage:@"moyanrenzheng"];
        
    }
    
    if (self.controlerStyle == UIControlerStyleSalon) {
        _tagimgeview.image = [UIImage imageNamed:@"03_3.jpg"];
        NSString *huodongstr = [hospitalList.tag stringByReplacingOccurrencesOfString:@"," withString:@" "];
        self.huodong.text = [NSString stringWithFormat:@"  %@",huodongstr];
        if ([hospitalList.type isEqualToString:@"0"]) {
            
            self.huodong.hidden = NO;

            if ([hospitalList.tag isEqualToString:@""]) {
                self.tagimgeview.hidden = YES;
            }else{
                self.tagimgeview.hidden = NO;
            }
                
            

        }else
        {
            self.tagimgeview.hidden = YES;
            self.huodong.hidden = YES;
        }
        
    }else{
        //没有活动就隐藏图片
        if([hospitalList.tag isEqualToString:@""] || hospitalList.tag == Nil)
        {
            self.tagimgeview.hidden = YES;
            self.huodong.hidden = YES;
            
        }else{
            _tagimgeview.image = [UIImage imageNamed:@"tag"];
            
            NSString *huodongstr = [hospitalList.tag stringByReplacingOccurrencesOfString:@"," withString:@" "];
            self.huodong.text = [NSString stringWithFormat:@"%@",huodongstr];

        }
        
    }
    
    //    计算距离
    self.lat =  [[MYUserDefaults objectForKey:@"latitude"]  floatValue]  ;
    self.lon =  [[MYUserDefaults objectForKey:@"longitude"]  floatValue]  ;
    
    if(self.lat == 0 || hospitalList.latitude == 0)
    {
        self.disct = @"未知";
    }
    else{
        
        //第一个坐标
        CLLocation *current=[[CLLocation alloc] initWithLatitude: self.lat longitude:self.lon];
        
        double str11 = hospitalList.latitude;
        double str22 = hospitalList.longitude;
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:str11 longitude:str22];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before];
        double distance = meters/1000;
        int disc = (int )distance;
        self.disct = [NSString stringWithFormat:@"%d",disc];
    }
       if (self.controlerStyle != UIControlerStyleSalon) {
           self.desclable.hidden = YES;
    }
    if ([self.disct isEqualToString:@"未知"]) {
        
        self.desclable.text = [NSString  stringWithFormat:@"距离： %@",self.disct];
    }else{
        self.desclable.text = [NSString  stringWithFormat:@"距离： %@KM",self.disct];
    }

    
}

-(void)setupFrame
{
    CGFloat  heighttext = 20;
    CGFloat  titlewith  = 55;

    CGFloat maragin = 6/2;
    CGFloat kmaragin = 10;
    
    CGFloat iconimagevieww = 100;
    CGFloat iconimageviewh = 100;

    
    self.iconimageview.frame = CGRectMake(kmaragin, 13, iconimagevieww, iconimageviewh);
    
    //  name
    CGFloat namex = CGRectGetMaxX(self.iconimageview.frame)+ kmaragin ;
    CGFloat namey = kMargin;
    CGFloat namew = 140;
    CGFloat nameh = heighttext;
    self.name.frame = CGRectMake(namex, namey, namew, nameh);
    
    //  认证
    CGFloat tagimagex = MYScreenW - 30 - 15;
    CGFloat tagimagey = 5;
    CGFloat tagimagew = 20;
    CGFloat tagimageh = 24;
    self.renzheng.frame = CGRectMake(tagimagex, tagimagey, tagimagew, tagimageh);

//    地址title
    CGFloat addretitlex = namex;
    CGFloat addretitley = CGRectGetMaxY(self.name.frame)+maragin;
    CGFloat addretitlew = 40 ;
    CGFloat addretitleh = heighttext;
    self.addretitle.frame = CGRectMake(addretitlex, addretitley, addretitlew, addretitleh);

    
    CGFloat addresscontentx = CGRectGetMaxX(self.addretitle.frame)-4;
    CGFloat addresscontenty =  addretitley+2  ;

    CGFloat addresscontentw;
    NSMutableAttributedString *attributedStringaddress = [[NSMutableAttributedString alloc]initWithString:self.addresscontent.text];
    NSMutableParagraphStyle *paragraphStyleaddress= [[NSMutableParagraphStyle alloc]init];
    [paragraphStyleaddress setLineSpacing:6];
    [attributedStringaddress addAttribute:NSParagraphStyleAttributeName value:paragraphStyleaddress range:NSMakeRange(0, self.addresscontent.text.length)];
    self.addresscontent.attributedText = attributedStringaddress;
    addresscontentw = MYScreenW - iconimagevieww - addretitlew - maragin *6 ;
    CGSize maxSizeaddress = CGSizeMake(addresscontentw, 28);
    CGSize desLabelSizeaddress = [self.addresscontent sizeThatFits:maxSizeaddress];
    self.addresscontent.frame = CGRectMake(addresscontentx, addresscontenty, desLabelSizeaddress.width, desLabelSizeaddress.height);
    
    

    //     特色
    CGFloat tesetitlex = namex ;
    CGFloat tesetitley = CGRectGetMaxY(self.addresscontent.frame) + maragin;
    CGFloat tesetitlew = titlewith;
    CGFloat tesetitleh = heighttext;
    self.tesetitle.frame = CGRectMake(tesetitlex, tesetitley, tesetitlew, tesetitleh);
    
    CGFloat tesecontentx = CGRectGetMaxX(self.tesetitle.frame)-18;
    CGFloat tesecontenty =  tesetitley;
    CGFloat tesecontentw = MYScreenW - iconimagevieww - kmaragin *4 +10;
    CGFloat tesecontenth = heighttext;
    self.tesecontent.frame =  CGRectMake(tesecontentx , tesecontenty, tesecontentw, tesecontenth);
    
    
    CGFloat desclablex = namex;
    CGFloat desclabley =  CGRectGetMaxY(self.tesecontent.frame);
    CGFloat desclablew = MYScreenW - iconimagevieww - kmaragin *4 ;
    CGFloat desclableh = heighttext;
    self.desclable.frame =  CGRectMake(desclablex , desclabley, desclablew, desclableh);
    
    
    CGFloat huodongy ;
    if (self.controlerStyle == UIControlerStyleSalon) {
        CGFloat tagimgeviewx = namex  ;
        CGFloat tagimgeviewy = CGRectGetMaxY(self.desclable.frame)+ maragin ;
        CGFloat tagimgevieww = 25;
        CGFloat tagimgeviewh = 12;
        self.tagimgeview.frame = CGRectMake(tagimgeviewx, tagimgeviewy, tagimgevieww, tagimgeviewh);
       huodongy = CGRectGetMaxY(self.desclable.frame) ;
        
    }else{
        
    CGFloat tagimgeviewx = namex  ;
    CGFloat tagimgeviewy = CGRectGetMaxY(self.tesecontent.frame);
    CGFloat tagimgevieww = 13;
    CGFloat tagimgeviewh = 13;
    self.tagimgeview.frame = CGRectMake(tagimgeviewx, tagimgeviewy, tagimgevieww, tagimgeviewh);
        huodongy = CGRectGetMaxY(self.tesecontent.frame) ;
    }
    
    CGFloat huodongx = CGRectGetMaxX(self.tagimgeview.frame) +5 ;
    CGFloat huodongw = MYScreenW - iconimagevieww - tagimagew - maragin *2;
    CGFloat huodongh = heighttext;
    self.huodong.frame = CGRectMake(huodongx, huodongy, huodongw, huodongh);

//    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.desclable.frame)+15, MYScreenW, 0.5);
    
}



@end
