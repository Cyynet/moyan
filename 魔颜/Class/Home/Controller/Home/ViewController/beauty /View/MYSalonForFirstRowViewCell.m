//
//  MYSalonForFirstRowViewCell.m
//  魔颜
//
//  Created by abc on 16/4/26.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYSalonForFirstRowViewCell.h"
#import "MYHeader.h"

@interface MYSalonForFirstRowViewCell ()

@property(strong,nonatomic) UIImageView * iconview;

@end

@implementation MYSalonForFirstRowViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"%ld",(long)[indexPath row]];
    MYSalonForFirstRowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYSalonForFirstRowViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        UIImageView *iconview = [[UIImageView alloc]init];
        [self.contentView addSubview:iconview];
        self.iconview = iconview;
        
    }
    return self;
}
-(void)setImageurl:(NSString *)imageurl
{
    _imageurl = imageurl;
    [self.iconview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,imageurl]]];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.iconview.frame = CGRectMake(0,0, MYScreenW, MYScreenW / 2.5);
    
}
@end
