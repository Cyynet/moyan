//
//  MYSalonSpeViewCell.m
//  魔颜
//
//  Created by abc on 16/4/26.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYSalonSpeViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "UILabel+Extension.h"
#import "MYHeader.h"

@interface MYSalonSpeViewCell ()

@property(strong,nonatomic) UILabel *title;
@property(strong,nonatomic) UILabel * addresslable;
@property(strong,nonatomic) UILabel * teselable;
@property(strong,nonatomic) UIImageView * listimage;
@property(strong,nonatomic) UIImageView * renzhengimage;

@property(strong,nonatomic) UILabel * youhuilable;
@property(strong,nonatomic) UILabel * youhuicontent;

@property(strong,nonatomic) NSString * tagbool;
@property(strong,nonatomic) UIImageView * dituimage;
@property(strong,nonatomic) UILabel * disclable;


@property(strong,nonatomic) UILabel * promisetitle;

@property(strong,nonatomic) UIButton * btn1;
@property(strong,nonatomic) UIButton * btn2;
@property(strong,nonatomic) UIButton * btn3;
@property(strong,nonatomic) UIButton * btn4;
@property(strong,nonatomic) NSArray * promiseArr;


@end
@implementation MYSalonSpeViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"%ld",(long)[indexPath row]];
    MYSalonSpeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYSalonSpeViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *listimage = [[UIImageView alloc]init];
        listimage.image  = [UIImage imageNamed:@"4"];
        [self.contentView addSubview:listimage];
        self.listimage = listimage;
        
        UILabel *title = [[UILabel alloc]init];
        title.text = @"北京凯利";
        title.textColor = UIColorFromRGB(0x1a1a1a);
        title.font  = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0];
        self.title = title;
        [self.contentView addSubview:title];
        
        
        
//        魔颜认证
        UIImageView *renzhengimage = [[UIImageView alloc]init];
        renzhengimage.image  = [UIImage imageNamed:@"moyanrenzheng"];
        [self.contentView addSubview:renzhengimage];
        self.renzhengimage = renzhengimage;

        
        UILabel *adresslable = [[UILabel alloc]init];
        adresslable.text = @"地址:    顺玉";
        adresslable.textColor = subTitleColor;
        adresslable.font  = leftFont;
        self.addresslable = adresslable;
        [self.contentView addSubview:adresslable];
        
        
        UILabel *teselable = [[UILabel alloc]init];
        teselable.text = @"北京凯利";
        teselable.textColor = subTitleColor;
        teselable.font  = leftFont;
        self.teselable = teselable;
        [self.contentView addSubview:teselable];
        
        
//       承诺
        UILabel * promisetitle = [[UILabel alloc]init];
        promisetitle.text = @"承诺:";
        [self.contentView addSubview:promisetitle];
        promisetitle.textColor =subTitleColor;
        promisetitle.font = leftFont;
        self.promisetitle = promisetitle;
        
        UIButton *btn1 = [[UIButton alloc]init];
        [self.contentView addSubview:btn1];
        [btn1 setImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateNormal];
        self.btn1 = btn1;
        [btn1 setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn1 setTintColor:[UIColor blackColor]];
        btn1.titleLabel.font = leftFont;
        btn1.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        UIButton *btn2 = [[UIButton alloc]init];
        [self.contentView addSubview:btn2];
        [btn2 setImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateNormal];
        self.btn2 = btn2;
        [btn2 setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn2 setTintColor:[UIColor blackColor]];
        btn2.titleLabel.font = leftFont;
        btn2.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        UIButton *btn3 = [[UIButton alloc]init];
        [self.contentView addSubview:btn3];
        [btn3 setImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateNormal];
        self.btn3 = btn3;
        [btn3 setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn3 setTintColor:[UIColor blackColor]];
        btn3.titleLabel.font = leftFont;
        btn3.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        UIButton *btn4 = [[UIButton alloc]init];
        [self.contentView addSubview:btn4];
        [btn4 setImage:[UIImage imageNamed:@"duigou"] forState:UIControlStateNormal];
        self.btn4 = btn4;
        [btn4 setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn4 setTintColor:[UIColor blackColor]];
        btn4.titleLabel.font = leftFont;
        btn4.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        btn1.enabled = NO;
        btn2.enabled = NO;
        btn3.enabled = NO;
        btn4.enabled = NO;
        
        
        UILabel *youhuilable = [[UILabel alloc]init];
        youhuilable.text = @"优惠";
        youhuilable.layer.borderWidth = 1;
        youhuilable.layer.borderColor = subTitleColor.CGColor;
        youhuilable.textColor = subTitleColor;
        youhuilable.font  = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
        self.youhuilable = youhuilable;
        [self.contentView addSubview:youhuilable];
        youhuilable.textAlignment = NSTextAlignmentCenter;
        
        
        UILabel *youhuicontent = [[UILabel alloc]init];
        youhuicontent.text = @"北京凯利";
        youhuicontent.textColor = subTitleColor;
        youhuicontent.font  = leftFont;
        self.youhuicontent = youhuicontent;
        [self.contentView addSubview:youhuicontent];
        
        
        UIImageView *dituimage = [[UIImageView alloc]init];
        [self.contentView addSubview:dituimage];
        dituimage.image  = [UIImage imageNamed:@"地图"];
        self.dituimage = dituimage;
        
        UILabel *disclable = [[UILabel alloc]init];
        [self.contentView addSubview:disclable];
        disclable.textColor = subTitleColor;
        disclable.font = leftFont;
        self.disclable = disclable;
        
        
        UIView *boomview = [[UIView alloc]init];
        self.boomview = boomview;
        [self addSubview:boomview];
        boomview.backgroundColor= UIColorFromRGB(0xf7f7f7);
        
