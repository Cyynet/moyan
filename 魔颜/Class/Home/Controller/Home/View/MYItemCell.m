//
//  MYItemCell.m
//  魔颜
//
//  Created by Meiyue on 16/4/12.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYItemCell.h"
#import "UILabel+Extension.h"
#import <CoreLocation/CoreLocation.h>
#import "NSString+Extension.h"
#import "MYHeader.h"


@interface MYItemCell ()

@property(strong,nonatomic) UIImageView *imagView;
@property(strong,nonatomic) UILabel *descLabel;
@property(strong,nonatomic) UILabel *distanceLabel;

@property(strong,nonatomic) UILabel *priceLable;
@property(strong,nonatomic) UIView * lineview;

@property(strong,nonatomic) UIImageView * locationicon;

@property(strong,nonatomic) NSArray * tagicon;

/** <#注释#> */
@property (nonatomic, assign) NSInteger id;

@end

@implementation MYItemCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        [self setupUI];
    }
    return self;
}

/**
 *  美容
 */
- (void)setSalonArr:(MYSalonSpe *)salonArr
{
    _salonArr = salonArr;
    
    self.id = salonArr.id;
      
    [self.imagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,salonArr.listPic]] placeholderImage:[UIImage imageNamed:@"6.jpg"]];
    
    
    NSArray *array = [salonArr.title componentsSeparatedByString:@" "];
    NSString *str = array[0];
    if (str.length >9) {
        self.descLabel.text = [str substringToIndex:9];
    }else
    {
        self.descLabel.text = array[0];
    }
    
    
    self.discountPrice.text = [NSString stringWithFormat:@"￥%@",salonArr.discountPrice];
    self.priceLable.text = [NSString stringWithFormat:@"￥%@",salonArr.price];
    //    计算距离
    CGFloat lat =  [[MYUserDefaults objectForKey:@"latitude"]  floatValue];
    CGFloat lon =  [[MYUserDefaults objectForKey:@"longitude"]  floatValue];
    
    if(lat == 0 || salonArr.latitude == 0){
        self.distanceLabel.text = @"未知";
    }else{
        
        //第一个坐标
        CLLocation *current=[[CLLocation alloc] initWithLatitude: lat longitude:lon];
        
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:salonArr.latitude longitude:salonArr.longitude];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before];
        double distance = meters/1000;
        int disc = (int )distance;
        self.distanceLabel.text = [NSString stringWithFormat:@"%dKM",disc];
        
    }
    
    [self layoutSubviews];
    
}

/**
 *  医美
 */
- (void)setHosArr:(MYHosSpe *)hosArr
{
    _hosArr = hosArr;
    self.id = hosArr.id;
    
    [self.imagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,hosArr.smallPic]] placeholderImage:[UIImage imageNamed:@"6"]];
    
    NSArray *array = [hosArr.title componentsSeparatedByString:@" "];
    NSString *str = array[0];
    if (str.length >9) {
        self.descLabel.text = [str substringToIndex:9];
    }else
    {
        self.descLabel.text = array[0];
    }
    self.descLabel.text = array[0];
    self.discountPrice.text = [NSString stringWithFormat:@"￥%@",hosArr.discountPrice];
    self.priceLable.text = [NSString stringWithFormat:@"￥%@",hosArr.price];
    
    //    计算距离
    CGFloat lat =  [[MYUserDefaults objectForKey:@"latitude"]  floatValue];
    CGFloat lon =  [[MYUserDefaults objectForKey:@"longitude"]  floatValue];
    
    if(lat == 0 || hosArr.latitude == 0){
        self.distanceLabel.text = @"未知";
    }else{
        
        //第一个坐标
        CLLocation *current=[[CLLocation alloc] initWithLatitude: lat longitude:lon];
        
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:hosArr.latitude longitude:hosArr.longitude];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before];
        double distance = meters/1000;
        int disc = (int )distance;
        self.distanceLabel.text = [NSString stringWithFormat:@"%dKM",disc];
        
    }
    [self layoutSubviews];
    
}

/**
 *  美购
 */
