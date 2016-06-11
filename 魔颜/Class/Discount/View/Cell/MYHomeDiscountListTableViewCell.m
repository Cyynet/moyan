//
//  MYHomeDiscountListTableViewCell.m
//  魔颜
//
//  Created by abc on 15/11/2.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYHomeDiscountListTableViewCell.h"
#import "MYHeader.h"

//#define DeatilTiltleFont [UIFont systemFontOfSize:12]


#define  titleColor MYColor(170, 170, 170)


@interface MYHomeDiscountListTableViewCell ()


@property(weak,nonatomic)UIImageView    *iconimageview;

@property(strong,nonatomic)  UILabel * titlelable;

@property(strong,nonatomic) UILabel * titledeatil;

@property(strong,nonatomic) UILabel * pricelable;

@property(strong,nonatomic) UILabel * yuanPriceTitle;

@property(strong,nonatomic) UILabel * yuanPricelable;

@property(strong,nonatomic) UILabel * dinggouNumber;

@property(strong,nonatomic) UIView *line;


@property(strong,nonatomic) UILabel * hospital;

@property(strong,nonatomic) UIView * lineview;


@end


@implementation MYHomeDiscountListTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView NSIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *ID = [NSString stringWithFormat:@"Cell%ld",(long)[indexPath row]];
    MYHomeDiscountListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MYHomeDiscountListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        作图
        UIImageView *iconimageview = [[UIImageView alloc]init];
        self.iconimageview = iconimageview;
        [self addSubview:iconimageview];
        
        //        title
        UILabel *titlelable = [[UILabel alloc]init];
        self.titlelable = titlelable;
        [self addSubview:titlelable];
        titlelable.font = leftFont;
        titlelable.textColor = [UIColor blackColor] ;
        titlelable.numberOfLines = 0;
        
        
        UILabel *titledeatil = [[UILabel alloc]init];
        self.titledeatil = titledeatil;
        [self addSubview:titledeatil];
        titledeatil.font = leftFont;
        titledeatil.textColor = titleColor;
        
        
        
        //      打折价
        UILabel *price = [[UILabel alloc]init];
        self.pricelable = price;
        [self addSubview:price];
        price.text = @"$786.00";
        price.textColor = [UIColor redColor];
        price.font = leftFont;
        
        
        //        医院价
        UILabel *yuanPriceTitle= [[UILabel alloc]init];
        self.yuanPriceTitle = yuanPriceTitle;
        [self addSubview:yuanPriceTitle];
        yuanPriceTitle.text = @"医院价:";
        yuanPriceTitle.textColor = titleColor;
        yuanPriceTitle.font = leftFont;
        
        
        //        原价格
        UILabel *yuanPrice= [[UILabel alloc]init];
        self.yuanPricelable = yuanPrice;
        [self addSubview:yuanPrice];
        yuanPrice.text = @"$78323.00";
        yuanPrice.textColor = titleColor;
        yuanPrice.font = leftFont;
        yuanPrice.textAlignment = NSTextAlignmentLeft;
        
        
        UIView *line = [[UIView alloc]init];
        self.line = line;
        [self addSubview:line];
        line.backgroundColor = [UIColor blackColor];
        line.alpha = 0.2;
        
        
        //        订购数
        UILabel *dinggouNumber = [[UILabel alloc]init];
        self.dinggouNumber = dinggouNumber;
        [self addSubview:dinggouNumber];
        //        dinggouNumber.text = @"$786.00";
        dinggouNumber.textColor = titleColor;
        dinggouNumber.font = leftFont;
        dinggouNumber.textAlignment = NSTextAlignmentRight;
        
        
        
        UILabel *hospital = [[UILabel alloc]init];
        self.hospital = hospital;
        [self addSubview:hospital];
        hospital.font = leftFont;
        hospital.textColor = titleColor;
     
        
        UIView *lineview = [[UIView alloc]init];
        self.lineview = lineview;
        [self addSubview:lineview];
        lineview.backgroundColor = [UIColor lightGrayColor];
        lineview.alpha = 0.5;
        
        
    }
    
    return self;
}



-(void)setDiscountList:(MYDiscountListModel *)discountList
{
    [self setupStatus:discountList];
    [self setupFrame];
    
    
}


-(void)setupStatus:(MYDiscountListModel *)discountList
{
    
    _discountList = discountList;
    
    
    [self.iconimageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,discountList.smallPic]]];
    
    
    //        title 详解
    self.titlelable.text = discountList.title;
    
    self.titledeatil.text = discountList.des;
    
    self.hospital.text = discountList.hospitalName;
    
    
    
    
    self.pricelable.text = [NSString stringWithFormat:@"¥%@",discountList.discountPrice];
    self.yuanPricelable.text = [NSString stringWithFormat:@"¥%@",discountList.price];
    //    self.dinggouNumber.text = [NSString stringWithFormat:@"%@人预定",discountList.buyNumber];
    
    
}

