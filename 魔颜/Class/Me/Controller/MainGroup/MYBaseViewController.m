//
//  WQTabBarController.h
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYBaseViewController.h"
#import "MYLoginViewController.h"

#import "MYBaseGroup.h"
#import "MYBaseItem.h"
#import "MYBaseCell.h"
#import "MYArrowItem.h"
#import "MYHeader.h"
#import "MYContentView.h"
#import "HWPopTool.h"

@interface MYBaseViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) NSMutableArray *groups;

@property(strong, nonatomic)NSString *kefuid;
@end

@implementation MYBaseViewController

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        
        _groups = [NSMutableArray array];
    }
    return _groups;
    
}

-(instancetype)init
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置tableView属性

    self.tableView.rowHeight = MYRowHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [MYNotificationCenter addObserver:self selector:@selector(login) name:@"LoginSuccess" object:nil];
    
}

- (void)login
{
    self.isLogin = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    MYBaseGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYBaseCell *cell = [MYBaseCell cellWithTableView:tableView];

    MYBaseGroup *group = self.groups[indexPath.section];
    
    cell.item = group.items[indexPath.row];
    
    
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中哪一行
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!deleate.isLogin) {
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
        [UIView animateWithDuration:0.5 animations:^{
            [MBProgressHUD showError:@"您还未登录，请先登录"];
            
        } completion:^(BOOL finished) {
            [MBProgressHUD hideHUD];
        }];
        
        [MBProgressHUD showError:@"您还未登录，请您先登录"];
        
        
    }else{
    
        // 1.取出这行对应的item模型
        MYBaseGroup *group = self.groups[indexPath.section];
        MYBaseItem *item = group.items[indexPath.row];
        
        // 2.判断有无需要跳转的控制器
        if (item.optional) {
            
            if (item.isLogin) {
                
            }
            item.optional();
        }else if (indexPath.section == 0 && indexPath.row == 1)
        {
            
            // 判断手机是否安装QQ
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
                NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=3308321066&version=1&src_type=web"];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                webView.delegate = self;
                [webView loadRequest:request];
                [self.view addSubview:webView];

                
            }else{
            
                MYContentView *contentView = [[MYContentView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
                
                [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeGradient;
                [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
                [[HWPopTool sharedInstance] showWithPresentView:contentView animated:YES];
                
                
            }
            
        }
        else if([item isKindOfClass:[MYArrowItem class]]) {
            
            MYArrowItem *arrowItem = (MYArrowItem *)item;
            
            UIViewController *destVC = [[arrowItem.destVC alloc]init];
            destVC.title = item.title;
            
            [self.navigationController pushViewController:destVC animated:YES];
            self.navigationController.navigationBarHidden = NO;
        }
        
        
    }
    
    }
     

@end
