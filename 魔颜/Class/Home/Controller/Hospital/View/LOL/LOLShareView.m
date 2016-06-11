//
//  LOLShareView.m
//  掌上英雄联盟
//
//  Created by 尚承教育 on 15/8/30.
//  Copyright (c) 2015年 尚承教育. All rights reserved.
//

#import "LOLShareView.h"
#import "LOLShareBtn.h"
#import "UMSocial.h"

#define Duration 0.3
#define MaxCols 3


@interface LOLShareView ()<UMSocialUIDelegate>

@property (strong, nonatomic) UIButton *coverBtn;
@property(weak, nonatomic) UIButton *cancelBtn;

@end

@implementation LOLShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self addShareBtnWithTitle:@"微信" imageName:@"share_logo_weixin" andShareObject:UMSocialSnsTypeWechatSession];
    [self addShareBtnWithTitle:@"朋友圈" imageName:@"share_logo_weixinFriends" andShareObject:UMSocialSnsTypeWechatTimeline];
//    [self addShareBtnWithTitle:@"QQ" imageName:@"share_logo_qq" andShareObject:UMSocialSnsTypeMobileQQ];
    
    return self;
}

- (void)clickCancelBtn
{
    [self stopShare];
    
}

- (LOLShareBtn *)addShareBtnWithTitle:(NSString *)title imageName:(NSString *)imageName andShareObject:(UMSocialSnsType)socialSnsType;
{
    LOLShareBtn *btn = [[LOLShareBtn alloc]init];
    btn.socalSnsType = socialSnsType;

    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)clickShareBtn:(LOLShareBtn *)shareBtn
{
    
    if ([self.delegate respondsToSelector:@selector(shareViewDidClickShareBtn:selBtn:)]) {
        [self.delegate shareViewDidClickShareBtn:self selBtn:shareBtn];
    }
    [self stopShare];
    
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据responseCode得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

/** 打开分享页面 */
- (void)startShareWithText:(NSString *)text image:(UIImage *)image
{
    self.shareImage = image;
    self.shareText = text;
    
    UIButton *coverBtn = [[UIButton alloc]init];
    self.coverBtn = coverBtn;
    coverBtn.backgroundColor = [UIColor blackColor];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    coverBtn.frame = window.bounds;
    coverBtn.alpha = 0;
    [coverBtn addTarget:self action:@selector(stopShare) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:coverBtn];
    
    [self layoutSubviews];
    self.frame = CGRectMake(0, window.height , window.width, self.height);
    [window addSubview:self];
    
    [UIView animateWithDuration:Duration animations:^{
        coverBtn.alpha = 0.5;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.transform = CGAffineTransformMakeTranslation(0, - self.height);
    }];
    
}

/** 取消分享页面*/
- (void)stopShare
{
    [UIView animateWithDuration:Duration animations:^{
        self.coverBtn.alpha = 0;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat Margin = 50;
    CGFloat btnW = (MYScreenW - Margin * (MaxCols + 1)) / MaxCols;
    CGFloat btnH = btnW;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    
    for (int i = 0; i < self.subviews.count; i++) {
        
        UIButton *btn = self.subviews[i];
        
        int col = i % MaxCols;
        int row = i / MaxCols;
        
        btnX = Margin + col * (Margin + btnW);
        btnY = Margin * 0.2 + row * (Margin + btnH);

        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        self.height = CGRectGetMaxY(btn.frame) + Margin-20;
    }
    
}


@end
