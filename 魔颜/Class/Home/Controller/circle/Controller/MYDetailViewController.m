//
//  MYDetailViewController.m
//  魔颜
//
//  Created by admin on 16/1/21.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYDetailViewController.h"
#import "MYTieziModel.h"
#import "MYCircleComment.h"
#import "MYCommentCell.h"
#import "MYCircleCommentHeadView.h"
#import "MYCircleBtn.h"
#import "MYTextView.h"
#import "MYTieziModel.h"

#import "MYDiscountListModel.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "UILabel+Extension.h"
#import "UIButton+Extension.h"
#import "MYLoginViewController.h"
#import "MobClick.h"
#import "MYHeader.h"
#import "DMHeartFlyView.h"
#import "SHTextView.h"

#define headWebHeight 80.0f
#define interval 10.0f

@interface MYDetailViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

/** 导航条的背景view */
@property (nonatomic, strong) UIView  *navView;
/** 返回按钮 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;

@property (weak, nonatomic) UIWebView *webView;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, assign) CGRect imgRect;
@property (nonatomic, assign) CGFloat previousY;
/**点赞小图片数组*/
@property (strong, nonatomic) NSMutableArray *picArr;
/**评论数组*/
@property (strong, nonatomic) NSArray *circleArr;

@property (strong, nonatomic) UITableView *circleTableView;

/**图片*/
@property (copy, nonatomic) NSString *pic;

@property (strong, nonatomic) SHTextView *textView;
@property (nonatomic, strong) UITapGestureRecognizer* tap;

@property (weak, nonatomic) UIView  *commentView;

@property (weak, nonatomic) UIButton *commentBtn;

@property (copy, nonatomic) NSString *focus;
@property(assign,nonatomic) int  praiseStatus;    //点赞状态
@property(assign,nonatomic) int  focusStauts;    //收藏

@property(weak,nonatomic) UIButton * praiseBtn;
@property(strong,nonatomic) MYCircleBtn * sendBtn;

/** 帖子模型 */
@property (strong, nonatomic)  MYTieziModel *tieZiModel;
@end

//顶部scrollHeadView 的高度,先给写死
static const CGFloat ScrollHeadViewHeight = 210;

@implementation MYDetailViewController

//- (UITapGestureRecognizer *)tap
//{
//    if (_tap == nil) {
//        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedSelf:)];
//        [self.view addGestureRecognizer:_tap];
//    }
//    return _tap;
//}

- (NSMutableArray *)picArr
{
    if (!_picArr) {
        _picArr = [NSMutableArray array];
    }
    return _picArr;
}

- (NSArray *)circleArr
{
    if (!_circleArr) {
        _circleArr = [NSArray array];
    }
    return _circleArr;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"帖子详情"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"帖子详情"];
    
    //隐藏系统的导航条，由于需要自定义的动画，自定义一个view来代替导航条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化界面
    [self setUI];
    
    //初始化导航条上的内容
    [self setUpNavigtionBar];
    
    [self loadDetailHeadData];
    [self loadDetailBodyData];
    
}

- (void)setUI
{
    //将view的自动添加scroll的内容偏移关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark - ************* 添加tableView ************
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView.sectionFooterHeight = 0;
    self.circleTableView = tableView;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -110, MYScreenW, ScrollHeadViewHeight)];

    
    self.imgRect = imgView.frame;
    self.imgView  = imgView;
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.masksToBounds = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,self.topPic]]];
  

    [self.circleTableView insertSubview:imgView atIndex:0];
    self.previousY = -imgView.size.height;
    self.circleTableView.contentInset = UIEdgeInsetsMake(imgView.height, 0, 0, 0);
    
    UIWebView *webview = [[UIWebView alloc]init];
    webview.delegate = self;
    webview.scrollView.scrollEnabled = NO;
    self.webView = webview;
    webview.frame = CGRectMake(0, 0, MYScreenW, MYScreenH);
    [self.circleTableView setTableHeaderView:self.webView];
    

    
    /** 添加底部控件 */
    [self setupBoomView];
    
}

//初始化导航条上的内容
- (void)setUpNavigtionBar
{
    //初始化山寨导航条
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, 64)];
    self.navView.backgroundColor = [UIColor whiteColor];
    self.navView.alpha = 0.0;
    [self.view addSubview:self.navView];
    
    //添加返回按钮
    UIImageView *imageView = [UIImageView addImaViewWithFrame:CGRectMake(15, 32, 12, 18) imageName:@"back-1"];
    [self.view addSubview:imageView];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(kMargin, MYMargin, 40, 40);
    [self.backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
}
//返回上个控制器
- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  请求数据
 */
