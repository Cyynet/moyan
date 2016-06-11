
//  MYHomeDesignerDeatilAppointmentViewController.m
//  魔颜
//
//  Created by abc on 15/10/8.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYHomeDesignerDeatilAppointmentViewController.h"


#import "MYHomeDesigerDeatilAppointmentFuwuController.h"
#import "MYCalendarView.h"

#import "MYAliPayViewController.h"
#import "MYWeiXinZhiFuController.h"
#import "RBCustomDatePickerView.h"

#import "MYTextView.h"
#import "WXApi.h"
#import "MYHeader.h"
#define RowHeight 33
#define textMargin 50
#define maxCol 5
#define maxRow 2
#define textlablefont [UIFont systemFontOfSize:13];

@interface MYHomeDesignerDeatilAppointmentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RBCustomDatePickerViewDelegate>

@property(strong,nonatomic)UIView *boomView;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UITextField *nameField;
@property (weak, nonatomic) UITextField *phoneField;
@property (weak, nonatomic) UITextField *ageField;
@property (weak, nonatomic) UITextField *addressField;
@property (weak, nonatomic) UILabel *timeLabel;

@property (weak, nonatomic) UIButton *lastBtn;
@property(weak,nonatomic) UIButton * sexlastBtn;


@property (strong, nonatomic) NSMutableArray *sexArr;
@property (copy, nonatomic) NSString *sex;
@property(assign,nonatomic) NSString * sextag;

//希望哪里变美
@property (copy, nonatomic) NSString *currentHopes;
@property (strong, nonatomic) NSArray *partTitles;

@property(strong,nonatomic) MYTextView * message;

@property (strong, nonatomic) NSMutableArray *hopesArr;
@property (strong, nonatomic) NSMutableArray *hopesBtns;
@property(strong,nonatomic) UIButton * btn1;
@property(strong,nonatomic) UIButton * btn2;
@property(strong,nonatomic) UIButton * btn;
@property(strong,nonatomic) NSString * payType;

@property(strong,nonatomic) NSString * nametext;
@property(strong,nonatomic) UITextField * namefield;

@property(strong,nonatomic) UITextField * agefield;
@property(strong,nonatomic) NSString * agetext;

@property(strong,nonatomic) UITextView * messagetextview;//congyong
@property(strong,nonatomic) NSString * messagetext;

@property(strong,nonatomic) NSString * timetext;

@property(strong,nonatomic) NSString * addresstext;
@property(strong,nonatomic) UITextField * addressfield;

@property(strong,nonatomic) NSString * phonetext;
@property(strong,nonatomic) UITextField * phonefield;


@property(strong,nonatomic) UIView * tablefooterview;


@property (strong, nonatomic) UIImageView *alipyimageview;
@property (strong, nonatomic) UIImageView *weixinimageview;
@property (strong, nonatomic) UIImageView *yinlianimageview;
// 支付上的分割线
@property(strong,nonatomic)UIView *zhifudiviview1;
@property(strong,nonatomic)UIView *zhifudiviview2;
@property(strong,nonatomic) NSArray * titlearr;
//支付
@property(assign, nonatomic) NSInteger paytag;
@end

@implementation MYHomeDesignerDeatilAppointmentViewController

- (NSMutableArray *)sexArr
{
    if (!_sexArr) {
        _sexArr = [NSMutableArray array];
    }
    return _sexArr;
}
- (NSMutableArray *)hopesArr
{
    if (!_hopesArr) {
        _hopesArr = [NSMutableArray array];
    }
    return _hopesArr;
}

- (NSMutableArray *)hopesBtns
{
    if (!_hopesBtns) {
        _hopesBtns = [NSMutableArray array];
    }
    return _hopesBtns;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.boomView.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [MYUserDefaults setObject:nil forKey:@"sextag"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.boomView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor whiteColor];
    if ([self.VCtag isEqualToString:@"0"]) {
        self.title = @"预约设计师";
        [self addtopbar];
    }else
    {
        self.title = @"预约名医";
    }
    [self setupTableView];
    
    [self addBoomView];
    [self.nameField becomeFirstResponder];

    
}

- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height-45);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView = tableView;
    tableView.rowHeight = RowHeight;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
//    tablviewheaderview
    UIView *tablefooterview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 160)];
    
    self.tablefooterview = tablefooterview;
    self.tableView.tableFooterView = tablefooterview;

    [self addfootview];
    
}

