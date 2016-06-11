//
//  RotateBtnView.m
//  jspatch
//
//  Created by tom on 16/4/5.
//  Copyright © 2016年 donler. All rights reserved.
//

#import "RXRotateButtonOverlayView.h"
#import "ImageAndTitleVerticalButton.h"
#import "UILabel+Extension.h"
#import "Masonry.h"
#import "UIButton+WebCache.h"
#import "UIButton+Extension.h"
#import "MYWeather.h"


static CGFloat btnWidth = 80.0f;
static CGFloat btnOffsetY = 85.0;

@interface RXRotateButtonOverlayView ()
@property (nonatomic, strong) UIDynamicAnimator* animator;
@property (nonatomic, strong) UIButton* mainBtn;
@property (nonatomic, strong) NSMutableArray* btns;
@property (nonatomic, strong) UITapGestureRecognizer* tap;

@property(strong,nonatomic) UIVisualEffectView * visualView;
@property(strong,nonatomic) UILabel * titlelable;

/** 天气模型 */
@property (strong, nonatomic) MYWeather *weatherModel;

@end

@implementation RXRotateButtonOverlayView

- (instancetype)initWithWeather:(MYWeather *)weatherModel
{
    if (self=[super init]) {
        
        self.weatherModel = weatherModel;
        
    }
    return self;
}
- (void)blur
{
    
        UIBlurEffect *effectView = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:effectView];
        visualView.alpha = 0.95;
        self.visualView = visualView;
        visualView.frame = self.bounds;
        
        [self addSubview:visualView];
    
//       [self insertSubview:visualView atIndex:0];
}

- (void)builtInterface
{
    [self removeGestureRecognizer:self.tap];
    [self addGestureRecognizer:self.tap];
    
    [self blur];
    [self setupTopViews];

    
    //setColor
    UILabel *titlelable = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 265, self.width, 30)];
    [self addSubview:titlelable];
    titlelable.text = @"你想发布什么内容";
    titlelable.textAlignment = NSTextAlignmentCenter;
    titlelable.textColor = [UIColor whiteColor];
    self.titlelable = titlelable;
    
    //clear dynamic behaviours
    [self.animator removeAllBehaviors];
    //clear btns
    [self.btns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.btns removeAllObjects];
    
    //add new Btns
    if (self.titles.count > 0) {
        for (NSString* title in self.titles) {
            UIView* v = nil;
            if (self.titleImages.count == self.titles.count) {
                NSUInteger index = [self.titles indexOfObject:title];
                v = [self addBtnWithTitle:title andTitleImage:[self.titleImages objectAtIndex:index]];
            }else{
                v = [self addBtnWithTitle:title];
            }
            
            [self.btns addObject:v];
        }
        [self addSubview:self.mainBtn];
    }
}
- (void)setupTopViews
{
    //截取时间段
    NSString *date = [NSString stringWithFormat:@"%@/%@",_weatherModel.weather.year,_weatherModel.weather.month];
    NSArray *windArr = [_weatherModel.weather.WS componentsSeparatedByString:@"("];
    
    
    //哪一天
    UILabel *dayLabel = [UILabel addLabelWithFrame:CGRectMake(MYValue(15), 40, MYValue(100), MYValue(100)) title:_weatherModel.weather.date titleColor:[UIColor whiteColor] font:MYFont(70)];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dayLabel];
    
    //星期几
    UILabel *weekLabel = [UILabel addLabelWithFrame:CGRectMake(dayLabel.right + kMargin, dayLabel.y + 15, 80, 25) title:_weatherModel.weather.week titleColor:[UIColor whiteColor] font:MYSFont(16)];
    [self addSubview:weekLabel];
    
    //日期
    UILabel *dateLabel = [UILabel addLabelWithFrame:CGRectMake(dayLabel.right + kMargin, weekLabel.bottom + 18, 80, 25) title:date titleColor:[UIColor whiteColor] font:MYSFont(16)];
    [self addSubview:dateLabel];
    
    
    //地点
    UILabel *detailLabel = [UILabel addLabelWithFrame:CGRectMake(dayLabel.x + 15, dayLabel.bottom - 5, 170, 25) title:[NSString stringWithFormat:@"%@: %@ %@℃ %@",_weatherModel.weather.city,_weatherModel.weather.weather,_weatherModel.weather.temp,windArr[0]]  titleColor:[UIColor whiteColor] font:MYSFont(16)];
    [self addSubview:detailLabel];
    
    
    //右边图像
    UIButton *imageBtn = [UIButton addSystemButtonWithFrame:CGRectMake(MYScreenW - MYValue(140), weekLabel.y  + 8 , MYValue(120), MYValue(120)) NormalBackgroundImageString:nil tapAction:^(UIButton *button) {
        
        if (self.picBlock) {
            self.visualView.hidden = YES;
            self.titlelable.hidden = YES;
            self.picBlock(_weatherModel.ad[0].url);
        }
        
    }];
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",kOuternet1,_weatherModel.ad[0].bannerPath];
    [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal];
    [self addSubview:imageBtn];
    
    
}