- (void)loadDetailHeadData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.circleTableView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.color = [UIColor clearColor];
    hud.alpha = 0.8;
    hud.yOffset = -160;
    hud.activityIndicatorColor = UIColorFromRGB(0xbcaa7c);
   
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.id;
    param[@"ver"] = MYVersion;
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/queryDiary",kOuternet1] params:param success:^(id responseObject) {
 
        [hud hide:YES];
        MYGlobalGCD((^{
            
            self.praiseStatus = [responseObject[@"diaryList"][@"praiseStatus"] intValue];
            if (self.praiseStatus) {
                self.praiseBtn.selected = YES;
            }
            
            /**
             *  文章文字和标题
             */
            self.tieZiModel = [MYTieziModel objectWithKeyValues:responseObject[@"diaryList"][@"diary"]];
            //     self.content = responseObject[@"diaryList"][@"diary"][@"content"];
            
            /**
             *  文章文字
             */
            self.pic = responseObject[@"diaryList"][@"diary"][@"pic"];
            
            /**
             *  帖子收藏
             */
            self.focusStauts = [responseObject[@"diaryList"][@"focusStatus"] intValue];
            
            if (self.focusStauts) {
                self.focus = @"已收藏";
            }else{
                self.focus = @"收藏";
            }
            
            MYMainGCD((^{
                
                if (NULLString(self.topPic)) {
                    
                    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,self.tieZiModel.homePagePic]]];
                }
                
                
                 [self showInWebView];
            }));
            
        }));
    } failure:^(NSError *error) {
        
        hud.hidden = YES;
        
    }];
    
}
- (void)loadDetailBodyData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.id;
    param[@"ver"] = MYVersion;
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/queryDiary",kOuternet1] params:param success:^(id responseObject) {
        
        MYGlobalGCD((^{

            /**
             *  点赞状态
             */
            self.praiseStatus = [responseObject[@"diaryList"][@"praiseStatus"] intValue];
            
            /**
             *  帖子评论回复数据
             */
            self.circleArr  = [MYCircleComment objectArrayWithKeyValuesArray:responseObject[@"diaryList"][@"diaryCommentsList"]];
            
            MYMainGCD(^{
                
                [self.circleTableView reloadData];
                if (self.praiseStatus == 0) {
                    [_praiseBtn setImage:[UIImage imageNamed:@"prase_normal"] forState:UIControlStateNormal];
                }else{
                    [_praiseBtn setImage:[UIImage imageNamed:@"prase_press"] forState:UIControlStateNormal];
                }

                
            });
        
                }));
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - *********** 拼接html语言
- (void)showInWebView
{
    NSString *html = [NSString stringWithFormat:@"<html><head><meta name = 'format-detection' content = 'telephone=no'><link rel=\"stylesheet\" href=\"%@\"></head><body>%@</body></html>",[[NSBundle mainBundle] URLForResource:@"MYDetails.css" withExtension:nil],[self touchBody]];
    
    [self.webView loadHTMLString:html baseURL:nil];
    
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"eye@2x.png" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePath];

    
    [body appendFormat:@"<div class=\"user\">"
     "<div class=\"user_left\">"
     "<img src=\"%@%@\">  <p>%@</p>"
     "</div>"
     
     "<div class=\"user_right\">"
     "<div class=\"user_rightMiddle\">"
     "<img src=\"%@\"> "
     "<p>%@</p>"
      "</div>"
     "<span id='focus' onclick='guanzhu()'>%@</span>"
     "</div>"
     "</div>",
     kOuternet1,self.tieZiModel.userPic,self.tieZiModel.userName,url,self.tieZiModel.pageView,self.focus];
    
    
    [body appendFormat:@"<div class=\"title\">【 %@ 】</div>",self.tieZiModel.title];
    
    
    // 遍历文字
    self.tieZiModel.content = [NSString stringWithFormat:@"<div class=\"content\">#%@</div>",self.tieZiModel.content];
    NSArray *arr = [self.tieZiModel.content componentsSeparatedByString:@"#"];
    NSString *text;
    
    for (int i = 0; i < arr.count; i ++) {
        
        if (i < arr.count - 1) {
            
            if (i >= 10) {
                text = [NSString stringWithFormat:@"%@#*%d",arr[i],i];
            }else{
                text = [NSString stringWithFormat:@"%@#%d",arr[i],i];
            }
        }else{
            text = arr[i];
        }
        
        [body appendString:text];
    }
    
    // 遍历img
    NSArray *picArr = [self.pic componentsSeparatedByString:@","];
    
    for (int i = 0; i < picArr.count; i ++) {
        
        NSString *URL = [NSString stringWithFormat:@"%@%@",kOuternet1,picArr[i]];
        
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\" >"];
        [imgHtml appendFormat:@"</div><img src=\"%@\"><div class=\"content\">",URL];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        
        if (i >= 10) {
            [body replaceOccurrencesOfString:[NSString stringWithFormat:@"#*%d",i] withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
        }else{
            
            // 替换标记
            [body replaceOccurrencesOfString:[NSString stringWithFormat:@"#%d",i] withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
        }
    }
    
    [body appendFormat:@"<script>"
     
     "function guanzhu(type){"
     
     "window.location.href = 'focus://'+type;}"
     
     "function afterguanzhu(text){"
     
     "document.getElementById(\"focus\").innerHTML=text;}"
     
     "</script>"];
    
    return body;
}

