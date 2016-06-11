//
//  MYLifeSecondTableViewCell.m
//  魔颜
//
//  Created by abc on 16/2/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYLifeSecondTableViewCell.h"
#import "MYHeader.h"

@interface MYLifeSecondTableViewCell ()

@property(strong,nonatomic) UIImageView *bigimageview;
@property(strong,nonatomic) UILabel * orgetion;
@property(strong,nonatomic) UILabel * title;
@property(strong,nonatomic) UILabel * desc;
@property(strong,nonatomic) UILabel * allprice;
@property(strong,nonatomic) UILabel * price;

@property(strong,nonatomic) UIView * discountview;
@property(strong,nonatomic) UILabel * toplable;
@property(strong,nonatomic) UILabel * boomlable;

@property(strong,nonatomic) UIView * line;

@end

@implementation MYLifeSecondTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView  index:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"LifeSecond%ld",(long)[indexPath row]];
    MYLifeSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[MYLifeSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *bigimageview = [[UIImageView alloc]init];
        self.bigimageview = bigimageview;
        [self addSubview:bigimageview];

        
        UILabel *orgertion = [[UILabel alloc]init];
        self.orgetion = orgertion;
        [self addSubview:orgertion];
        orgertion.font = MianFont;
        orgertion.textColor = subTitleColor;
      
        
        UILabel *title = [[UILabel alloc]init];
        self.title = title;
        [self addSubview:title];
        title.font = MianFont;
        title.textColor = titlecolor;
        
        
        UILabel *desc = [[UILabel alloc]init];
        self.desc = desc;
        [self addSubview:desc];
        desc.font = MianFont;
        desc.textColor = subTitleColor;
        desc.numberOfLines = 0;
        
        
        UILabel *allprice = [[UILabel alloc]init];
        self.allprice = allprice;
        [self addSubview:allprice];
        allprice.font = MianFont;
        allprice.textColor = [UIColor lightGrayColor];
        allprice.alpha = 0.5;
        
        
        UILabel *price = [[UILabel alloc]init];
        self.price = price;
        [self addSubview:price];
        price.font = MianFont;
        price.textColor = [UIColor redColor];
        
        
        UIView *discountview = [[UIView alloc]init];
        [self addSubview:discountview];
        discountview.layer.cornerRadius = 25;
        discountview.layer.masksToBounds = YES;
        self.discountview = discountview;
        
        
        UILabel *toplable = [[UILabel alloc]init];
        self.toplable = toplable;
        [self.discountview addSubview:toplable];
        toplable.font = [UIFont systemFontOfSize:11];
        toplable.textColor = subTitleColor;
        toplable.backgroundColor = UIColorFromRGB(0xf2f2f2);
        toplable.textAlignment = NSTextAlignmentCenter;
        
        
        UILabel *boomlable = [[UILabel alloc]init];
        self.boomlable = boomlable;
        [self.discountview addSubview:boomlable];
        boomlable.font = [UIFont systemFontOfSize:9];
        boomlable.textColor = [UIColor whiteColor];
        boomlable.backgroundColor  = UIColorFromRGB(0xff8c9b);
        boomlable.textAlignment = NSTextAlignmentCenter;
     
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.2;
        self.line = line;
        [self addSubview:line];
        
    }
    return self;
}

-(void)setLifenmodle:(MYLifeSecondModle *)lifenmodle
{
    
    [self setData:lifenmodle];
    [self setframe];
}

-(void)setData:(MYLifeSecondModle*)lifenmodle
{
    _lifenmodle = lifenmodle;
    
    [self.bigimageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,lifenmodle.listPic]]];
    
    self.orgetion.text = lifenmodle.salonName;
    self.title.text = lifenmodle.title;
    self.desc.text = lifenmodle.desc;
    self.allprice.text = [NSString stringWithFormat:@"¥%@",lifenmodle.price];
    self.price.text = [NSString stringWithFormat:@"¥%@",lifenmodle.discountPrice];

