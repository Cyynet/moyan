//
//  MYRequestTableViewCell.m
//  魔颜
//
//  Created by abc on 16/5/10.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYRequestTableViewCell.h"
#import "NSString+Extension.h"

@interface MYRequestTableViewCell ()

@property(strong,nonatomic) UILabel *titlelable;
@property(strong,nonatomic) UILabel * rightlable;


@end


@implementation MYRequestTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = [NSString stringWithFormat:@"requestList%ld",(long)[indexPath row]];
    MYRequestTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MYRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel * titlelable  = [[UILabel alloc]init];
        [self.contentView addSubview:titlelable];
        titlelable.text =@"文森特 ";
        titlelable.font = MYFont(14);
        titlelable.textColor = UIColorFromRGB(0x333333);
        self.titlelable = titlelable;
      
        UILabel * rightlable  = [[UILabel alloc]init];
        [self.contentView addSubview:rightlable];
//        rightlable.text =@"5 答";
        rightlable.font = MYFont(12);
        rightlable.textColor = UIColorFromRGB(0x999999);
        self.rightlable = rightlable;

        
        
    }
    return self;
}

-(void)setQuestModle:(MYRequestModle *)questModle
{
    _questModle = questModle;
    
     
    
    self.titlelable.text = questModle.title;
    
    
    if(questModle.anwserNumber==nil){
        
        self.rightlable.text = [NSString stringWithFormat:@"0答"];

    }else{
    self.rightlable.text = [NSString stringWithFormat:@"%@答",questModle.anwserNumber];
    }
    
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat withanwser = [self.rightlable.text widthWithFont:MYFont(13)];
    
    self.titlelable.frame = CGRectMake(kMargin, 0, MYScreenW - kMargin*3-withanwser, 50);
    
    self.rightlable.frame = CGRectMake(MYScreenW-withanwser-kMargin, 0, withanwser, 50);
    
    
}


@end
