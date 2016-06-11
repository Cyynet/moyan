//
//  MYTabBar.m
//  魔颜
//
//  Created by Meiyue on 16/4/9.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYTabBar.h"
#import "MYPublicBtn.h"
#import "MYNavigateViewController.h"
#import "MYFinishViewController.h"
#import "MYAskQuestionViewController.h"
#import "MYRandomChatPublicViewController.h"
#import "MYTabBarController.h"
#import "MYLoginViewController.h"
#import "MYHeader.h"
#import "pushView.h"
#import "RXRotateButtonOverlayView.h"
#import "MYHomeHospitalDeatilViewController.h"
#define iOS9 ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0)

@interface MYTabBar ()<RXRotateButtonOverlayViewDelegate>

/**<发布按钮*/
@property (nonatomic,weak) UIButton *publishButton;
@property (nonatomic, strong) RXRotateButtonOverlayView * overlayView;
@property (copy, nonatomic) NSString *urlStr;


@end

@implementation MYTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //设置背景图片
        self.backgroundImage = [UIImage imageNamed:@"juxing@2x(1)"];
        
        //添加+号按钮
        MYPublicBtn *publishButton = [MYPublicBtn buttonWithType:UIButtonTypeCustom];
        [publishButton setTitle:@"发布" forState:UIControlStateNormal];
        [publishButton setTitleColor:UIColorFromRGB(0x4c4c4c) forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"post_animate_add"] forState:UIControlStateNormal];
        //        [publishButton setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateHighlighted];
        [publishButton sizeToFit];
        publishButton.adjustsImageWhenHighlighted = NO;
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.publishButton = publishButton;
        
        [self addSubview:self.publishButton];
        
    }
    return self;
}

- (void)publishClick
{
    if (iOS9) {
        
        if (self.publicBlock) {
            self.publicBlock();
        }
    }else{
        
        
        MYTabBarController *tabVC = (MYTabBarController *)self.window.rootViewController;
        
        MYNavigateViewController *pushClassStance = (MYNavigateViewController *)tabVC.viewControllers[tabVC.selectedIndex];
        if (pushClassStance.viewControllers.count > 1) {
            return;
        }
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self.overlayView];
        [self.overlayView show];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置发布按钮位置
    self.publishButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.1);
    //    self.publishButton.width = 60;
    //    self.publishButton.height = 60;
    
    //设置索引
    int index = 0;
    
    CGFloat tabBarButtonW = self.frame.size.width / 5;
    CGFloat tabBarButtonH = self.frame.size.height;
    CGFloat tabBarButtonY = 0;
    
    //设置UITabBarButton的位置
    for (UIView *tabBarButton in self.subviews) {
        if([NSStringFromClass([tabBarButton class]) isEqualToString:@"UITabBarButton"])
        {
            //计算x的位置
            CGFloat tabBarButtonX = index * tabBarButtonW;
            
            if(index >=2)
            {
                tabBarButtonX += tabBarButtonW;
            }
            
            //设置系统自带的UITabBarButton的frame
            tabBarButton.frame = CGRectMake(tabBarButtonX, tabBarButtonY, tabBarButtonW, tabBarButtonH);
            
            index++;
        }
        if ([tabBarButton isKindOfClass:[UIImageView class]] && tabBarButton.bounds.size.height <= 1) {
            UIImageView *ima = (UIImageView *)tabBarButton;
            ima.hidden = YES;
        }
    }
    
}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *result = [super hitTest:point withEvent:event];
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.publishButton];
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.publishButton pointInside:newP withEvent:event]) {
            return self.publishButton;
        }else{
            //如果点不在发布按钮身上，直接让系统处理就可以了
            return result;
        } } else {
            //tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
            return result;
        }
}
- (RXRotateButtonOverlayView *)overlayView
{
    if (_overlayView == nil) {
        
         __weak __typeof(self) weakSelf = self;
        _overlayView = [[RXRotateButtonOverlayView alloc] initWithWeather:self.weatherModel];
        [_overlayView setTitles:@[@"随便聊聊",@"我要问"]];
        [_overlayView setTitleImages:@[@"post_animate_1",@"post_animate_2"]];
        [_overlayView setDelegate:self];
        [_overlayView setFrame:[UIScreen mainScreen].bounds];
        _overlayView.picBlock = ^(NSString *urlStr){
            
            weakSelf.urlStr = urlStr;
            [weakSelf push:@"MYHomeHospitalDeatilViewController" type:3];

        };
    }
    return _overlayView;
}
#pragma mark - RXRotateButtonOverlayViewDelegate
- (void)didSelected:(NSUInteger)index
{
    
    [_overlayView removeFromSuperview];
    
    if (!MYAppDelegate.isLogin) {
        
        [self push:@"MYLoginViewController" type:2];
        
    }else{
        
        if (index == 0){
            
            [self push:@"MYRandomChatPublicViewController" type:0];
        }else{
            
            [self push:@"MYAskQuestionViewController" type:1];
        }
    }
}
/**
 *  在此 万分感谢 技术交流群@小浣熊丢了干脆面的技术支持
 *
 *  @param params runtime好强大
 */
- (void)push:(NSString *)params type:(NSInteger )type
{
    NSString *class =params;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    
    Class newClass = objc_getClass(className);
    if (!newClass){
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        objc_registerClassPair(newClass);
    }
    
    
    if (type == 0) {
        
        MYRandomChatPublicViewController *instance = [[newClass alloc] init];
        MYTabBarController *tabVC = (MYTabBarController *)self.window.rootViewController;
        MYNavigateViewController *pushClassStance = (MYNavigateViewController *)tabVC.viewControllers[tabVC.selectedIndex];
        instance.hidesBottomBarWhenPushed = YES;
        [pushClassStance pushViewController:instance animated:YES];
        
    }else if(type == 3){
        
        [_overlayView removeFromSuperview];

        MYHomeHospitalDeatilViewController *instance = [[newClass alloc] init];
        MYTabBarController *tabVC = (MYTabBarController *)self.window.rootViewController;
        MYNavigateViewController *pushClassStance = (MYNavigateViewController *)tabVC.viewControllers[tabVC.selectedIndex];
        instance.imageName = self.weatherModel.ad[0].bannerPath;
        instance.url = self.urlStr;
        instance.tag = 2;
        instance.hidesBottomBarWhenPushed = YES;
        [pushClassStance pushViewController:instance animated:YES];
        
    }else {
        
        MYAskQuestionViewController *instance = [[newClass alloc] init];
        MYTabBarController *tabVC = (MYTabBarController *)self.window.rootViewController;
        MYNavigateViewController *pushClassStance = (MYNavigateViewController *)tabVC.viewControllers[tabVC.selectedIndex];
        instance.hidesBottomBarWhenPushed = YES;
        [pushClassStance pushViewController:instance animated:YES];
     
    }
    
}



@end
