
//
//  MYqianggouview.m
//  魔颜
//
//  Created by abc on 16/4/12.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYqianggouview.h"
#import "CZCountDownView.h"
#import "MYHeader.h"

@interface MYqianggouview ()
{
    
    NSMutableArray *_urltitle0;
    NSMutableArray *_imagetitle0;
    
    
    NSMutableArray *_urltitle1;
    NSMutableArray *_imagetitle1;
    NSMutableArray *_timearr1;
    
    NSMutableArray *_urltitle2;
    NSMutableArray *_imagetitle2;
    NSMutableArray *_surplus2;
}

@property(strong,nonatomic) UIButton * view1;
@property(strong,nonatomic) UIButton * view2;
@property(strong,nonatomic) UIButton * view3;
@property(strong,nonatomic) UIButton * view4;
@property(strong,nonatomic) UIButton * view5;

@end
@implementation MYqianggouview

-(instancetype)initWithFrame:(CGRect)frame imagearr:(NSArray *)imagearr imagcount:(NSInteger)count urlarr:(NSArray*)urlarr type:(NSArray *)type
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *view1 = [[UIButton alloc]init];
        [self addSubview:view1];
        view1.tag = 1;
        [view1 addTarget:self action:@selector(clickview1:) forControlEvents:UIControlEventTouchUpInside];
        self.view1 = view1;


        UIButton *view2 = [[UIButton alloc]init];
        [self addSubview:view2];
        view2.tag  = 2;
        [view2 addTarget:self action:@selector(clickview2:) forControlEvents:UIControlEventTouchUpInside];
        self.view2 = view2;
        
        UIButton *view3 = [[UIButton alloc]init];
        [self addSubview:view3];
        [view3 setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
        view3.tag = 3;
        [view3 addTarget:self action:@selector(clickview3:) forControlEvents:UIControlEventTouchUpInside];
        self.view3 = view3;
    
    
        if (count == 3) {
            view1.frame = CGRectMake(0, 0, MYScreenW/2-1, self.height);
            
            view2.frame = CGRectMake(MYScreenW-self.width/2, 0, MYScreenW-view1.width, self.height/2-1);
            
            view3.frame = CGRectMake(MYScreenW-self.width/2, self.height- self.height/2, MYScreenW-view1.width,self.height/2);
            
            
            }else{
            
        }
    }
    return self;
    
}
-(void)setModel:(NSArray *)model
{
    
    //    普通
    NSMutableArray *imagetitle0 = [NSMutableArray array];
    NSMutableArray *urltitle0 = [NSMutableArray array];
    
    
    //    倒计时
    NSMutableArray *imagetitle1 = [NSMutableArray array];
    NSMutableArray *urltitle1 = [NSMutableArray array];
    NSMutableArray *timearr1 = [NSMutableArray array];
    //    剩余量
    NSMutableArray *imagetitle2 = [NSMutableArray array];
    NSMutableArray *urltitle2 = [NSMutableArray array];
    NSMutableArray *surplus2 = [NSMutableArray array];
    
    
    for (NSDictionary *dict in model) {
        
        
        if ([dict[@"type"] isEqualToString:@"0"])
        {
            [imagetitle0 addObject:dict[@"bannerPath"]];
            [urltitle0 addObject:dict[@"url"]];
            
        }else if ([dict[@"type"] isEqualToString:@"1"])
        {
            [imagetitle1 addObject:dict[@"bannerPath"]];
            [urltitle1 addObject:dict[@"url"]];
            [timearr1 addObject:dict[@"time"]];
            
        }else
        {
            [imagetitle2 addObject:dict[@"bannerPath"]];
            [urltitle2 addObject:dict[@"url"]];
            [surplus2 addObject:dict[@"surplus"]];
        }
    }
    _imagetitle0 = imagetitle0;
    _urltitle0 = urltitle0;
    
    _imagetitle1 = imagetitle1;
    _urltitle1 = urltitle1;
    _timearr1 = timearr1;
    
    
    _imagetitle2 = imagetitle2;
    _urltitle2 = urltitle2;
    _surplus2 = surplus2;
    
    SDWebImageManager *imageManager = [[SDWebImageManager alloc]init];
    if (imagetitle1.count) {
        
        [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle1[0]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (error == nil) {
                
                [self.view1 setBackgroundImage:image forState:UIControlStateNormal];
                self.view1.tag = 1;//倒计时
                
            }
        }];
        
//        // 封装后
//        CZCountDownView *countDown = [CZCountDownView shareCountDown];
//        countDown.frame = CGRectMake(10, self.view1.height-40, self.view1.width-20, 30);
//        countDown.timestamp = 12010;
//        
//        countDown.backgroundImageName = @"search_k";
//        countDown.timerStopBlock = ^{
//            //            self.view1.selected = NO;
//            
//        };
//        [self.view1 addSubview:countDown];
        
        if (imagetitle2.count) {
            
            [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle2[0]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    
                    [self.view2 setBackgroundImage:image forState:UIControlStateNormal];
                    self.view2.tag = 2;//剩余量
                }
            }];
            
