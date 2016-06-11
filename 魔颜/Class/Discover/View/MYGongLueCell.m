
//
//  MYGongLueCell.m
//  魔颜
//
//  Created by abc on 16/5/5.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYGongLueCell.h"
#import "NSString+Extension.h"
#import "MYHeader.h"

@interface MYGongLueCell ()

@property(strong,nonnull) UIImageView *bigimage;

@property(strong,nonatomic) UIView * coverview;
@property(strong,nonatomic) UILabel * coverlable;


@property(strong,nonatomic) UILabel * readernumber;
@property(strong,nonatomic)  UIImageView* numberimage;


@end
@implementation MYGongLueCell

+(instancetype)cellwithTableview:(UITableView*)tableview indexPath:(NSIndexPath*)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"gongluecell"];
    MYGongLueCell *cell  = [tableview cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[MYGongLueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
     
        UIImageView *bigimage = [[UIImageView alloc]init];
        [self.contentView addSubview:bigimage];
        bigimage.image = [UIImage imageNamed:@"big"];
        self.bigimage = bigimage;
        
        UIView *coverview = [[UIView alloc]init];
        [bigimage addSubview:coverview];
        coverview.backgroundColor = [UIColor whiteColor];
        coverview.alpha = 0.85;
        self.coverview = coverview;
        
        
        UILabel *coverlable = [[UILabel alloc]init];
        [bigimage addSubview:coverlable];
        self.coverlable = coverlable;
        coverlable.text = @"美白针的美白";
        coverlable.textColor = UIColorFromRGB(0x1a1a1a);
        coverlable.font = MYFont(14);
        
        
        UIView *boomview = [[UIView alloc]init];
        self.boomview = boomview;
        boomview.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self.contentView addSubview:boomview];
        
        
        UILabel *readernumber = [[UILabel alloc]init];
        [self.bigimage addSubview:readernumber];
        readernumber.font = MYFont(11);
        readernumber.textColor = UIColorFromRGB(0x4c4c4c);
        readernumber.text = @"23458";
        self.readernumber = readernumber;
        
        UIImageView *numberimage = [[UIImageView alloc]init];
        [self.bigimage addSubview:numberimage];
        numberimage.image =  [UIImage imageNamed:@"eye"];
        self.numberimage = numberimage;
        
        
    }
    return  self;
}

-(void)setListmodle:(MYGongLueListModle *)listmodle
{
    _listmodle = listmodle;
    
    [self.bigimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,listmodle.homePagePic]] placeholderImage:[UIImage imageNamed:@"big"]];
    
    self.coverlable.text = listmodle.title;
    
    self.readernumber.text = listmodle.pageView;
    

}
-(void)layoutSubviews
{
    [super layoutSubviews];

    self.bigimage.frame = CGRectMake(kMargin, MYMargin, MYScreenW-MYMargin, 217);
    
    self.coverview.frame = CGRectMake(0, self.bigimage.height-40, self.bigimage.width, 40);
    
     CGFloat numberwidth = [self.readernumber.text widthWithFont:MYFont(11)];
    
    self.coverlable.frame = CGRectMake(8, self.bigimage.height-40, self.bigimage.width-8-15-5-numberwidth, 40);
    
    self.readernumber.frame = CGRectMake(self.bigimage.width-numberwidth-5, self.bigimage.height-40, numberwidth, 40);
    
    self.numberimage.frame = CGRectMake(self.bigimage.width-numberwidth-8-15, self.readernumber.y+15, 15, 9);
    
    
    self.boomview.frame = CGRectMake(0, 0, MYScreenW, 10);
}


@end
