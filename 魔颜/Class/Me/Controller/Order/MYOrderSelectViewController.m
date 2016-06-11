//
//  MYOrderSelectViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/12.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYOrderSelectViewController.h"

@interface MYOrderSelectViewController ()

@property (strong, nonatomic) NSArray *titles;
@property (weak, nonatomic) UIButton *lastBtn;

@end

@implementation MYOrderSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单筛选";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [self setupMenu];
}

- (void)close
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupMenu
{
     CGFloat Margin = 15;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame =  CGRectMake(Margin, 5 * Margin, 4 * Margin, Margin);
    label.font = leftFont;
    label.textColor = titlecolor;
    label.text = @"订单类型";
    [self.view addSubview:label];
    
    self.titles = @[@"全部订单",@"产品订单",@"服务订单"];
    for (int i = 0; i < self.titles.count; i ++) {

        UIButton *btn = [[UIButton alloc] init];
        CGFloat btnW = (self.view.width - (self.titles.count + 1) * Margin) / self.titles.count;
        btn.frame =  CGRectMake(Margin + (btnW + Margin) * i, 6.5 * Margin, btnW, Margin * 1.4);
        
        btn.layer.borderColor = MYColor(193, 177, 122).CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        [btn setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:MYColor(193, 177, 122) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectStyle:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = leftFont;
        btn.tag = i;
        [self.view addSubview:btn];
//        if (btn.tag == 0) {
//            btn.selected = YES;
//            self.lastBtn = btn;
//            btn.layer.borderColor = MYColor(193, 177, 122).CGColor;
//        }
    }
 }

- (void)selectStyle:(UIButton *)btn
{
    
    if (btn.tag == 1) {
        btn.tag = 2;
    }else if (btn.tag == 2){
        btn.tag = 1;
    }
    self.lastBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.lastBtn.selected = NO;
    btn.selected = YES;
    btn.layer.borderColor = MYColor(193, 177, 122).CGColor;
    self.lastBtn = btn;
    
    if (self.myBlock) {
        self.myBlock((NSInteger)(btn.tag));
    }
    
     [self.navigationController popViewControllerAnimated:NO];
   

}


@end