//            UILabel *surplus1 = [[UILabel alloc]initWithFrame:CGRectMake((self.view2.width-60)/2, 10, 60, 20)];
//            [self.view2 addSubview:surplus1];
//            surplus1.text = _surplus2[0];
//            surplus1.textColor = [UIColor redColor];
//            surplus1.backgroundColor = [UIColor clearColor];
            
            
            [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle0[0]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    
                    [self.view3 setBackgroundImage:image forState:UIControlStateNormal];
                    self.view3.tag = 0;
                }
            }];
            
            
        }else
        {
            [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle0[0]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    
                    [self.view2 setBackgroundImage:image forState:UIControlStateNormal];
                }
            }];
            [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle0[1]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    
                    [self.view3 setBackgroundImage:image forState:UIControlStateNormal];
                }
            }];
            
        }
        
        
    }
    else if(imagetitle2.count){
        
        [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle2[0]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (error == nil) {
                
                [self.view1 setBackgroundImage:image forState:UIControlStateNormal];
                self.view1.tag = 2;
            }
        }];
        
//        UILabel *surplus1 = [[UILabel alloc]initWithFrame:CGRectMake((self.view1.width-60)/2, 10, 60, 20)];
//        [self.view1 addSubview:surplus1];
//        surplus1.text = _surplus2[0];
//        surplus1.textColor = [UIColor redColor];
//        surplus1.backgroundColor = [UIColor grayColor];
        
        if (imagetitle2.count>1) {
            
            [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle2[1]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    
                    [self.view2 setBackgroundImage:image forState:UIControlStateNormal];
                    self.view2.tag = 2;
                }
            }];
            
//            UILabel *surplus2 = [[UILabel alloc]initWithFrame:CGRectMake((self.view1.width-60)/2, self.view1.height-30, 60, 20)];
//            [self.view2 addSubview:surplus2];
//            surplus2.text = _surplus2[1];
//            surplus2.textColor = [UIColor redColor];
//            surplus2.backgroundColor = [UIColor clearColor];
            
            if (imagetitle2.count >2) {
                [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle2[2]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    if (error == nil) {
                        
                        [self.view3 setBackgroundImage:image forState:UIControlStateNormal];
                        self.view3.tag = 2;
                    }
                }];
                
//                UILabel *surplus3 = [[UILabel alloc]initWithFrame:CGRectMake((self.view1.width-60)/2, 10, 60, 20)];
//                [self.view3 addSubview:surplus3];
//                surplus3.text = _surplus2[2];
//                surplus3.textColor = [UIColor redColor];
//                surplus3.backgroundColor = [UIColor grayColor];
            }else{
                [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle0[0]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    if (error == nil) {
                        
                        [self.view3 setBackgroundImage:image forState:UIControlStateNormal];
                        self.view3.tag = 0;
                    }
                }];
                
            }
            
        }else{
            [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle0[0]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    
                    [self.view2 setBackgroundImage:image forState:UIControlStateNormal];
                }
            }];
            [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle0[1]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    
                    [self.view3 setBackgroundImage:image forState:UIControlStateNormal];
                }
            }];
            
        }
        
    }
    else{
        [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle0[0]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (error == nil) {
                
                [self.view1 setBackgroundImage:image forState:UIControlStateNormal];
                self.view1.tag = 0;
            }
        }];
        [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle0[1]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (error == nil) {
                
                [self.view2 setBackgroundImage:image forState:UIControlStateNormal];
                self.view2.tag = 0;
            }
        }];
        [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,_imagetitle0[2]]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (error == nil) {
                
                [self.view3 setBackgroundImage:image forState:UIControlStateNormal];
                self.view3.tag = 0;
            }
        }];
        
        
    }
    
}

-(void)clickview1:(UIButton *)view1
{
    [MYNotificationCenter postNotificationName:@"qianggouVIEW" object:nil userInfo:@{@"tag":@"0",@"type":@(view1.tag)}];
}
-(void)clickview2:(UIButton *)view2
{
    [MYNotificationCenter postNotificationName:@"qianggouVIEW" object:nil userInfo:@{@"tag" :@"1",@"type":@(view2.tag)}];
}
-(void)clickview3:(UIButton *)view3
{
    [MYNotificationCenter postNotificationName:@"qianggouVIEW" object:nil userInfo:@{@"tag" : @"2",@"type":@(view3.tag)}];
}

@end