#pragma mark - ************* tableViewDelegate *************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.circleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MYCircleComment *comment = self.circleArr[section];
    return comment.replyVOs.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYCommentCell *cell = [MYCommentCell cellWithTableView:tableView indexPath:indexPath];
    MYCircleComment *comment = self.circleArr[indexPath.section];
        
    cell.hostName = comment.diaryComments.userName;
    MYCircleReply *reply = comment.replyVOs[indexPath.row];
    cell.reply = reply;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 代理方法
// 当一个分组标题进入视野的时候就会调用该方法
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //创建自定义的头部视图
    MYCircleCommentHeadView *headerview=[MYCircleCommentHeadView headerWithTableView:tableView section:section];
    
    headerview.headBlock = ^(NSString *name){
        self.textView.placeholder = [NSString stringWithFormat:@"回复了 %@",name];
        [self.textView becomeFirstResponder];
        MYCircleComment *comment = self.circleArr[section];
        self.sendBtn.tag = section;
        self.sendBtn.ID = comment.diaryComments.id;
    };
    
    if (!(self.circleArr.count == 0)) {
        MYCircleComment *comment = self.circleArr[section];
        headerview.comment = comment;
        return headerview;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MYCircleCommentHeadView *view = (MYCircleCommentHeadView *)[self tableView:self.circleTableView viewForHeaderInSection:section];
    return view.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MYCircleComment *comment = self.circleArr[indexPath.section];
    if (comment.replyVOs.count) {
        UITableViewCell *cell = [self tableView:self.circleTableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }else{
        return 1;
    }
    
}

#pragma mark - UIWebView Delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"focus"]) {
        
        [self getFocusData];
        
    }
    
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat titleW = MYScreenW - 50;
    UILabel *titleLabel = [UILabel addLabelWithFrame:CGRectMake((MYScreenW - titleW)/ 2, 20, titleW, 44) title:self.tieZiModel.title titleColor:titlecolor font:[UIFont boldSystemFontOfSize:17]];
    self.titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:titleLabel];
    
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.frame = CGRectMake(0,0, MYScreenW, height + 15);
    self.circleTableView.tableHeaderView = webView;
    [self.circleTableView reloadData];
    
    [self.circleTableView setContentOffset:CGPointMake(0, -ScrollHeadViewHeight) animated:YES];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{ NSLog(@"%@",error.userInfo);
   }

/**
 *  功能部分
 */
//退出的时候调用 放弃接受通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ******** 回复楼主 *******
- (void)jumpToSubView:(MYCircleBtn *)btn
{
    
    if([self.textView.text isEqualToString:@""])
    {
        [MBProgressHUD showHUDWithTitle:@"请输入评论内容" andImage:nil andTime:1.0];
         return;
    }
    
    if ([NSString stringContainsEmoji:self.textView.text]) {
        [MBProgressHUD showHUDWithTitle:@"暂不支持表情" andImage:nil andTime:1.0];
        return;
     }
 
    self.sendBtn.enabled = NO;
    
    //去除首尾空格和换行
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"commentId"] = @(btn.ID);
        param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        param[@"signature"] = [MYStringFilterTool getSignature];
        param[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
        param[@"content"] = content;
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/diary/replayDiary",kOuternet1] params:param success:^(id responseObject) {
            
            if ([responseObject[@"status"] isEqualToString:@"success"]) {
                [MBProgressHUD showHUDWithTitle:@"发送成功" andImage:nil andTime:1.0];
                [self clickDismissBtn];
                [self loadDetailBodyData];
                self.sendBtn.enabled = YES;
                [self.textView setText:@""];
                self.textView.placeholder = @"别拦我,让我说句话";
                self.textView.hidden = NO;


                
            }else if ([responseObject[@"status"] isEqualToString: @"-110"]){
                
                [MBProgressHUD showHUDWithTitle:@"暂不支持表情" andImage:nil andTime:1.0];
            }else{
                [MBProgressHUD showHUDWithTitle:@"操作失败" andImage:nil andTime:1.0];
            }
    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:@"操作失败"];
    }];
}

