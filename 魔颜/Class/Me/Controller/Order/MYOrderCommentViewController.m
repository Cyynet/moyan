//
//  MYOrderCommentViewController.m
//  魔颜
//
//  Created by Meiyue on 15/11/2.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "MYOrderCommentViewController.h"
#import "MYProductCell.h"
#import "MYTextView.h"
#import "LDXScore.h"
#import "UIButton+Extension.h"
#import "MYHeader.h"

@interface MYOrderCommentViewController ()<UITextViewDelegate,UIScrollViewDelegate>

@property(strong,nonatomic) MYTextView *textView;
@property (strong, nonatomic) MYProductCell *headView;

@property (nonatomic, assign) NSInteger num1;
@property (nonatomic, assign) NSInteger num2;
@property (nonatomic, assign) NSInteger num3;

@property (weak, nonatomic) UIButton *submitBtn;

@end

@implementation MYOrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self settingHeader];
    [self setupComment];
    [self setupScore];
    [self setupSubmit];
    
}

- (void)settingHeader
{
    MYProductCell *headView = [MYProductCell productCell];
    headView.frame = CGRectMake(0, 54, self.view.width, 130);
    headView.order = self.orderLists;
    headView.finishPayLabel.hidden = YES;
    headView.goToPayBtn.hidden = YES;
    headView.deleteOrder.hidden = YES;
    self.headView = headView;
    [self.view addSubview:headView];
 
}

- (void)setupComment
{
    //新帖的内容
    MYTextView *contenView = [[MYTextView alloc]initWithFrame:CGRectMake(kMargin, self.headView.bottom, MYScreenW - MYMargin,self.headView.height)];
    contenView.delegate = self;
    contenView.placeHoledr = @"请写下您的感受吧,会对其他人有很大帮助哦!";
    self.textView = contenView;
    self.textView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:contenView];
    
}

- (void)setupScore
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.textView.bottom, MYScreenW, 2)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    [self.view addSubview:lineView];
    
    UILabel *commentLabel = [UILabel addLabelWithFrame:CGRectMake(30, lineView.bottom + MYMargin, 150, 35) title:@"商户评分" titleColor:titlecolor font:ThemeFont];
    [self.view addSubview:commentLabel];
    
    
    NSArray *labelNames = @[@"效  果 :",@"环  境 :",@"服  务 :"];
    
    for (int i = 0; i < 3; i ++) {
        
        CGFloat labelY = commentLabel.bottom + i * 40 + 15;
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(30, labelY , 70, 25);
        label.text = [labelNames objectAtIndex:i];
        label.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0];
        [self.view addSubview:label];
        
        LDXScore *score = [[LDXScore alloc] init];
        score.tag = i;
        score.show_star = 5;
        score.frame = CGRectMake(label.right + kMargin, labelY, 200, 25);
        [score setNormalImg:[UIImage imageNamed:@"rating2"]];
        [score setHighlightImg:[UIImage imageNamed:@"rating1"]];
        score.scoreBlock = ^(NSInteger index,NSInteger num){
            
            if (index == 0) {
                self.num1 = num * 2;
            }else if (index == 1){
                self.num2 = num * 2;
            }else if (index == 2){
                self.num3 = num * 2;
            }
            
            NSLog(@"点击了第%ld个类型,选了%ld颗星",(long)index,(long)num);
        };
        [self.view addSubview:score];
    }
    
}

- (void)setupSubmit
{
    UIButton *btn = [UIButton addButtonWithFrame:CGRectMake(0, MYScreenH - 45, MYScreenW, 45) title:@"发表评价" backgroundColor:MYColor(193, 177, 122) titleColor:MYColor(255, 255, 255) font:ThemeFont Target:self action:@selector(submit)];
    self.submitBtn = btn;
    [self.view addSubview:btn];
 }

- (void)submit
{
    if (self.textView.text.length) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userid"] = [MYUserDefaults objectForKey:@"id"];
        params[@"orderid"] = self.headView.order.id;
        params[@"ordertitle"] = self.headView.order.title;
        params[@"comment"] = self.textView.text;
        params[@"recode"] = @(self.num1 ? self.num1 : 10);
        params[@"encode"] = @(self.num2 ? self.num2 : 10);
        params[@"secode"] = @(self.num3 ? self.num3 : 10);
        params[@"ver"] = MYVersion;
        
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@orderComment/addOrderComment",kOuternet1] params:params success:^(id responseObject) {
            
            if ( [[responseObject objectForKey:@"status"] isEqualToString:@"success"]){
                
//                [self.submitBtn setTitle:@"已评价" forState:UIControlStateNormal];
//                self.submitBtn.enabled = NO;
                if (self.commentBlock) {
                    self.commentBlock(1);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [MBProgressHUD showError:@"评论失败"];
            }
            
        } failure:^(NSError *error) {
            
        }];
      
    }else{
          [MBProgressHUD showError:@"请输入评价内容"];
     }
    
}
/**
 *  UITextView没有像UITextField中textFieldShouldReturn:这样的方法，那么要实现UITextView return键隐藏键盘，可以通过判断输入的字符是不是回车符来实现。
 */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self.textView resignFirstResponder];
    
}


@end
