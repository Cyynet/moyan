//
//  MYRandomChatTableViewCell.m
//  魔颜
//
//  Created by abc on 16/5/10.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYRandomChatTableViewCell.h"
#import "NSString+Extension.h"
#import "MYHeader.h"

@interface MYRandomChatTableViewCell ()

@property(strong,nonatomic) UIImageView* iconimage;

@property(strong,nonatomic) UILabel * namelable;

@property(strong,nonatomic) UILabel * timelable;

@property(strong,nonatomic) UIImageView * bigimage;

@property(strong,nonatomic) UIView * coverview;

@property(strong,nonatomic) UILabel * coverlable;




@property(strong,nonatomic) UILabel * readernumber;

@property(strong,nonatomic) UIImageView * readerimage;



@end

@implementation MYRandomChatTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = [NSString stringWithFormat:@"randomchatList%ld",(long)[indexPath row]];
    MYRandomChatTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MYRandomChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        iconimage.image = [UIImage imageNamed:@"bresh"];
        self.iconimage =iconimage;
        
        
        UILabel * namelable  = [[UILabel alloc]init];
        [self.contentView addSubview:namelable];
        namelable.text =@"文森特";
        namelable.font = MYFont(14);
        namelable.textColor = UIColorFromRGB(0x333333);
        self.namelable = namelable;
        
        UILabel * timelable  = [[UILabel alloc]init];
        [self.contentView addSubview:timelable];
        timelable.text =@"2016-05-09 14:30:50";
        timelable.font = MYFont(12);
        timelable.textColor = UIColorFromRGB(0x333333);
        self.timelable = timelable;
        
        
        //大图
        UIImageView *bigimage = [[UIImageView alloc]init];
        [self.contentView addSubview:bigimage];
        bigimage.contentMode = UIViewContentModeScaleAspectFill;
        bigimage.clipsToBounds = YES;
        self.bigimage  = bigimage;
        
        
        UIView *coverview = [[UIView alloc]init];
        coverview.backgroundColor  =[UIColor whiteColor];
        coverview.alpha = 0.85;
        [bigimage addSubview:coverview];
        self.coverview = coverview;
        
        
        UILabel * coverlable  = [[UILabel alloc]init];
        [coverview addSubview:coverlable];
        coverlable.text =@"传说中的永久脱毛是真的吗?";
        coverlable.font = MYFont(14);
        coverlable.textColor = UIColorFromRGB(0x1a1a1a);
        self.coverlable = coverlable;
        
        
        
        UILabel *readernumber = [[UILabel alloc]init];
        [self.coverview addSubview:readernumber];
        self.readernumber = readernumber;
        readernumber.text= @"32";
        readernumber.font = MYFont(11);
        readernumber.textColor = UIColorFromRGB(0x4c4c4c);
        
        
        UIImageView *readerimage = [[UIImageView alloc]init];
        [self.coverview addSubview:readerimage];
        self.readerimage = readerimage;
        readerimage.image = [UIImage imageNamed:@"eye"];
        
        
        UIView *boomview = [[UIView alloc]init];
        [self.contentView addSubview:boomview];
        boomview.backgroundColor = UIColorFromRGB(0xf7f7f7);
        self.boomview = boomview;
    }
    return self;
}

-(void)setRandomchatmodle:(MYRandonChatModle *)randomchatmodle
{
    _randomchatmodle = randomchatmodle;
    
    [self.iconimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,randomchatmodle.userPic]]];

//      BOOL accountNumGood = [MYStringFilterTool   filterByPhoneNumber:randomchatmodle.name];
 //     if (accountNumGood) {
        
//      NSString *str1 = [randomchatmodle.name substringWithRange:NSMakeRange(0, 3)];
//      NSString *str3 = [randomchatmodle.name substringWithRange:NSMakeRange(7, 4)];
        
//      self.namelable.text = [NSString stringWithFormat:@"%@****%@",str1,str3];
//      }

    
    
    self.namelable.text = randomchatmodle.name;
    self.timelable.text = randomchatmodle.createTime;
 
    
    [self.bigimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,randomchatmodle.homePic]]];
    
    
        self.coverlable.text = randomchatmodle.title;
    
        self.readernumber.text = randomchatmodle.readNumber;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = 15;
    
    self.iconimage.frame = CGRectMake(kMargin, MYMargin, 35, 35);
    
    CGFloat namewidth = [self.namelable.text widthWithFont:MYFont(14)];
    self.namelable.frame = CGRectMake(kMargin+self.iconimage.right, MYMargin, namewidth, height);
    
    
    CGFloat timewidth = [self.timelable.text widthWithFont:MYFont(12)];
    self.timelable.frame = CGRectMake(kMargin+self.iconimage.right,self.namelable.bottom+5 ,MYScreenW-MYMargin-_iconimage.width ,height);

    
    self.bigimage.frame = CGRectMake( kMargin,self.iconimage.bottom+kMargin, MYScreenW-MYMargin, 217);
    
    
    self.coverview.frame = CGRectMake(0, self.bigimage.height - 40, self.bigimage.width, 40);
    
    self.coverlable.frame = CGRectMake(kMargin/2, 0, self.bigimage.width, 40);
    
    
    
    CGFloat readernumberwidth = [self.readernumber.text widthWithFont:MYFont(11)];
    self.readernumber.frame = CGRectMake(MYScreenW-MYMargin-10 -readernumberwidth, 0, readernumberwidth, 40);
    
    self.readerimage.frame = CGRectMake(MYScreenW-readernumberwidth-kMargin*3-20, 15, 15, 9);
    
    
    self.boomview.frame = CGRectMake(0,0 ,MYScreenW ,kMargin);
    
}



@end
