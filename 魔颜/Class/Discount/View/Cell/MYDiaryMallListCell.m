//
//  MYDiaryMallListCell.m
//  魔颜
//
//  Created by abc on 16/2/19.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYDiaryMallListCell.h"
#import "MYHeader.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define leftmagin 10

@implementation MYDiaryMallListCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 30) / 2, (SCREEN_WIDTH - 30) / 2);
        [self.imageView setUserInteractionEnabled:true];
        [self addSubview:self.imageView];
        
        self.smallimage = [[UIImageView alloc]init];
        [self.imageView setUserInteractionEnabled:true];
        self.smallimage.frame= CGRectMake(leftmagin, self.imageView.height+5, 9, 9);
        self.smallimage.layer.masksToBounds = YES;
        self.smallimage.layer.cornerRadius = 4.5;
        [self addSubview:self.smallimage];
        self.smallimage.image = [UIImage imageNamed:@"8"];
        
        
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.frame =CGRectMake(self.smallimage.width +leftmagin+5 ,self.smallimage.y ,self.width-self.smallimage.width,  9);
        [self addSubview:self.descLabel];
        self.descLabel.text = @"美国直供 正品保证";
        self.descLabel.font =  [UIFont systemFontOfSize:10];
        self.descLabel.textColor = subTitleColor;
        
        
        self.namelable = [[UILabel alloc] init];
        self.namelable.frame =CGRectMake(leftmagin ,CGRectGetMaxY(self.descLabel.frame) +4,(MYScreenW -15)/2-leftmagin-5,  13);
        [self addSubview:self.namelable];
        self.namelable.text = @"破尿酸套餐-润百颜";
        self.namelable.font =  leftFont;
        self.namelable.textColor = titlecolor;
        
        
    
        
        

        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(void)setDiarymodle:(MYHomeStoreDiaryModle *)diarymodle
{
    _diarymodle = diarymodle;
 
    self.pricelable.text = nil;
    self.allpricelable.text = nil;
    
    
    self.pricelable = [[UILabel alloc] init];
    [self addSubview:self.pricelable];
    self.pricelable.text = @"¥660";
    self.pricelable.font =  leftFont;
    self.pricelable.textColor = UIColorFromRGB(0xed0381);
    self.pricelable.text = [NSString stringWithFormat:@"¥%@",diarymodle.discountPrice];
    self.pricelable.frame =CGRectMake(leftmagin ,CGRectGetMaxY(self.namelable.frame)+2 ,self.width/2,  13);
  
    
    
    
    
    self.allpricelable = [[UILabel alloc] init];
    [self addSubview:self.allpricelable];
    NSString *oldPrice = @"¥12345";
    self.allpricelable.text = oldPrice;
    self.allpricelable.font =  [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
    self.allpricelable.textColor = [UIColor lightGrayColor];
    self.allpricelable.text = [NSString stringWithFormat:@"¥%@",diarymodle.price];

    //计算self.pricelable的长度；
    NSDictionary *dict1 = @{NSFontAttributeName:leftFont};
    CGSize  lableSize1 = [self.pricelable.text sizeWithAttributes:dict1];
    self.allpricelable.frame =CGRectMake(lableSize1.width+leftmagin*2 ,CGRectGetMaxY(self.namelable.frame)+3 ,self.width/2,  13);

    //    画删除线
    NSUInteger length = [self.allpricelable.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.allpricelable.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, length)];
    [self.allpricelable setAttributedText:attri];
      
   

    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,diarymodle.listPic]] ];
    [self.smallimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,diarymodle.countryPic]]];
    
    self.namelable.text = diarymodle.TITLE;
    self.descLabel.text  = diarymodle.countryTitel;
    
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
   
    
   
    
    
}


@end