//        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)setSalonmodel:(hospitaleListModel *)salonmodel
{
    _salonmodel = salonmodel;
    
     [self.listimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,salonmodel.listPic]]];
    
    self.title.text = salonmodel.name;

    if (salonmodel.cityName.length==0&&salonmodel.areaName.length ==0&&salonmodel.tradingName.length==0) {
        self.addresslable.text = [NSString stringWithFormat:@"地址:  %@",salonmodel.address];
    }else{
        self.addresslable.text = [NSString stringWithFormat:@"地址:  %@%@%@",salonmodel.cityName,salonmodel.areaName,salonmodel.tradingName];
    }
    
    if (salonmodel.feature.length==0) {
        self.teselable.hidden = YES;
    }else{
        self.teselable.text = [NSString stringWithFormat:@"特色:  %@",salonmodel.feature];
    }


    #pragma mark--承诺
    if ([salonmodel.approve isEqualToString:@""]) {
        self.promisetitle.hidden = YES;
        self.btn2.hidden = YES;
        self.btn4.hidden = YES;
        self.btn3.hidden = YES;
        self.btn1.hidden = YES;
    }else
    {
        self.promisetitle.hidden = NO;
        
        NSArray *arr = [salonmodel.approve componentsSeparatedByString:@","];
        
        self.promiseArr = arr;
       
        if (arr.count<2) {
            
            [self.btn1 setTitle:arr[0] forState:UIControlStateNormal];
            self.btn1.hidden = NO;
            self.btn2.hidden = YES;
            self.btn4.hidden = YES;
            self.btn3.hidden = YES;
        }else if(arr.count <3)
        {
            [self.btn1 setTitle:arr[0] forState:UIControlStateNormal];
            [self.btn2 setTitle:arr[1]  forState:UIControlStateNormal];
            self.btn1.hidden = NO;
            self.btn2.hidden = NO;
            self.btn3.hidden = YES;
            self.btn4.hidden = YES;
        }else if(arr.count <4)
        {
            [self.btn1 setTitle:arr[0] forState:UIControlStateNormal];
            [self.btn2 setTitle:arr[1] forState:UIControlStateNormal];
            [self.btn3 setTitle:arr[2] forState:UIControlStateNormal];
            self.btn1.hidden = NO;
            self.btn2.hidden = NO;
            self.btn3.hidden = NO;
            self.btn4.hidden = YES;
        }else if(arr.count <5){
            [self.btn1 setTitle:arr[0] forState:UIControlStateNormal];
            [self.btn2 setTitle:arr[1] forState:UIControlStateNormal];
            [self.btn3 setTitle:arr[2] forState:UIControlStateNormal];
            [self.btn4 setTitle:arr[3] forState:UIControlStateNormal];
            self.btn1.hidden = NO;
            self.btn2.hidden = NO;
            self.btn3.hidden = NO;
            self.btn4.hidden = NO;
        }
        
    }
    
    
    #pragma mark--优惠
    if (![salonmodel.tag isEqualToString:@""]) {
    
        self.youhuilable.hidden = NO;
        
        NSArray *array = [salonmodel.tag  componentsSeparatedByString:@" "];

            self.youhuicontent.text = array[0];
            self.tagbool = @"yes";

    }else{
        self.youhuilable.hidden = YES;
        self.youhuicontent.hidden = YES;
    }
    
    
    //    计算距离
    CGFloat lat =  [[MYUserDefaults objectForKey:@"latitude"]  floatValue];
    CGFloat lon =  [[MYUserDefaults objectForKey:@"longitude"]  floatValue];
    
    if(lat == 0 || salonmodel.latitude == 0){
        self.disclable.text = @"未知";
    }else{
        
        //第一个坐标
        CLLocation *current=[[CLLocation alloc] initWithLatitude: lat longitude:lon];
        
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:salonmodel.latitude longitude:salonmodel.longitude];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before];
        double distance = meters/1000;
        int disc = (int )distance;
        self.disclable.text = [NSString stringWithFormat:@"%dKM",disc];
        
    }

    if ([salonmodel.type isEqualToString:@"0"]) {
        self.renzhengimage.hidden = NO;
    }else{
        self.renzhengimage.hidden = YES;
    }
    
    [self layoutSubviews];
}