//支付方式的view
-(void)addfootview
{
    CGFloat imageheight = 20;
    CGFloat imagewith = 56;
    
    UIImageView *alipyimageview = [[UIImageView alloc]init];
    self.alipyimageview = alipyimageview;
    [self.tablefooterview addSubview:alipyimageview];
    [alipyimageview setImage:[UIImage imageNamed:@"alipay"]];
    alipyimageview.frame = CGRectMake(10, 15, imagewith, imageheight);
    
    
    if ([WXApi isWXAppInstalled]) {
        UIImageView *weixinimageview = [[UIImageView alloc]init];
        self.weixinimageview = weixinimageview;
        [self.tablefooterview addSubview:weixinimageview];
        [weixinimageview setImage:[UIImage imageNamed:@"weixin"]];
        weixinimageview.frame = CGRectMake(10, CGRectGetMaxY(alipyimageview.frame) +25, imagewith, imageheight);
        
        UIView *zhifudiviview2 = [[UIView alloc]init];
        self.zhifudiviview2 = zhifudiviview2;
        [self.tablefooterview addSubview:zhifudiviview2];
        zhifudiviview2.backgroundColor = [UIColor blackColor];
        zhifudiviview2.alpha = 0.2;
        zhifudiviview2.frame  = CGRectMake(0, CGRectGetMaxY(weixinimageview.frame) +10, MYScreenW, 1);
    }
    
    //    UIImageView *yinlianimageview = [[UIImageView alloc]init];
    //    self.yinlianimageview = yinlianimageview;
    //    [paycontent addSubview:yinlianimageview];
    //    [yinlianimageview setImage:[UIImage imageNamed:@"unionpay"]];
    //    yinlianimageview.frame = CGRectMake(leftjianju, CGRectGetMaxY(weixinimageview.frame) +25, imagewith, imageheight);
    
    
    //        分割线
    UIView *zhifudiviview1 = [[UIView alloc]init];
    self.zhifudiviview1 = zhifudiviview1;
    [self.tablefooterview addSubview:zhifudiviview1];
    zhifudiviview1.backgroundColor = [UIColor blackColor];
    zhifudiviview1.alpha = 0.2;
    zhifudiviview1.frame  = CGRectMake(0, CGRectGetMaxY(alipyimageview.frame) +10, MYScreenW, 1);
    
    
    if ([WXApi isWXAppInstalled]) {
        self.titlearr = @[@"",@""];
    }else{
        self.titlearr = @[@""];
    }
    for (int i = 1; i <= self.titlearr.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake( MYScreenW - 40, (i - 1) * 45, 20, 50);
        //        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:[self.titlearr objectAtIndex:i-1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
        btn.tag = i;
        self.btn = btn;
        [btn addTarget:self action:@selector(selectse:) forControlEvents:UIControlEventTouchUpInside];
        [self.tablefooterview addSubview:btn];
    }
    
}



