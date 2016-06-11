//
//  pushView.m
//  animationOne
//
//  Created by 战明 on 16/5/15.
//  Copyright © 2016年 zhanming. All rights reserved.
//

#import "pushView.h"
#import "pushButton.h"
#import "MYHeader.h"
#import "UIButton+WebCache.h"
#import "HWPopTool.h"
#import "MYLoginViewController.h"
#import "MYTabBarController.h"
#import "MYNavigateViewController.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
typedef NS_ENUM(NSInteger, ZMButtonType) {
    ZMButtonTypeCamera = 0,
    ZMButtonTypePicture,
    ZMButtonTypeResell
     
};
@interface pushView()

@property(assign,nonatomic)BOOL isAnimation;
@property(strong,nonatomic)UIVisualEffectView *myblurEffect;
@property(strong,nonatomic)UIWindow *keyWindow;
@property(strong,nonatomic)NSMutableArray<pushButton*> *btnArray;
@property (strong, nonatomic) NSMutableArray *titlesArr;
@property(strong,nonatomic)NSMutableArray *btnRectArray;
@property(strong,nonatomic)NSMutableArray *fromRectArray;
@property(strong,nonatomic)UIButton *addBtn;

/**
 *  天气情况
 */
/** 日期 */
@property (weak, nonatomic) UILabel *dayLabel;
/** 周几 */
@property (weak, nonatomic) UILabel *weekLabel;
/** 日期 */
@property (weak, nonatomic) UILabel *dateLabel;
/** 地点 */
@property (weak, nonatomic) UILabel *detailLabel;
/** 右边图片 */
@property (weak, nonatomic) UIButton *imageBtn;
/** 标题 */
@property (weak, nonatomic) UILabel *titleLable;
@end

@implementation pushView


-(NSMutableArray *)fromRectArray
{
    if(_fromRectArray == nil)
    {
        _fromRectArray=[NSMutableArray new];
        
    }
    return _fromRectArray;
}

-(NSMutableArray *)titlesArr
{
    if(_titlesArr == nil)
    {
        _titlesArr=[NSMutableArray new];
        
    }
    return _titlesArr;
}

-(NSMutableArray<pushButton *> *)btnArray
{
    if(_btnArray == nil)
    {
        _btnArray=[NSMutableArray new];
        
    }
    return _btnArray;
}

-(NSMutableArray *)btnRectArray
{
    if(_btnRectArray == nil)
    {
        _btnRectArray=[NSMutableArray new];
        
    }
    return _btnRectArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame=CGRectMake(0, 0, ScreenWidth,ScreenHeight);
        self.isAnimation = NO;
        self.userInteractionEnabled = YES;
        self.backgroundColor=[UIColor clearColor];
        
        self.myblurEffect = [UIView effectViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//        self.myblurEffect.alpha = 0.95f;
        [self addSubview:self.myblurEffect];
        
        
        
        //添加加号按钮
        UIButton *addbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [addbtn setBackgroundImage:[UIImage imageNamed:@"post_animate_add"] forState:UIControlStateNormal];
        
        addbtn.frame=CGRectMake(0, 0, 60, 60);
        
        addbtn.center=CGPointMake(ScreenWidth/2, ScreenHeight-44);
        
        [addbtn addTarget:self action:@selector(closePushView) forControlEvents:UIControlEventTouchUpInside];
        
        self.addBtn=addbtn;
        [self addButton];
        [self addSubview:addbtn];
        
        
        //创建顶部控件
        [self setupTopViews];
        
        
    }
    return self;
}

