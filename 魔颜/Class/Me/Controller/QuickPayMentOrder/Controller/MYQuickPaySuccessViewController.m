//
//  MYQuickPaySuccessViewController.m
//  魔颜
//
//  Created by abc on 16/5/18.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYQuickPaySuccessViewController.h"
#import "MYOrderViewController.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYHeader.h"

@interface MYQuickPaySuccessViewController ()

@end

@implementation MYQuickPaySuccessViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];

     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backVC) image:@"back-1" highImage:@"back-1"];
    
    self.title = @"支付成功";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);

    UIImageView *headerimage = [[UIImageView alloc]initWithFrame:CGRectMake((MYScreenW-90)/2, 40+64, 90, 90)];
    headerimage.image = [UIImage imageNamed:@"zhifuchenggong"];
    [self.view addSubview:headerimage];
    
    
    UILabel *titlelable= [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(headerimage.frame)+40, MYScreenW-kMargin*3, 30)];
    titlelable.text = @"尊敬的客户:";
    titlelable.font = MYFont(16);
    titlelable.textColor = UIColorFromRGB(0x4d4d4d);
    [self.view addSubview:titlelable];
    
    UILabel *contenlable= [[UILabel alloc]init];
    contenlable.numberOfLines = 0;
    
    //0 是 下订单时注册的新用户  1 已注册用户
    if ([[MYUserDefaults objectForKey:@"ISLOGIN"] isEqualToString:@"0"])
    {
        contenlable.frame = CGRectMake(15, CGRectGetMaxY(titlelable.frame), MYScreenW-kMargin*3, 100);
        contenlable.text = @"您的订单已生成, 请您在 “个人中心——我的订单——付款”  中查看～\n您已完成快速购物并注册成功, 您的密码为手机后6位, 直接登录即可";
    }else {
        
        contenlable.frame = CGRectMake(15, CGRectGetMaxY(titlelable.frame), MYScreenW-kMargin*3, 60);
          contenlable.text = @"您的订单已生成, 请您在 “个人中心——我的订单——付款”  中查看～";
    }
    
    contenlable.font = MYFont(15);
    contenlable.textColor = UIColorFromRGB(0x808080);
    [contenlable setRowSpace:8];
    [contenlable setColumnSpace:1.5];
    [self.view addSubview:contenlable];
    
    
}

-(void)backVC
{

    for (UIViewController *controller in self.navigationController.viewControllers) {
        if([self.PayPath isEqualToString:@"1"]) // 订单中心的支付回跳
        {

            if ([controller isKindOfClass:[MYOrderViewController class]]) {

                [self.navigationController popToViewController:controller animated:YES];
            }

        }else{
            if ([controller isKindOfClass:[MYHomeHospitalDeatilViewController class]]) {

                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }

    
    
}

@end