-(void)setupFrame
{
    
    CGFloat maragin = 10;
    CGFloat kmaragin = 20;
    
    CGFloat iconimageviewx = maragin;
    CGFloat iconimageviewy = maragin;
    CGFloat iconimagevieww = 100;
    CGFloat iconimageviewh = 100;
    self.iconimageview.frame = CGRectMake(iconimageviewx, iconimageviewy, iconimagevieww, iconimageviewh);
    
    
    CGFloat titlelablex =   CGRectGetMaxY(self.iconimageview.frame)+kmaragin;
    CGFloat titlelabley = iconimageviewy;
    CGFloat titlelablew =  MYScreenW - iconimagevieww - maragin *3;
    CGSize maxtitlesize = CGSizeMake(titlelablew, MAXFLOAT);
    CGSize maxtitleSize = [self.titlelable.text sizeWithFont:leftFont constrainedToSize:maxtitlesize];
    self.titlelable.frame = (CGRect){titlelablex, titlelabley, maxtitleSize};
    
    
    //  desc
    CGFloat titledeatilx= titlelablex;
    CGFloat titledeatily = CGRectGetMaxY(self.titlelable.frame);
    CGFloat titledeatilw = titlelablew;
    CGSize maxtitledeatilsize = CGSizeMake(titledeatilw, MAXFLOAT);
    CGSize maxtitledeatilSize = [self.titledeatil.text sizeWithFont:leftFont constrainedToSize:maxtitledeatilsize];
    self.titledeatil.frame = (CGRect){titledeatilx, titledeatily, maxtitledeatilSize};
    
    
    //  打折价
    CGFloat pricelablex = titlelablex;
    CGFloat pricelabley = CGRectGetMaxY(self.titledeatil.frame);
    CGFloat pricelablew = maragin *20;
    CGFloat pricelableh = kmaragin;
    self.pricelable.frame = CGRectMake(pricelablex, pricelabley, pricelablew, pricelableh);
    
    
    
    //    原价
    CGFloat yuanPriceTitlex = titlelablex;
    CGFloat yuanPriceTitley = CGRectGetMaxY(self.pricelable.frame);
    CGFloat yuanPriceTitlew = maragin * 4;
    CGFloat yuanPriceTitleh = kmaragin;
    self.yuanPriceTitle.frame = CGRectMake(yuanPriceTitlex, yuanPriceTitley, yuanPriceTitlew, yuanPriceTitleh);
    
    
    CGFloat yuanPricelablex = CGRectGetMaxX(self.yuanPriceTitle.frame);
    CGFloat yuanPricelabley = yuanPriceTitley;
    CGFloat yuanPricelablew = maragin * 8;
    CGFloat yuanPricelableh = kmaragin;
    CGSize maxYuanPricesize = CGSizeMake(yuanPricelablew, MAXFLOAT);
    CGSize maxYuanPriceSize = [self.yuanPricelable.text sizeWithFont:leftFont constrainedToSize:maxYuanPricesize];
    self.yuanPricelable.frame = CGRectMake(yuanPricelablex, yuanPricelabley, yuanPricelablew, yuanPricelableh);
    
    
    //    line
    CGFloat linex = CGRectGetMaxX(self.yuanPriceTitle.frame);
    CGFloat liney = yuanPriceTitley + 10;
    CGFloat linew = maxYuanPriceSize.width;
    CGFloat lineh = 1;
    self.line.frame = CGRectMake(linex, liney, linew, lineh);
    
    
    
    
    CGFloat dinggouNumbery = yuanPriceTitley;
    CGFloat dinggouNumberw = maragin *20;
    CGFloat dinggouNumberx = MYScreenW - maragin - dinggouNumberw;
    CGFloat dinggouNumberh = kmaragin;
    self.dinggouNumber.frame = CGRectMake(dinggouNumberx, dinggouNumbery, dinggouNumberw, dinggouNumberh);
    
    
    CGFloat hospitalx = CGRectGetMaxX(self.iconimageview.frame)+ maragin;
    CGFloat hospitaly = CGRectGetMaxY(self.yuanPriceTitle.frame) ;
    CGFloat hospitalw = MYScreenW - iconimagevieww - maragin *2;
    CGFloat hospitalh = kmaragin;
    self.hospital.frame = CGRectMake(hospitalx, hospitaly, hospitalw, hospitalh);
    
    
    
    
    CGFloat iconheigt = CGRectGetMaxY(self.iconimageview.frame)+5;

    
    self.lineview.frame  = CGRectMake(0, iconheigt +5, MYScreenW, 0.5);
    
}



@end