#pragma mark - public
//show the overlay
- (void)show
{

    [self builtInterface];
//    [self opacityAniamtionFrom:0.3 to:1.0];

    [UIView animateWithDuration:.3 animations:^{
        self.mainBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    }];
    
    NSInteger count = self.btns.count;
    CGFloat space = 0;
    space = ([UIScreen mainScreen].bounds.size.width - count * btnWidth ) / (count + 1 );
    [self.animator removeAllBehaviors];
    for (int i = 0; i< count; i++) {
        
        CGPoint buttonPoint=  CGPointMake((i + 1)* (space ) + (i+0.5) * btnWidth, [UIScreen mainScreen].bounds.size.height - btnOffsetY * 2);

        UISnapBehavior *sna = [[UISnapBehavior alloc]initWithItem:[self.btns objectAtIndex:i] snapToPoint:buttonPoint];
        sna.damping = 0.4;
        [self.animator addBehavior:sna];
    }
}

//dismiss the overlay
- (void)dismiss
{
//    [self opacityAniamtionFrom:1.0 to:0.1];

    
    [UIView animateWithDuration:.3 animations:^{
        
//        self.mainBtn.transform = CGAffineTransformMakeRotation(-M_PI_4);
        self.mainBtn.transform =CGAffineTransformIdentity;
    }];
    
    NSInteger count = self.btns.count;
    CGPoint point = self.mainBtn.center;
    [self.animator removeAllBehaviors];
    for (int i = 0; i< count; i++) {
        UIView* v = [self.btns objectAtIndex:i];
        [UIView animateWithDuration:.2 animations:^{
            [v setAlpha:0];
        }];
        UISnapBehavior *sna = [[UISnapBehavior alloc]initWithItem:v snapToPoint:point];
        sna.damping = .9;
        [self.animator addBehavior:sna];
        self.titlelable.hidden = YES;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.visualView removeFromSuperview];
        [self removeFromSuperview];
    });
}

#pragma mark - action

- (void)selectBtnAction:(UITapGestureRecognizer*)gesture
{
    UIButton* btn = (UIButton*)gesture.view;
    if ([self.delegate respondsToSelector:@selector(didSelected:)]) {
        [self.delegate didSelected:[self.titles indexOfObject:btn.titleLabel.text]];
        self.visualView.hidden = YES;
        self.titlelable.hidden = YES;
    }
}

- (void)clickedSelf:(id)sender
{
    [self dismiss];
}
- (void)btnClicked:(id)sender
{
    [self dismiss];
}

#pragma mark - private
- (UIView*)addBtnWithTitle:(NSString*)title andTitleImage:(NSString*)imageName
{
    ImageAndTitleVerticalButton *view = [[ImageAndTitleVerticalButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - btnWidth / 2.0, [UIScreen mainScreen].bounds.size.height - btnOffsetY, btnWidth, btnWidth)];
    view.titleLabel.textColor = [UIColor whiteColor];
    [view setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [view setTitle:title forState:UIControlStateNormal];
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view.titleLabel.textAlignment = NSTextAlignmentCenter;
    view.titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:view];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBtnAction:)]];
    return view;
}

- (UIView*)addBtnWithTitle:(NSString*)title
{
    UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - btnWidth / 2.0, [UIScreen mainScreen].bounds.size.height - btnOffsetY, btnWidth, btnWidth)];
    view.titleLabel.textColor = [UIColor whiteColor];
    view.backgroundColor = [UIColor yellowColor];
    [view setTitle:title forState:UIControlStateNormal];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = btnWidth / 2.0;
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view.titleLabel.textAlignment = NSTextAlignmentCenter;
    view.titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:view];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBtnAction:)]];
    return view;
}


#pragma mark - getter & setter
- (UITapGestureRecognizer *)tap
{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedSelf:)];
    }
    return _tap;
}

- (UIDynamicAnimator *)animator
{
    if (_animator == nil) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _animator;
}
- (UIButton *)mainBtn
{
    if (_mainBtn == nil) {
        _mainBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - btnWidth / 2.0, [UIScreen mainScreen].bounds.size.height - btnOffsetY, btnWidth, btnWidth)];
        [_mainBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_mainBtn.layer setCornerRadius:btnWidth / 2.0];
        UIImage* image = [UIImage imageNamed:@"post_animate_add"];
        [_mainBtn setImage:image forState:UIControlStateNormal];
    }
    return _mainBtn;
}

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (void)setTitles:(NSArray *)titles
{
    self.btns = [NSMutableArray array];
    _titles = [NSArray arrayWithArray:titles];
}

- (void)setTitleImages:(NSArray *)titleImages
{
    self.btns = [NSMutableArray array];
    _titleImages = [NSArray arrayWithArray:titleImages];
}
/**
 *  透明度动画
 */

-(void)opacityAniamtionFrom:(CGFloat)from to:(CGFloat)to{
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:from];
    anima.toValue = [NSNumber numberWithFloat:to];
    anima.duration = 0.8f;
    anima.removedOnCompletion=NO;
    anima.fillMode=kCAFillModeForwards;
    [self.layer addAnimation:anima forKey:@"opacityAniamtion"];
}
@end
