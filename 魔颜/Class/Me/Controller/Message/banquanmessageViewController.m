//
//  ViewController.m
//  魔颜
//
//  Created by abc on 15/11/30.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "banquanmessageViewController.h"

@interface banquanmessageViewController ()

@property(strong,nonatomic) UIButton * charabackbtn;
@end

@implementation banquanmessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.frame = self.view.bounds;
    imageview.image = [UIImage imageNamed:@"ver.jpg"];
    [self.view addSubview:imageview];

}


-(void)clickcharabackbtn
{
    [self.navigationController popViewControllerAnimated:YES];
    
    self.charabackbtn.hidden = YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
