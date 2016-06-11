//
//  MYTextView.m
//
//
//  Created by abc on 15/6/9.
//  Copyright (c) 2015年 sczy. All rights reserved.
//

#import "MYTextView.h"


@interface MYTextView()

@end

@implementation MYTextView

-(instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        
        // 总是能滚动
//        self.alwaysBounceVertical = YES;
        
        
        
        
        UILabel *placeLabel = [[UILabel alloc]init];
        placeLabel.numberOfLines = 0;
        placeLabel.textColor = [UIColor lightGrayColor];

        
        [self addSubview:placeLabel];
        self.placeLabel = placeLabel;
        
        self.font = [UIFont systemFontOfSize:13];
        

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

-(void)textChange
{
    if (self.text.length) {
        self.placeLabel.hidden = YES;
    }else{
          self.placeLabel.hidden = NO;
    }
    
//    self.placeLabel.hidden = self.text.length != 0;
    
}

// 外界改变textView的font会调用setFont，保持textView的font和placeLabel的font一致
-(void)setFont:(UIFont *)font
{
    // 重新给self.font赋值
    [super setFont:font];
    
    self.placeLabel.font = self.font;
    
    // 根据最新的文字的大小font,重新计算placelabel的size
    [self setNeedsLayout];
}

-(void)setPlaceHoledr:(NSString *)placeHoledr
{
    _placeHoledr = placeHoledr;
    
    self.placeLabel.text = placeHoledr;
    
    
      // 根据最新的文字多少重新计算placelabel的size
    [self setNeedsLayout];
}

-(void)setPlaceHoledrColor:(UIColor *)placeHoledrColor
{
    _placeHoledrColor = placeHoledrColor;
    
    self.placeLabel.textColor = placeHoledrColor;
}

//设置背景字体的frame
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeLabel.x = 5;
    self.placeLabel.y = 8;
    self.placeLabel.width = self.width;
    
    CGSize maxSize = CGSizeMake(self.placeLabel.width, MAXFLOAT);
    NSDictionary *dictText = @{NSFontAttributeName:self.placeLabel.font};
    CGSize size = [self.placeLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dictText context:nil].size;
    self.placeLabel.height = size.height;
}

//退出的时候调用 放弃接受通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}





@end