//创建按钮
-(void)addButton
{
    NSUInteger buttonCount=2;
    
    for (NSUInteger i=0; i<buttonCount; i++) {
        
        
        pushButton *btn=[pushButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(blick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag=i;
        
        //使按钮的frame和加号按钮的frame一样
        btn.frame=CGRectMake(0, 0, self.addBtn.frame.size.width, self.addBtn.frame.size.width);
        btn.center=self.addBtn.center;
        
        
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"post_animate_%lu",(unsigned long)(i+1)]] forState:UIControlStateNormal];
        
        //把按钮放到数组里，以便时候使用
        [self.btnArray addObject:btn];
        
        [self addSubview:btn];
        
        NSArray *titleArr = @[@"随便聊聊",@"我要问"];
        CGFloat margin = 60;
        CGFloat width=(ScreenWidth-margin*3)/2.0;
        CGRect toValue =CGRectMake(margin*(i+1)+width*i, ScreenHeight*0.85, width, 20);
        UILabel *label = [UILabel addLabelWithFrame:toValue title:titleArr[i] titleColor:[UIColor whiteColor] font:MYSFont(16)];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.titlesArr addObject:label];
        
        
    }
    UILabel *titleLabel = [UILabel addLabelWithFrame:CGRectMake(0, self.height - 256, self.width, 30) title:@"你想发布什么内容" titleColor:[UIColor whiteColor] font:MYSFont(16)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLable = titleLabel;
    
}

-(void)blick:(UIButton *)btn
{
    self.isAnimation = YES;
    [self closePushView];
    
    if (!MYAppDelegate.isLogin) {
        
        NSString *class = @"MYLoginViewController";
        const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
        
        Class newClass = objc_getClass(className);
        if (!newClass){
            Class superClass = [NSObject class];
            newClass = objc_allocateClassPair(superClass, className, 0);
            objc_registerClassPair(newClass);
        }
        MYLoginViewController *instance = [[newClass alloc] init];
        MYTabBarController *tabVC = (MYTabBarController *)self.window.rootViewController;
        MYNavigateViewController *pushClassStance = (MYNavigateViewController *)tabVC.viewControllers[tabVC.selectedIndex];
        instance.hidesBottomBarWhenPushed = YES;
        [pushClassStance pushViewController:instance animated:YES];
        
    }else{
    
        if (self.pushBlock) {
            self.pushBlock(btn.tag,nil);
        }
    }

    
    
    
    
//    switch (btn.tag) {
//        case ZMButtonTypeCamera:
//            NSLog(@"相机");
//            break;
//            
//        case ZMButtonTypePicture:
//            NSLog(@"图片");
//            break;
//        case ZMButtonTypeResell:
//            NSLog(@"一键转卖");
//            break;
//        default:
//            break;
//    }
}

//按钮出现
-(void)pushButton
{
    if(!self.isAnimation)
    {
        self.isAnimation=YES;
        
        self.dayLabel.hidden = NO;
        self.imageBtn.hidden = NO;
        self.weekLabel.hidden = NO;
        self.dateLabel.hidden = NO;
        self.detailLabel.hidden = NO;
        self.titleLable.hidden = NO;
        
        CGFloat margin = 60;
        CGFloat width=(ScreenWidth-margin*3)/2.0;
        
        [UIView animateWithDuration:0.3 animations:^{
            //透明度不断增大
            [self opacityAniamtion];
            //这个是让加号旋转45度，没有难度吧
            self.addBtn.transform = CGAffineTransformMakeRotation(-M_PI_4);

            
        } completion:^(BOOL finished) {
            
            for (UILabel *label in self.titlesArr) {
                label.hidden = NO;
            }

            
            for (NSInteger i = 0; i < self.btnArray.count; i++) {
                
                //按钮要到的位置的frame
                CGRect toValue =CGRectMake(margin*(i+1)+width*i+width/2, ScreenHeight*0.7+width/2, width, width);
                
                [self.fromRectArray addObject:[NSValue valueWithCGRect:toValue]];
                pushButton *menuButton = self.btnArray[i];
                
                //从小到大
                CABasicAnimation *animationScale=[CABasicAnimation animation];
                animationScale.keyPath=@"transform.scale";
                animationScale.fromValue= @(1.0);
                animationScale.byValue= @(1.1);
                animationScale.toValue= @(1.2);
                //按钮有旋转
                CABasicAnimation *animationRotation=[CABasicAnimation animation];
                animationRotation.keyPath=@"transform.rotation.z";
                
                //根据按钮的出现顺序旋转的角度也不同
                //            animationRotation.fromValue=@(DEGREES_TO_RADIANS(90/(self.btnArray.count-i)));
                animationRotation.fromValue=@(DEGREES_TO_RADIANS(15));
                animationRotation.toValue=@(0);
                //有弹性效果
                
                /*
                 * mass:
                 质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
                 * stiffness:
                 刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
                 
                 * damping:
                 阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
                 
                 * initialVelocity:
                 初始速率，动画视图的初始速度大小
                 速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
                 */
                
                CASpringAnimation *animationSpring=[CASpringAnimation animationWithKeyPath:@"position"];
                animationSpring.damping = 8;
                animationSpring.stiffness = 150;
                animationSpring.mass = 0.6;
                animationSpring.initialVelocity = 15;
                animationSpring.toValue =[NSValue valueWithCGPoint:toValue.origin];
                
                
                CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
                
                animationGroup.animations=@[animationScale,animationRotation,animationSpring];
                animationGroup.duration= 0.5;
                //让动画延迟执行
                animationGroup.beginTime=CACurrentMediaTime()+i*(0.4/self.btnArray.count);
                
                animationGroup.removedOnCompletion=NO;
                
                animationGroup.fillMode=kCAFillModeForwards;
                animationGroup.delegate=self;
                
                [menuButton.layer addAnimation:animationGroup forKey:[NSString stringWithFormat:@"animation%ld",(long)i]];
                
            }
            
        }];
        
    }
    
    else
    {
        [self closePushView];
    }
    
}