- (void)setOwnArr:(MYOwnSpe *)ownArr
{
    _ownArr = ownArr;
    self.id = ownArr.id;
    
    [self.imagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,ownArr.smallPic]] placeholderImage:[UIImage imageNamed:@"6.jpg"]];
    
    NSArray *array = [ownArr.title componentsSeparatedByString:@" "];
    NSString *str = array[0];
    if (str.length >11) {
        self.descLabel.text = [str substringToIndex:11];
    }else
    {
        self.descLabel.text = array[0];
    }
    self.discountPrice.text = [NSString stringWithFormat:@"￥%@",ownArr.discountPrice];
    self.priceLable.text = [NSString stringWithFormat:@"￥%@",ownArr.price];
    
    self.locationicon.hidden = YES;
    [self layoutSubviews];
    
}
- (void)setupUI
{
    self.imagView = [[UIImageView alloc] init];
    [self addSubview:self.imagView];
    
    if (MYScreenW > 320) {
        self.descLabel = [UILabel addLabelWithTitle:nil titleColor:titlecolor font:MYFont(13)];
        self.distanceLabel = [UILabel addLabelWithTitle:nil titleColor:titlecolor font:MYFont(10)];
        self.discountPrice = [UILabel addLabelWithTitle:nil titleColor:nil font:MYFont(13)];
        self.priceLable = [UILabel addLabelWithTitle:nil titleColor:UIColorFromRGB(0x999999) font:MYFont(10)];
        self.priceLable.textColor = UIColorFromRGB(0xb3b3b3);
        self.distanceLabel.textColor = UIColorFromRGB(0x999999);
    }else{
        self.descLabel = [UILabel addLabelWithTitle:nil titleColor:titlecolor font:MYFont(11)];
        self.distanceLabel = [UILabel addLabelWithTitle:nil titleColor:titlecolor font:MYFont(10)];
        self.discountPrice = [UILabel addLabelWithTitle:nil titleColor:nil font:MYFont(11)];
        self.priceLable = [UILabel addLabelWithTitle:nil titleColor:UIColorFromRGB(0x999999) font:MYFont(10)];
        self.priceLable.textColor = UIColorFromRGB(0xb3b3b3);
        self.distanceLabel.textColor = UIColorFromRGB(0x99999);
    }
    self.discountPrice.textColor = MYRedColor;
    [self addSubview:_descLabel];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.discountPrice];
    [self addSubview:self.priceLable];
    
    
    self.lineview = [[UIView alloc]init];
    [self.priceLable addSubview:self.lineview];
    self.lineview.backgroundColor = [UIColor blackColor];
    self.lineview.alpha = 0.4;
    
    UIImageView *locationicon = [[UIImageView alloc]init];
    locationicon.image = [UIImage imageNamed:@"地图"];
    [self addSubview:locationicon];
    self.locationicon = locationicon;
    
    UIButton *btn = [[UIButton alloc] init];
    self.itemBtn = btn;
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}

- (void)clickBtn
{
    
    [MYNotificationCenter postNotificationName:@"MYItem" object:nil
                                      userInfo:@{@"MYTag" : @(self.tag),@"MYBtnTag" : @(self.itemBtn.tag),@"MYID" : @(self.id)}];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imagView.frame = CGRectMake(5, 10, self.width-10, self.width-10);
    
    CGFloat width = [self.descLabel widthWithHeight:25];
    self.descLabel.frame = CGRectMake(self.width * 0.048, self.height * 0.77, width, 25);
    
    CGFloat distanceWidth = [self.distanceLabel widthWithHeight:25];
    self.distanceLabel.frame = CGRectMake(self.width - distanceWidth - self.width * 0.048, self.descLabel.y,distanceWidth, 25);
    
    self.locationicon.frame = CGRectMake(self.distanceLabel.x - 8, self.descLabel.y+6.5, 7, 11);
    
    CGFloat discountWidth = [self.discountPrice widthWithHeight:25];
    self.discountPrice.frame = CGRectMake(self.descLabel.x, self.height*0.86, discountWidth, 25);
    
    CGFloat pricewith = [self.priceLable widthWithHeight:25];
    self.priceLable.frame = CGRectMake(self.width - pricewith - self.descLabel.x, self.discountPrice.y, pricewith, 25);
    
    self.lineview.frame = CGRectMake(1, self.priceLable.height/2, pricewith, 0.5);
    
    self.itemBtn.frame = CGRectMake(0, 0, self.width, self.height);
    
}



@end