// brief 点赞/取消点赞 对评论的点赞
- (void)clickPraseBtn:(MYCircleBtn *)btn
{
    
    if (!MYAppDelegate.isLogin) {
        
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];

        
    }else{
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"commentId"] = @(btn.ID);
        param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        param[@"signature"] = [MYStringFilterTool getSignature];
        param[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
        
        if (btn.selected) {
            [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@diary/cancelPraiseComment",kOuternet1] params:param success:^(id responseObject) {
                
                if ([responseObject[@"status"] isEqualToString:@"success"]) {
                    
                    [self CricletableData:btn];
                    
                }else{
                    [MBProgressHUD showSuccess:@"操作失败"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showSuccess:@"操作失败"];
                
            }];
            
        }else{
            
            [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/diary/praiseComment",kOuternet1] params:param success:^(id responseObject) {
                
                if ([responseObject[@"status"] isEqualToString:@"success"]) {
                    
                    [self CricletableData:btn];
                    
                }else{
                    [MBProgressHUD showSuccess:@"操作失败"];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showSuccess:@"操作失败"];
                
            }];
        }
        
    }
}

//底部菜单
-(void)setupBoomView
{
    UIView *boomview = [[UIView alloc]initWithFrame:CGRectMake(0, MYScreenH - 50, MYScreenW, 50)];
    boomview.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.view addSubview:boomview];
    self.commentView = boomview;
    
    //点赞按钮
    UIButton *praiseBtn = [UIButton addButtonWithFrame:CGRectZero backgroundColor:nil Target:self action:@selector(ClickDianzanBtn)];
    [praiseBtn setImage:[UIImage imageNamed:@"prase_normal"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"prase_press"] forState:UIControlStateSelected];
    self.praiseBtn = praiseBtn;
    [boomview addSubview:praiseBtn];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(boomview.mas_right).offset(-40);
        make.top.mas_equalTo(boomview.mas_bottom).offset(-45);
        make.size.mas_equalTo(40);
        
    }];
    
    
    //发送按钮
    MYCircleBtn *sendBtn = [[MYCircleBtn alloc] initWithFrame:CGRectZero];
    [sendBtn setTitle:@"发布评论"];
    [sendBtn addTarget:self action:@selector(clicksendMessageBtn:)];
    self.sendBtn = sendBtn;
    sendBtn.tag = - 1;
    [boomview addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(praiseBtn.mas_left).offset(-65);
        make.top.mas_equalTo(boomview.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(60, 30));
        
    }];
    
    
    //输入内容视图 创建textView
    SHTextView *textView = [[SHTextView alloc] initWithFrame:CGRectMake(10, 10, MYScreenW - 60 - 65, 30)];
    textView.font = MYFont(14);
    textView.placeholder = @"别拦我，让我说句话";
    /** 是否可以伸缩 */
    textView.isCanExtend = YES;
    /** 伸缩行数 */
    textView.extendLimitRow = 8;
    /** 伸缩方向 */
    textView.extendDirection = ExtendUp;
    self.textView = textView;
    textView.delegate = self;
    [boomview addSubview:textView];
    
    
    // 监听键盘的弹出的隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiOfTextViewContentSizeHeightChangedActionHeigher:) name:@"NotiOfTextViewContentSizeHeightChangedHeigher" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiOfTextViewContentSizeHeightChangedActionLower:) name:@"NotiOfTextViewContentSizeHeightChangedLower" object:nil];

}


#pragma mark - 通知方法
-(void)keyboardWillShow:(NSNotification *)noti
{
    // 取出键盘弹出的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 取出键盘高度
    CGRect keyBoardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        self.commentView.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight );
//        self.tap.enabled = YES;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    // 取出键盘隐藏的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 清空transform
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        
        self.commentView.transform = CGAffineTransformIdentity;
        self.sendBtn.tag = -1;
        [self.textView setText:@""];
        self.textView.placeholder = @"别拦我,让我说句话";
        self.textView.hidden = NO;

//        self.tap.enabled = NO;
        
    } completion:^(BOOL finished) {
        
    }];
    
}
/**
 *  变高
 */
- (void)notiOfTextViewContentSizeHeightChangedActionHeigher:(NSNotification *)noti {
    
    CGFloat height = [noti.userInfo[@"MYHeigher"] floatValue ];
    //    CGFloat height = [noti.object floatValue];
    [UIView animateWithDuration:0.3f animations:^{
        
        self.commentView.frame = CGRectMake(0, self.commentView.frame.origin.y - height, self.commentView.frame.size.width, self.commentView.frame.size.height + height);
        [self.view layoutIfNeeded];
    }];
    
    
}
/**
 *  变矮
 */
- (void)notiOfTextViewContentSizeHeightChangedActionLower:(NSNotification *)noti {
    
    CGFloat height = [noti.object floatValue];
    self.commentView.frame = CGRectMake(0, self.commentView.frame.origin.y + height, self.commentView.frame.size.width, self.commentView.frame.size.height - height);
}
- (void)shouldDo
{
    [self.textView setText:@""];
    self.textView.placeholder = @"别拦我,让我说句话";
    self.textView.hidden = NO;
    self.sendBtn.tag = -1;
    //    [self.commentView endEditing:YES];
    
}

-(void)clickDismissBtn
{
    [self.textView resignFirstResponder];

}