//    判断前3位是否是0.0，以及4位是否大于5，舍入问题
   float disstr1 = lifenmodle.zeKou;
    NSString *disstr = [NSString stringWithFormat:@"%f",disstr1];
    
    NSString *str3 = [disstr substringToIndex:3];
    if ([str3 isEqualToString:@"0.0"]) {
        
        NSString *str4 = [disstr substringWithRange:NSMakeRange(3, 1)];
        NSInteger sheru  = [str4 integerValue];
        if (sheru >= 5) {
            
            NSInteger ru = [str3 integerValue];
            NSInteger ru1 = ru+0.1;
            NSString *ru1str = [NSString stringWithFormat:@"%ld",(long)ru1];
            self.toplable.text = [NSString stringWithFormat:@"%@折",ru1str];
            
        }else{
            
          self.toplable.text = @"惊喜价";
        }
    }else
    {
        NSString *str4 = [disstr substringWithRange:NSMakeRange(3, 1)];
        NSInteger sheru  = [str4 integerValue];
        if (sheru >= 5) {
            
            double ru = [str3 doubleValue];
            double ru1 = ru+0.1;
            
            self.toplable.text = [NSString stringWithFormat:@"%.1f折",ru1];
            
        }else{
        
            self.toplable.text = [NSString stringWithFormat:@"%@折",str3];
        }
        
    }
    
   self.boomlable.text = @"马上抢购";
    
    //    画删除线
    NSUInteger length = [self.allprice.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.allprice.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
    [self.allprice setAttributedText:attri];

}

-(void)setframe
{

    CGFloat heigt = kMargin*2;
    
    CGFloat bigiamgex = kMargin;
    CGFloat bigiamgey = kMargin;
    CGFloat bigiamgew = 100;
    CGFloat bigiamgeh = 100;
    self.bigimageview.frame = CGRectMake(bigiamgex, bigiamgey, bigiamgew, bigiamgeh);
    
    CGFloat orgetionx = CGRectGetMaxX(self.bigimageview.frame)+kMargin*2;
    CGFloat orgetiony = kMargin;
    CGFloat orgetionw = MYScreenW-bigiamgew-kMargin*3;
    CGFloat orgetionh = heigt;
    self.orgetion.frame = CGRectMake(orgetionx, orgetiony, orgetionw, orgetionh);

    CGFloat titlex = orgetionx;
    CGFloat titley = CGRectGetMaxY(self.orgetion.frame);
    CGFloat titlew = orgetionw;
    CGFloat titleh = heigt;
    self.title.frame = CGRectMake(titlex, titley, titlew, titleh);

    CGFloat descx = orgetionx;
    CGFloat descy = CGRectGetMaxY(self.title.frame);
    CGFloat descw = orgetionw;
    CGFloat desch = heigt;
    self.desc.frame = CGRectMake(descx, descy, descw, desch);

    CGFloat allpricex = orgetionx;
    CGFloat allpricey = CGRectGetMaxY(self.desc.frame);
    CGFloat allpricew = 60;
    CGFloat allpriceh = heigt;
    self.allprice.frame = CGRectMake(allpricex, allpricey, allpricew, allpriceh);

    CGFloat pricex = orgetionx;
    CGFloat pricey = CGRectGetMaxY(self.allprice.frame);
    CGFloat pricew = 60;
    CGFloat priceh = heigt;
    self.price.frame = CGRectMake(pricex, pricey, pricew, priceh);

    CGFloat discountviewx = MYScreenW-55;
    CGFloat discountviewy = 60;
    CGFloat discountvieww = 50;
    CGFloat discountviewh = 50;
    self.discountview.frame = CGRectMake(discountviewx, discountviewy, discountvieww, discountviewh);

    CGFloat toplablex = 0;
    CGFloat toplabley = 0;
    CGFloat toplablew = 50;
    CGFloat toplableh = 25;
    self.toplable.frame = CGRectMake(toplablex, toplabley, toplablew, toplableh);
    
    CGFloat boomlablex = 0;
    CGFloat boomlabley = 25-0.1;
    CGFloat boomlablew = 50;
    CGFloat boomlableh = 25;
    self.boomlable.frame = CGRectMake(boomlablex, boomlabley, boomlablew, boomlableh);

    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.discountview.frame)+kMargin, MYScreenW, 0.8);
}

@end