-(void)layoutSubviews
{
    [super layoutSubviews];

    self.listimage.frame = CGRectMake(kMargin, MYMargin, 112, 112);
    
    self.title.frame = CGRectMake(self.listimage.width+kMargin*2, MYMargin, 150, 20);
    self.renzhengimage.frame = CGRectMake(MYScreenW -37, kMargin+5, 20, 24);

    self.addresslable.frame = CGRectMake(self.listimage.width+kMargin*2, CGRectGetMaxY(self.title.frame)+kMargin/2, MYScreenW-112-kMargin*3, 20);
    self.teselable.frame = CGRectMake(self.listimage.width+kMargin*2, CGRectGetMaxY(self.addresslable.frame)+kMargin/2, MYScreenW-112-kMargin*3, 20);

    CGFloat promisetitlewidth = [self.promisetitle widthWithHeight:20];
    self.promisetitle.frame =   CGRectMake(self.teselable.x, CGRectGetMaxY(self.teselable.frame)+kMargin/2, promisetitlewidth, 20);
    
#pragma mark--设置承若标签的frame
    CGFloat btnwidth1 = [self.btn1.titleLabel widthWithHeight:20];
    self.btn1.frame = CGRectMake(self.teselable.x+promisetitlewidth+kMargin, CGRectGetMaxY(self.teselable.frame)+kMargin/2, btnwidth1+15, 20);
    CGFloat btnwidth2 = [self.btn2.titleLabel widthWithHeight:20];
    self.btn2.frame = CGRectMake(self.btn1.right+5, CGRectGetMaxY(self.teselable.frame)+kMargin/2, btnwidth2+15, 20);
    CGFloat btnwidth3 = [self.btn3.titleLabel widthWithHeight:20];
    self.btn3.frame = CGRectMake(self.btn2.right+5, CGRectGetMaxY(self.teselable.frame)+kMargin/2, btnwidth3+15, 20);
    CGFloat btnwidth4 = [self.btn4.titleLabel widthWithHeight:20];
    self.btn4.frame = CGRectMake(self.btn3.right+5, CGRectGetMaxY(self.teselable.frame)+kMargin/2, btnwidth4+15, 20);
    

    
    CGFloat width = [self.disclable widthWithHeight:20];
    self.youhuilable.frame = CGRectMake(self.listimage.width+kMargin*2, CGRectGetMaxY(self.teselable.frame)+MYMargin+8+2, 35, 15);
    
    self.youhuicontent.frame = CGRectMake(self.listimage.width+kMargin*3 + 35, CGRectGetMaxY(self.teselable.frame)+MYMargin+8, MYScreenW-112-kMargin*3-width, 20);

    self.disclable.frame = CGRectMake(MYScreenW-width-kMargin, self.youhuilable.y-2, width, 20);
    
    self.dituimage.frame  =CGRectMake(MYScreenW-width-kMargin*2.5, self.youhuilable.y, 10, 13);

    
    self.boomview.frame = CGRectMake(0,0, MYScreenW, kMargin);

}
@end