#pragma ---->>>>>>>请求点赞数据<<<<<<<-------
-(void)CricletableData:(MYCircleBtn *)btn
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.id;
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/queryDiary",kOuternet1] params:param success:^(id responseObject) {
        
        //尾部
        self.circleArr  = [MYCircleComment objectArrayWithKeyValuesArray:responseObject[@"diaryList"][@"diaryCommentsList"]];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:btn.tag];
        [self.circleTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**请求收藏数据*/
-(void)getFocusData
{
    if (!MYAppDelegate.isLogin) {
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];

        
    }else{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        params[@"type"] = @"0";
        params[@"attentionId"] = self.id;
        params[@"signature"] = [MYStringFilterTool getSignature];
        params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
        
        if (self.focusStauts == 0){
            
            /**收藏*/
            [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/focusDiary",kOuternet1] params:params success:^(id responseObject) {
                
                self.focusStauts = 1;
                [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:afterguanzhu(\'已收藏\')"];
                
            } failure:^(NSError *error) {}];
            
        }else{
            
            /**取消收藏*/
            [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/diary/cancelFocusDiary",kOuternet1] params:params success:^(id responseObject) {
                self.focusStauts = 0;
                [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:afterguanzhu(\'收藏\')"];
                
            } failure:^(NSError *error) {}];}
        
    }
    
    
}
/**对帖子的点赞*/
-(void)ClickDianzanBtn
{
    if (!MYAppDelegate.isLogin) {
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
  
        
    }else{
        
        if (!self.praiseBtn.selected) {
            
            DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
            [self.view addSubview:heart];
            CGPoint fountainSource = CGPointMake(self.view.frame.size.width-50 + 36/2.0, self.commentView.y);
            if (fountainSource.y== MYScreenH-50) {
                heart.HeaderHeight = @"1"; //没有键盘弹出的
            }
            heart.center = fountainSource;
            [heart animateInView:self.view];
        }


        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
        params[@"diaryId"] = self.id;
        params[@"signature"] = [MYStringFilterTool getSignature];
        params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
        
        if (self.praiseStatus == 0){
            
            /**点赞*/
            [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@diary/praiseDiary",kOuternet1] params:params success:^(id responseObject) {
                
                self.praiseStatus = 1;
//                [_praiseBtn setImage:[UIImage imageNamed:@"prase_press"] forState:UIControlStateNormal];
                self.praiseBtn.selected = YES;
                
                
            } failure:^(NSError *error) {}];
            
        }else{
            
            /**取消点赞*/
            [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@diary/cancelPraiseDiary",kOuternet1] params:params success:^(id responseObject) {
                self.praiseStatus = 0;
                self.praiseBtn.selected = NO;
//                [_praiseBtn setImage:[UIImage imageNamed:@"prase_normal"] forState:UIControlStateNormal];
                
            } failure:^(NSError *error) {}];}
        
    }
    
}
//  底部对原帖子对回复
-(void)clicksendMessageBtn:(MYCircleBtn *)btn
{
        if (btn.tag != -1) {
            [self jumpToSubView:btn];
        }else{
            
            if(NULLString(self.textView.text)){
                [MBProgressHUD showHUDWithTitle:@"请输入评论内容" andImage:nil andTime:1.0];
                return ;
            }
            
        if ([NSString stringContainsEmoji:self.textView.text]) {
                [MBProgressHUD showHUDWithTitle:@"暂不支持表情" andImage:nil andTime:1.0];
                return;
            
        }
            
             self.sendBtn.enabled = NO;
            
            //去除首尾空格和换行
            NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"userId"] = [MYUserDefaults objectForKey:@"id"];
                params[@"type"] = 0;
                params[@"diaryId"] = self.id;
                params[@"content"] = content;
                params[@"signature"] = [MYStringFilterTool getSignature];
                params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
                
                [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/diary/commentDiary",kOuternet1] params:params success:^(id responseObject) {
                    if ([responseObject[@"status"] isEqualToString: @"success"])
                    {
                        [MBProgressHUD showSuccess:@"发帖成功"];
                        [self clickDismissBtn];
                        //重新刷新数据
                        [self loadDetailBodyData];
                        self.sendBtn.tag = -1;
                        self.sendBtn.enabled = YES;
                        [self.textView setText:@""];
                        self.textView.placeholder = @"别拦我,让我说句话";
                        self.textView.hidden = NO;

                        
                    }else if ([responseObject[@"status"] isEqualToString: @"-110"]){
                        
                        [MBProgressHUD showHUDWithTitle:@"暂不支持表情" andImage:nil andTime:1.0];
                    }else
                    {
                        [MBProgressHUD showError:@"发帖失败"];
                    }
                }
                 
                    failure:^(NSError *error) {
                    }];
        }
    
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //记录出上一次滑动的距离，因为是在tableView的contentInset中偏移的ScrollHeadViewHeight，所以都得加回来
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //根据偏移量算出alpha的值,渐隐,当偏移量大于-180开始计算消失的值
    CGFloat startF = -180;
    //初始的偏移量Y值为 顶部控件的高度
    CGFloat initY = ScrollHeadViewHeight;
    //缺少的那一段渐变Y值
    CGFloat lackY = initY + startF;
    //自定义导航条高度
    CGFloat naviH = 64;
    
    //渐现alph值
    CGFloat alphaScaleShow = (offsetY + initY - lackY) /  (initY - naviH - lackY) ;
    
    if (alphaScaleShow >= 0.98) {
        //显示导航条
        [UIView animateWithDuration:0.04 animations:^{
            self.navView.alpha = 1;
        }];
    } else {
        self.navView.alpha = 0;
    }
    self.navView.alpha = alphaScaleShow * 0.5;
    
    
    // 往上下滚动
    if (offsetY > -ScrollHeadViewHeight && offsetY<0) {
        if (self.imgView.height > self.imgRect.size.height) {
            self.imgView.y = - self.imgRect.size.height;
            self.imgView.height = self.imgRect.size.height;
            self.previousY = -self.imgRect.size.height;
        }
        self.imgView.y += (offsetY - self.previousY) * 0.5;
        self.previousY = offsetY;
        return;
    }else  if(offsetY <= -self.imgRect.size.height){
        
        if (self.imgView.y > - self.imgRect.size.height) {
            self.imgView.y =  - self.imgRect.size.height;
            
            self.previousY = -self.imgRect.size.height;
        }
        CGFloat sss = (self.previousY - offsetY);
        self.imgView.y  -= sss;
        self.imgView.height +=  sss ;
        self.previousY = offsetY;
        
    }
    
}
//// 点击空白处隐藏键盘
//- (void)clickedSelf:(id)sender
//{
//    [self.view endEditing:YES];
//}
// textview 改变字体的行间距
-(void)textViewDidChange:(UITextView *)textView
{
    
    // 判断是否有候选字符，如果不为nil，代表有候选字符
    if(textView.markedTextRange == nil){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 1.5; // 字体的行间距
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    }
    
}
//输入时判断是否登陆
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!MYAppDelegate.isLogin) {
        
        MYLoginViewController *loginVC = [[MYLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return NO;
        
    }
    return YES;
}
// 将要拖拽的时候调一次
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.commentView endEditing:YES];
    //    [self clickDismissBtn];
}


@end