//组数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.VCtag isEqualToString:@"0"])
    {
            return 12;
        
    }else {     //从banner调用

            return 11;
    }
  
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str_Identifier = [NSString stringWithFormat:@"Tiezi%ld",(long)[indexPath row]];
    
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str_Identifier];

    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_Identifier];
    }else
    {
        for (UIView *subview in cell.contentView.subviews)
        {
            [subview removeFromSuperview];
        }
    }
    
    [self.sexArr removeAllObjects];
    
    //去掉点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        
        UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"填写个人信息"];
        cell.backgroundColor = MYColor(230, 230, 230);
        [cell.contentView addSubview:titleLabel];
    }
    else if(indexPath.row == 1) {
        
        UILabel *label = [self addLabelWithFrame:CGRectMake(kMargin, 0, 50, RowHeight) text:@"姓名:"];
        [cell.contentView addSubview:label];
        
        UITextField *textField = [self addFieldWithFrame:CGRectMake(textMargin, 0, 100, RowHeight) text:self.nametext];
        self.namefield = textField;
        self.nametext = textField.text;
                if ([textField.text isEqualToString:@""] || textField.text == nil)
                {
        
                }else{
                    self.nametext = textField.text;
                }
        [textField becomeFirstResponder];
        self.nameField = textField;
        self.nameField.placeholder = @"(请填写真实姓名)";
        [cell.contentView addSubview:textField];
        
        UILabel *phone = [self addLabelWithFrame:CGRectMake(self.view.width / 2, 0, 80, RowHeight) text:@"电话:"];
        [cell.contentView addSubview:phone];
        
        NSString *phonetext = [MYUserDefaults objectForKey:@"code"];
        if ([phonetext isEqualToString:@""]) {
            phonetext = nil;
        }
        
        
        
        UITextField *textField1 = [self addFieldWithFrame:CGRectMake(self.view.width / 2 + 40, 0, self.view.width / 2 - 40, RowHeight) text:phonetext];
        self.phoneField = textField1;
        [cell.contentView addSubview:textField1];
        
    }else if(indexPath.row == 2) {
        
        UILabel *label = [self addLabelWithFrame:CGRectMake(kMargin, 0, 50, RowHeight) text:@"性别:"];
        [cell.contentView addSubview:label];

        NSArray *titles = @[@"女",@"男"];
        for (int i = 0;  i < titles.count; i ++) {

            UIButton *btn = [[UIButton alloc] init];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
            btn.width = self.view.width / 7;
            btn.frame = CGRectMake(50 + btn.width * i, 0, btn.width, RowHeight);
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:subTitleColor forState:UIControlStateNormal];
            btn.titleLabel.font = leftFont;
            [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
            btn.tag = i;
            [btn addTarget:self action:@selector(selectsex:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            [self.sexArr addObject:btn];

        }

            NSInteger sex = [[MYUserDefaults valueForKey:@"sex"] integerValue];

            self.sex = [NSString stringWithFormat:@"%ld",(long)sex ];
        
        NSString *sexstring = [NSString stringWithFormat:@"%ld",(long)sex];
        
        [MYUserDefaults setObject:sexstring forKey:@"sex"];
            
            ((UIButton *)[self.sexArr objectAtIndex:sex]).selected = YES;
            self.sexlastBtn = (UIButton *)[self.sexArr objectAtIndex:sex];

        
        
        UILabel *age = [self addLabelWithFrame:CGRectMake(self.view.width / 2, 0, 100, RowHeight) text:@"年龄:"];
        [cell.contentView addSubview:age];
        

        UITextField *textField = [self addFieldWithFrame:CGRectMake(self.view.width / 2 + 40, 0, 100, RowHeight) text:self.agetext];
        self.agefield = textField;
        self.agetext = textField.text;

        if ([textField.text isEqualToString:@""] || textField.text == nil)
        {
        }else{
            self.agetext = textField.text;
        }
        self.ageField = textField;

        [cell.contentView addSubview:textField];
        
        
    }
    else if(indexPath.row == 3) {
        
        UILabel *label = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"地址:"];
        [cell.contentView addSubview:label];
        
        NSString *addresstext = [MYUserDefaults objectForKey:@"region"];

        self.addresstext = addresstext;
        if ([self.addresstext isEqualToString:@""]) {
            addresstext = nil;
        }

        UITextField *textField = [self addFieldWithFrame:CGRectMake(textMargin, 0, self.view.width - 50, RowHeight) text:self.addresstext];
        self.addressField = textField;
        self.addresstext = textField.text;
        if ([textField.text isEqualToString:@""] || textField.text == nil)
        {
        }else{
            self.addresstext = textField.text;
        }
        self.addressField = textField;
        
        [cell.contentView addSubview:textField];
        

        
        
        [cell.contentView addSubview:textField];
        
    }else if (indexPath.row == 4){
        
        UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"预约信息"];
        cell.backgroundColor = MYColor(230, 230, 230);
        [cell.contentView addSubview:titleLabel];
    }
    
    else if(indexPath.row == 5) {
        NSString * titlestr;
        NSString *price ;
        if ([self.VCtag isEqualToString:@"0"]) {
            titlestr = @"设计费";
            price = self.originalPrice;
            
        }else{
            titlestr = @"预约费";
            price = self.desigerPrice;
        }
        UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:titlestr];
        [cell.contentView addSubview:titleLabel];
        
        UILabel *payLabel = [self addLabelWithFrame:CGRectMake(self.view.width / 2, 0, self.view.width / 2 - MYMargin, RowHeight) text:[NSString stringWithFormat:@"¥%@",price]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:payLabel.text];
        [str addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, payLabel.text.length)];
        if ([self.VCtag isEqualToString:@"0"]) {
            [payLabel setAttributedText:str];
        }
        payLabel.textColor = MYColor(193, 177, 122);
        payLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:payLabel];
        
        
    }else if(indexPath.row == 6) {
        
        NSString *nametitle;
        NSString *namecontent;
        if ([self.VCtag isEqualToString:@"0"]) {
            nametitle = @"特惠价";
            namecontent = self.desigerPrice;
            UILabel *discountLabel = [self addLabelWithFrame:CGRectMake(self.view.width / 2, 0, self.view.width / 2 - MYMargin, RowHeight) text:[NSString stringWithFormat:@"¥%@",namecontent]];
            
            discountLabel.textColor = MYColor(193, 177, 122);
            discountLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:discountLabel];
            
        }else
        {
            nametitle = self.name;
//            namecontent = @"全军皮肤损伤修复研究所所长";
//            UILabel *discountLabel = [self addLabelWithFrame:CGRectMake( 60, 0, self.view.width  - MYMargin - 50, RowHeight) text:[NSString stringWithFormat:@"%@",namecontent]];
            
            //            discountLabel.textColor = MYColor(193, 177, 122);
            //            discountLabel.textAlignment = NSTextAlignmentRight;
//            [cell.contentView addSubview:discountLabel];
        }
        
        UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width - kMargin, RowHeight) text:nametitle];
        [cell.contentView addSubview:titleLabel];
        
        
    }else if(indexPath.row == 7) {
        
        if([self.VCtag isEqualToString:@"0"])
        {
            UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:self.name];
            [cell.contentView addSubview:titleLabel];
            
            UILabel *discountLabel = [self addLabelWithFrame:CGRectMake(50, 0, self.view.width / 2, RowHeight) text:self.desigerzhizi];
            [cell.contentView addSubview:discountLabel];
            
        }else
        {
            UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"希望哪里变美"];
            [cell.contentView addSubview:titleLabel];
            
            self.partTitles = @[@"额头",@"眉部",@"眼部",@"鼻部",@"唇部",@"面部",@"牙齿",@"抗衰",@"皮肤",@"身体"];
            for (int i = 0; i < self.partTitles.count; i ++ ) {
                UIButton *btn = [[UIButton alloc] init];
                
                int col = i % maxCol;
                int row = i / maxCol;
                
                btn.width = (self.view.width - (maxCol + 1) * kMargin) / maxCol -5 ;
                btn.height = 20;
                btn.x = col *  (btn.width + kMargin) + 2.5 * kMargin;
                btn.y = row * (btn.height + kMargin) + CGRectGetMaxY(titleLabel.frame);
                btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                btn.layer.borderWidth = 0.4;
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitle:[self.partTitles objectAtIndex:i] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"usertag"] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(clickPartdesigerBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
                btn.tag = i;
                [self.hopesBtns addObject:btn];
            }
            
        }
        
    }else if(indexPath.row == 8) {
        
        if ([self.VCtag isEqualToString:@"0"]) {
            UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"希望哪里变美"];
            [cell.contentView addSubview:titleLabel];
            
            self.partTitles = @[@"额头",@"眉部",@"眼部",@"鼻部",@"唇部",@"面部",@"牙齿",@"抗衰",@"皮肤",@"身体"];
            for (int i = 0; i < self.partTitles.count; i ++ ) {
                UIButton *btn = [[UIButton alloc] init];
                
                int col = i % maxCol;
                int row = i / maxCol;
                
                btn.width = (self.view.width - (maxCol + 1) * kMargin) / maxCol -5 ;
                btn.height = 20;
                btn.x = col *  (btn.width + kMargin) + 2.5 * kMargin;
                btn.y = row * (btn.height + kMargin) + CGRectGetMaxY(titleLabel.frame);
                btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                btn.layer.borderWidth = 0.4;
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitle:[self.partTitles objectAtIndex:i] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"usertag"] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(clickPartdesigerBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
                btn.tag = i;
                [self.hopesBtns addObject:btn];
            }
            
        }else
        {
            UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"选择服务时间"];
            [cell.contentView addSubview:titleLabel];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(self.view.width / 2, 0, 16.5, 21);
            imageView.image = [UIImage imageNamed:@"calender"];
            [cell.contentView addSubview:imageView];
            
            UILabel *timeLabel = [self addLabelWithFrame:CGRectMake(0, 30, self.view.width, 25) text:@""];
            self.timeLabel = timeLabel;
            self.timeLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:timeLabel];
            
            if ([timeLabel.text isEqualToString:@""]||timeLabel.text == nil) {
                
            }else
            {
                self.timetext = timeLabel.text;
            }
            self.timeLabel.text = self.timetext;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, RowHeight)];
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(chooseTime) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
    }
    else  if(indexPath.row == 9)
    {
        if ([self.VCtag isEqualToString:@"0"]) {
            UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"选择服务时间"];
            [cell.contentView addSubview:titleLabel];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(self.view.width / 2, 0, 16.5, 21);
            imageView.image = [UIImage imageNamed:@"calender"];
            [cell.contentView addSubview:imageView];
            
            UILabel *timeLabel = [self addLabelWithFrame:CGRectMake(0, 30, self.view.width, 25) text:@""];
            self.timeLabel = timeLabel;
            self.timeLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:timeLabel];
            
            if ([timeLabel.text isEqualToString:@""]||timeLabel.text == nil) {
                
            }else
            {
                self.timetext = timeLabel.text;
            }
            self.timeLabel.text = self.timetext;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, RowHeight)];
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(chooseTime) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            
        }else
        {
            UILabel *titlelable = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"买家留言:"];
            [cell.contentView addSubview:titlelable];
            
            
            MYTextView *message = [[MYTextView alloc]initWithFrame:CGRectMake(kMargin + 50, 2, self.view.width -kMargin*2 -52, 57)];
            [cell.contentView addSubview:message];
            message.placeHoledr = @"可备注您的需求";
            message.font = leftFont;
            self.message  = message;
            self.message.text = message.text;
            message.alwaysBounceVertical = NO;
            
            self.messagetextview = message;
            
            if ([message.text isEqualToString:@""]||message.text == nil) {
                message.placeHoledr = @"可备注您的需求";
            }else
            {
                self.messagetext = message.text;
                message.placeHoledr = @"";
            }
            self.message.text = self.messagetext;
            
        }
    }
    else if (indexPath.row == 10)
    {
        if ([self.VCtag isEqualToString:@"0"]) {
            
            UILabel *titlelable = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"买家留言:"];
            [cell.contentView addSubview:titlelable];
            
            
            MYTextView *message = [[MYTextView alloc]initWithFrame:CGRectMake(kMargin + 50, 2, self.view.width -kMargin*2 -52, 57)];
            [cell.contentView addSubview:message];
            message.placeHoledr = @"可备注您的需求";
            message.font = leftFont;
            self.message  = message;
            self.message.text = message.text;
            message.alwaysBounceVertical = NO;
            
            self.messagetextview = message;

            if ([message.text isEqualToString:@""]||message.text == nil) {
                message.placeHoledr = @"可备注您的需求";
            }else
            {
                self.messagetext = message.text;
                message.placeHoledr = @"";
            }
            self.message.text = self.messagetext;
        }else{
            
            UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"选择支付方式"];
            cell.backgroundColor = MYColor(230, 230, 230);
            [cell.contentView addSubview:titleLabel];
        }
    }
    else if (indexPath.row == 11){
        if ([self.VCtag isEqualToString:@"0"]) {
            
            UILabel *titleLabel = [self addLabelWithFrame:CGRectMake(kMargin, 0, self.view.width, RowHeight) text:@"选择支付方式"];
            cell.backgroundColor = MYColor(230, 230, 230);
            [cell.contentView addSubview:titleLabel];
            
        }
    }
   
    else{
    
    }
    return cell;
}