-(void)closePushView
{
    
    if(self.isAnimation)
    {
        
        self.dayLabel.hidden = YES;
        self.imageBtn.hidden = YES;
        self.weekLabel.hidden = YES;
        self.dateLabel.hidden = YES;
        self.detailLabel.hidden = YES;
        self.titleLable.hidden = YES;
        
        [self.myblurEffect.layer removeAllAnimations];
        self.myblurEffect.alpha = 0;
        self.isAnimation=NO;
        for (UILabel *label in self.titlesArr) {
            label.hidden = YES;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
             self.addBtn.transform = CGAffineTransformIdentity;
        }];
        
        for (NSInteger i = self.btnArray.count-1; i >=0; i--) {
            
            pushButton *menuButton = self.btnArray[i];
            
            CABasicAnimation *animationScale=[CABasicAnimation animation];
            
            animationScale.keyPath=@"transform.scale";
            animationScale.toValue=@(0.7);
            
            CABasicAnimation *animationRotation=[CABasicAnimation animation];
            
            animationRotation.keyPath=@"transform.rotation.z";
            
            //animationRotation.fromValue=@(0);
            animationRotation.toValue=@(DEGREES_TO_RADIANS(90/(self.btnArray.count-i)));
            
            CABasicAnimation *animationPosition=[CABasicAnimation animationWithKeyPath:@"position"];
            
            animationPosition.toValue =[NSValue valueWithCGPoint:self.addBtn.center];
            CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
            
            animationGroup.animations=@[animationPosition,animationScale];
            
            animationGroup.duration=0.23;
            
            animationGroup.beginTime=CACurrentMediaTime()+(self.btnArray.count-1-i)*(0.4/self.btnArray.count);
            
            animationGroup.removedOnCompletion=NO;
            
            animationGroup.fillMode=kCAFillModeForwards;
            if(i==0)
            {
                animationGroup.delegate=self;
            }
            
            
            [menuButton.layer addAnimation:animationGroup forKey:[NSString stringWithFormat:@"animationaClose%ld",(long)i]];
            
        }
     
        //透明度不断减小
        CABasicAnimation *animationoPacity=[CABasicAnimation animation];
        animationoPacity.keyPath=@"opacity";
        animationoPacity.fromValue=@(1.0);
        animationoPacity.toValue=@(0);
        animationoPacity.duration = 0.23;
        [self.myblurEffect.layer addAnimation:animationoPacity forKey:@"opacity"];

    }
    else
    {
        [self pushButton];
    }
    
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //临时方法，以后会修改
    
    pushButton *menuButton1 = self.btnArray[1];
    if([anim isEqual:[menuButton1.layer animationForKey:@"animation1"]])
    {
        
        menuButton1.center=[self.fromRectArray[1] CGRectValue].origin;
    }
    pushButton *menuButton0 = self.btnArray[0];
    if([anim isEqual:[menuButton0.layer animationForKey:@"animation0"]])
    {
        
        menuButton0.center=[self.fromRectArray[0] CGRectValue].origin;
    }
    
    
