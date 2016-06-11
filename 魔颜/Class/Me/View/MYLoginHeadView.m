//
//  MYLoginHeadView.m
//  魔颜
//
//  Created by Meiyue on 15/10/21.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYLoginHeadView.h"
#import "MYHeader.h"

@interface MYLoginHeadView ()

@property (weak, nonatomic) UIButton *iconBtn;
@property (weak, nonatomic) UILabel *messageLabel;
@property(nonatomic,copy) NSString *phone;

@end

@implementation MYLoginHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupView];
    
    }
    return self;
}

-(void)setPhone:(NSString*)phone
{
    _phone = phone;
}

- (void)setupView
{
     NSData *data = [MYUserDefaults objectForKey:@"data"];
     UIImage *iconImage = [UIImage imageWithData:data];
     UIButton *iconBtn = [[UIButton alloc] init];
    
    if (iconImage) {
        
        [iconBtn setBackgroundImage:iconImage forState:UIControlStateNormal];
    }else
    {
        [iconBtn setBackgroundImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
        [iconBtn.imageView.image circleImage];

    }
    iconBtn.layer.borderColor = MYColor(193, 177, 122).CGColor;
    iconBtn.layer.borderWidth = 1.0;
    iconBtn.layer.masksToBounds = YES;
    iconBtn.layer.cornerRadius = 35;
    self.iconBtn = iconBtn;
    [iconBtn addTarget:self action:@selector(userBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:iconBtn];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = @"手机用户:475522";
    messageLabel.text = [MYUserDefaults objectForKey:@"name"];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = leftFont;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel = messageLabel;
    [self addSubview:messageLabel];
    
    [self layoutSubviews];
    
}

- (void)userBtn
{
    if ([self.delegate respondsToSelector:@selector(loginHeadView:)]){
        [self.delegate loginHeadView:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconBtn.center = self.center;
    self.iconBtn.size = CGSizeMake(70, 70);
    
//    self.iconBtn.frame = CGRectMake((MYScreenW - 70) / 2, self.height - 130, 70, 70);
    self.messageLabel.frame = CGRectMake(0, CGRectGetMaxY(self.iconBtn.frame) + 10, MYScreenW, 15);
    
}

@end