-(void)chooseTime
{
    self.timeLabel.text = nil;
    RBCustomDatePickerView *pickerView = [RBCustomDatePickerView dataPickerView];
    pickerView.delegate = self;
    [pickerView showInRect:CGRectMake(10, 120, MYScreenW - 20, 285)];
    
}
- (void)datePickView:(RBCustomDatePickerView *)datePickView showTimeLabelText:(NSString *)showTimeLabelText
{
    self.timeLabel.text = showTimeLabelText;
    self.timetext = self.timeLabel.text;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.VCtag isEqualToString:@"0"]) {
        
        if (indexPath.row == 8) {
            return 100;
        }else if (indexPath.row == 9 || indexPath.row == 10){
            return 60;
        }else{
            return RowHeight;
        }
        
    }else{
        
        if(indexPath.row == 7){
            
            return 100;
        }
       else if (indexPath.row == 8)
        {
            return 60;
        }else if(indexPath.row == 9)
        {
            return 60;
        }else
        {
            return  RowHeight;
        }
        
    }
}


//底部视图
-(void)addBoomView
{
    UIView *boomView = [[UIView alloc]init];
    [self.view addSubview:boomView];
    self.boomView = boomView;
    boomView.frame = CGRectMake(0, MYScreenH - 40, MYScreenW, 40);
    boomView.backgroundColor = [UIColor whiteColor];
    
    
    //    提交订单
    UIButton *referOrderBtn = [[UIButton alloc]init];
    referOrderBtn.frame = CGRectMake(0, 0, MYScreenW, 40);
    [referOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    referOrderBtn.backgroundColor = MYColor(193, 177, 122);
    referOrderBtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:13.0];
    [referOrderBtn addTarget:self action:@selector(clickreferOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    [boomView addSubview:referOrderBtn];
    
}

/*
 @brief 选择支付方式
 */
-(void)selectse:(UIButton *)btn
{
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    self.payType = [NSString stringWithFormat:@"%ld",(long)btn.tag-1];
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)addtopbar
{
    
    UIButton *rightBtn  = [[UIButton alloc]init];
    [rightBtn setTitle:@"服务介绍" forState:UIControlStateNormal];
    rightBtn.size = CGSizeMake(80, 30);
    rightBtn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:10.0];
    [rightBtn setTitleColor:titlecolor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickrightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

//  服务介绍
-(void)clickrightBtn
{
    MYHomeDesigerDeatilAppointmentFuwuController *appiontionFuwuVC = [[MYHomeDesigerDeatilAppointmentFuwuController alloc]init];
    [self.navigationController pushViewController:appiontionFuwuVC animated:YES];
    
}

// 将要拖拽的时候调一次
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    self.nametext = self.namefield.text;
    self.agetext = self.agefield.text;
    self.sex = self.sextag;
    [MYUserDefaults setObject:self.sex forKey:@"sex"];

//    备注
    self.messagetext= self.message.text;
    if (![self.messagetext isEqualToString:@""]) {
        self.message.placeHoledr = @"";
    }else{
    self.message.placeHoledr = @"可备注您的需求";
    }
    
    self.addresstext = self.addressField.text;
    
    
}

//*选择性别
-(void)selectsex:(UIButton *)sexbtn
{
    self.sexlastBtn.selected = NO;
    sexbtn.selected = YES;
    self.sexlastBtn = sexbtn;
    
    self.sex = [NSString stringWithFormat:@"%ld",(long)sexbtn.tag ];
    self.sextag = self.sex;
    [MYUserDefaults setObject:self.sex forKey:@"sex"];
    
}


//希望那里变美
- (void)clickPartdesigerBtn:(UIButton *)btn
{
    if (btn.selected) {
        
        btn.selected = NO;
        [self.hopesArr removeObject:[self.partTitles objectAtIndex:btn.tag]];
    }else{
        btn.selected = YES;
        [self.hopesArr addObject:[self.partTitles objectAtIndex:btn.tag]];
    }
    
    self.currentHopes = [self.hopesArr componentsJoinedByString:@","];
    
    
}


/*
 @brief textField
 */
- (UITextField *)addFieldWithFrame:(CGRect)frame text:(NSString *)text
{
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = frame;
    textField.delegate = self;
    textField.placeholder = @"点击可编辑";
    textField.font = leftFont;
    textField.text = text;
    textField.textColor = subTitleColor;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return textField;
}

/*
 @brief 左边Label
 */
- (UILabel *)addLabelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = frame;
    leftLabel.text = text;
    leftLabel.textColor = titlecolor;
    leftLabel.font = leftFont;
    
    return leftLabel;
}

/*
 @brief 分割线左对齐
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //按照作者最后的意思还要加上下面这一段
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
//提交订单
-(void)clickreferOrderBtn
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    int  sextag = [[MYUserDefaults valueForKey:@"sex"] intValue];
    NSString *sex = [NSString stringWithFormat:@"%d",sextag];
    
    if ([self.desigerPrice isEqualToString:@"0"]) {
        param[@"payType"] = @"-1";
    }else
    {
        param[@"payType"] = self.payType;
    }
    
    param[@"userId"] = [MYUserDefaults objectForKey:@"id"];
    param[@"name"] =  self.nameField.text;
    param[@"phone"] = self.phoneField.text;
    param[@"address"] = self.addressField.text;
    param[@"sex"] = sex;
    param[@"age"] = self.ageField.text;
    param[@"desId"] = self.desigerId;
    param[@"beautiful"] = self.currentHopes;
    param[@"time"] = self.timeLabel.text;
    param[@"signature"] = [MYStringFilterTool getSignature];
    param[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    param[@"sysType"] = @"2"; //是后台对ios的判断
    param[@"evaluate"] = self.message.text;         //   买家留言
    param[@"pri"] = self.desigerPrice;              //特惠价
    param[@"desName"] = self.name;                   //姓名
    
    /**判断是否为空*/
    if ([self.nameField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请填写姓名"];
    }else if (!self.phoneField.text){
        [MBProgressHUD showError:@"请填写手机号"];
    }else if ([sex isEqualToString:@""] || sex == 0){
        [MBProgressHUD showError:@"请填写性别"];
    }else if ([self.ageField.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请填写年龄"];
    }else if (!self.addressField.text){
        [MBProgressHUD showError:@"请填写地址"];
    }else if (self.currentHopes == nil){
        [MBProgressHUD showError:@"请填写希望哪里变美"];
    }else if ([self.timeLabel.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请填写服务时间"];
        
    }else{
        
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/reservationDes/addReservation",kOuternet1] params:param success:^(id responseObject) {
            //            if ([self.desigerPrice isEqualToString:@"0"]) {
            
            NSString *status = [responseObject objectForKey:@"status"];
            if ([status isEqualToString:@"success"])
            {
                
                if ([self.desigerPrice isEqualToString:@"0"]) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"预约成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    
                }
                else{
                    
                    NSString *stringInt = [NSString stringWithFormat:@"%@",responseObject[@"type"]];
                    //        支付宝
                    if ([ stringInt isEqualToString:@"0"]) {
                        
                        MYAliPayViewController *alipayVC = [[MYAliPayViewController alloc]init];
                        [self.navigationController pushViewController:alipayVC animated:YES];
                        
                        alipayVC.partner = responseObject[@"PARTNER"];
                        alipayVC.seller = responseObject[@"SELLER"];
                        alipayVC.privateKey = responseObject[@"privateKey"];
                        alipayVC.tradeNO = responseObject[@"out_trade_no"];
                        alipayVC.serviece = responseObject[@"serviceALI"];
                        alipayVC.inputCharset = responseObject[@"inputCharset"];
                        alipayVC.notifyURL = responseObject[@"notifyURL"];
                        alipayVC.productName = responseObject[@"pay_title"];
                        alipayVC.paymentType = responseObject[@"paymentType"];
                        alipayVC.amount = responseObject[@"pay_price"];
                        alipayVC.productDescription = responseObject[@"pay_body"];
                        alipayVC.itBPay = responseObject[@"30m"];
                        alipayVC.sign_type = responseObject[@"sign_type"];
                        
                    }
                    //        微信支付
                    else if ([ stringInt isEqualToString:@"1"])
                    {
                        MYWeiXinZhiFuController *weixinVC = [[MYWeiXinZhiFuController alloc]init];
                        [self.navigationController pushViewController:weixinVC animated:YES];
                        
                        weixinVC.shangpingname =  responseObject[@"pay_body"];
                        weixinVC.shangpindeatil =  responseObject[@"pay_detail"];
                        
                        NSString *pric1 = responseObject[@"pay_price"];
                        double  pric2 = [pric1 floatValue];
                        NSString *pric3 = [NSString stringWithFormat:@"%.2f",pric2/100];
                        
                        weixinVC.preice =  [NSString stringWithFormat:@"%@",pric3];
                        
                        weixinVC.oderid = responseObject[@"out_trade_no"];
                        
                    }else
                    {
                        
                    }
                }
                
            }else if ([status isEqualToString:@"-118"]){
                [MBProgressHUD showError:@"您已预约"];
                
                return ;
                
            }else if ([status isEqualToString:@"-209"]){
                
                [MBProgressHUD showError:@"您填写的时间不在可预约范围内"];
                
            }else{
                [MBProgressHUD showError:@"信息有误,请核对信息"];
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD showError:@"数据异常，请您重新尝试"];
            
        }];
    }
}

@end