//    pushButton *menuButton2 = self.btnArray[2];
//    if([anim isEqual:[menuButton2.layer animationForKey:@"animation2"]])
//    {
//        menuButton2.center=[self.fromRectArray[2] CGRectValue].origin;
//    }
    
    if([anim isEqual:[menuButton0.layer animationForKey:@"animationaClose0"]])
    {
          [self removeFromSuperview];
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.isAnimation = YES;
    [self closePushView];
}

- (void)setupTopViews
{
    
    //哪一天
    UILabel *dayLabel = [UILabel addLabelWithFrame:CGRectMake(MYValue(20), 40, MYValue(100), MYValue(100)) title:nil titleColor:[UIColor whiteColor] font:MYFont(70)];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel = dayLabel;
    [self addSubview:dayLabel];
    
    //星期几
    UILabel *weekLabel = [UILabel addLabelWithFrame:CGRectMake(_dayLabel.right + MYValue(10), _dayLabel.y + 15, 80, 25) title:nil titleColor:[UIColor whiteColor] font:MYSFont(16)];
    self.weekLabel = weekLabel;
    [self addSubview:weekLabel];
    
    //日期
    UILabel *dateLabel = [UILabel addLabelWithFrame:CGRectMake(_dayLabel.right + MYValue(10), _weekLabel.bottom + 18, 80, 25) title:nil titleColor:[UIColor whiteColor] font:MYSFont(16)];
    self.dateLabel = dateLabel;
    [self addSubview:dateLabel];
    
    
    //地点
    UILabel *detailLabel = [UILabel addLabelWithFrame:CGRectMake(_dayLabel.x + MYValue(10), _dayLabel.bottom - 5, MYValue(170), 25) title:nil  titleColor:[UIColor whiteColor] font:MYSFont(16)];
    self.detailLabel = detailLabel;
    [self addSubview:detailLabel];
    
    
    //右边图像
    UIButton *imageBtn = [UIButton addSystemButtonWithFrame:CGRectMake(MYScreenW - MYValue(140), weekLabel.y  + 8 , MYValue(120), MYValue(120)) NormalBackgroundImageString:nil tapAction:^(UIButton *button) {
        
        self.isAnimation = YES;
        [self closePushView];
        if (self.pushBlock) {
            self.pushBlock(2,_weatherModel.ad[0].url);
        }
        
    }];
    self.imageBtn = imageBtn;
    [self addSubview:imageBtn];
    
}

- (void)setWeatherModel:(MYWeather *)weatherModel
{
    _weatherModel = weatherModel;
    
    self.dayLabel.text = weatherModel.weather.date;
    
    self.weekLabel.text = weatherModel.weather.week;
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@/%@",weatherModel.weather.year,weatherModel.weather.month];
    
    NSArray *windArr = [_weatherModel.weather.WS componentsSeparatedByString:@"("];
    self.detailLabel.text = [NSString stringWithFormat:@"%@: %@ %@℃ %@",weatherModel.weather.city,weatherModel.weather.weather,weatherModel.weather.temp,windArr[0]];
    
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",kOuternet1,weatherModel.ad[0].bannerPath];
    [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal];


}

//
/**
 *  背景色变化动画
 */
-(void)backgroundAnimation{
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anima.toValue =(id) [UIColor greenColor].CGColor;
    anima.duration = 1.0f;
    anima.removedOnCompletion= NO;
    anima.fillMode=kCAFillModeForwards;
    [self.layer addAnimation:anima forKey:@"backgroundAnimation"];
}

/**
 *  透明度动画
 */
-(void)opacityAniamtion{
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:0.1f];
    anima.toValue = [NSNumber numberWithFloat:1.0f];
    anima.duration = 0.3f;
    anima.removedOnCompletion = NO;
    anima.fillMode=kCAFillModeForwards;
    [self.myblurEffect.layer addAnimation:anima forKey:@"opacityAniamtion"];
}
/**
 *  逐渐消失
 */
-(void)fadeAnimation{

    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionFade;//设置动画的类型
    anima.subtype = kCATransitionFromBottom; //设置动画的方向
//    anima.startProgress = 0.3;//设置动画起点
//    anima.endProgress = 0.8;//设置动画终点
    anima.duration = 0.5f;
    [self.myblurEffect.layer addAnimation:anima forKey:@"fadeAnimation"];
}



@end
