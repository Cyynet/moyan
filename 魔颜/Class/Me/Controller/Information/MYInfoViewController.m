//
//  MYInfoViewController.m
//  魔颜
//
//  Created by Meiyue on 15/9/28.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYInfoViewController.h"

#import "MYBaseGroup.h"
#import "MYBaseItem.h"
#import "MYArrowItem.h"

#import "MYInfoDetailViewController.h"
#import "MYRegionViewController.h"


#import "MYCalendarView.h"
#import "DWTagList.h"
#import "MYHeader.h"

#define MaxCol 6
#define MaxCols 4
#define kMargin 10

@interface MYInfoViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MYCalendarViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UILabel *cityLabel;
@property (weak, nonatomic) UITextField *nameField;
@property (weak, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) NSArray *titles;

@property (strong, nonatomic) NSMutableArray *sexArr;

@property (weak, nonatomic) UIButton *lastBtn;
@property (weak, nonatomic) UIImageView *imaView;
@property (copy, nonatomic) NSString *currentImageName;
@property (weak, nonatomic) UILabel *ageLabel;
@property (weak, nonatomic) UILabel *iconLabel;
/** 优惠码 */
@property (weak, nonatomic) UILabel *promoCodeLabel;
@property (weak, nonatomic) UITextField *promoCodeField;

/** 邀请的人 */
@property (assign, nonatomic) int number;


/** 优惠码描述 */
@property (weak, nonatomic) UILabel *desLabel;

@property (strong, nonatomic) MYUserModel *userModel;
@property (weak, nonatomic) UITextField *phoneField;
@property (weak, nonatomic) UITextField *regionField;

//性别
@property (assign, nonatomic) NSInteger sex;

//别人对我的态度和评价
@property (weak, nonatomic) UIButton *viewBtn;
@property (copy, nonatomic) NSString *currentViews;
@property (strong, nonatomic) NSArray *attitudeArr;
@property (strong, nonatomic) NSMutableArray *viewsArr;
@property (strong, nonatomic) NSMutableArray *viewsBtns;

//希望自己哪里变美
@property (weak, nonatomic) UIButton *hopeBtn;
@property (copy, nonatomic) NSString *currentHopes;
@property (strong, nonatomic) NSArray *partTitles;
@property (strong, nonatomic) NSMutableArray *hopesArr;
@property (strong, nonatomic) NSMutableArray *hopesBtns;


@end

@implementation MYInfoViewController

/*
 @brief 懒加载
 */
- (NSMutableArray *)sexArr
{
    if (!_sexArr) {
        _sexArr = [NSMutableArray array];
    }
    return _sexArr;
}

- (NSMutableArray *)viewsArr
{
    if (!_viewsArr) {
        _viewsArr = [NSMutableArray array];
    }
    return _viewsArr;
}

- (NSMutableArray *)viewsBtns
{
    if (!_viewsBtns) {
        _viewsBtns = [NSMutableArray array];
    }
    return _viewsBtns;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requsetPersonalMessage];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfo)];
    self.title = @"个人资料";
    
    [MYNotificationCenter addObserver:self selector:@selector(cancel) name:@"cancel" object:nil];
    
}

- (void)cancel
{
    self.ageLabel.text = nil;
}

/*
 @brief 保存个人数据
 */
- (void)saveInfo
{
    
    if (self.promoCodeField.text.length < 5 && self.promoCodeField.text.length >= 1) {
        [MBProgressHUD showError:@"优惠码位数不够,请核实"];
    }else {
    
    [MYUserDefaults setObject:self.nameField.text forKey:@"name"];
    [MYUserDefaults setValue:@(self.sex) forKey:@"sex"];
    [MYUserDefaults synchronize];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [MYUserDefaults objectForKey:@"id"];
    params[@"signature"] = [MYStringFilterTool getSignature];
    params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    
    params[@"pic"] = self.currentImageName;
    params[@"name"] = self.nameField.text;
    params[@"sex"] = @(self.sex);
    params[@"birthday"] = self.ageLabel.text;
    params[@"region"] = self.regionField.text;
    params[@"phone"] = self.phoneField.text;
    params[@"inviteCode"] = self.promoCodeField.text;
    
    params[@"income"] = [MYUserDefaults objectForKey:@"income"];
    params[@"interests"] = [MYUserDefaults objectForKey:@"interests"];
    params[@"cars"] = [MYUserDefaults objectForKey:@"cars"];
    params[@"family"] = [MYUserDefaults objectForKey:@"family"];
    
    params[@"views"] = self.currentViews;
    params[@"hopes"] = self.currentHopes;
    
    [MBProgressHUD showMessage:@"正在提交数据"];
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@user/editUser",kOuternet1] params:params success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            MYUserModel *model = [MYUserModel objectWithKeyValues:responseObject];
            self.userModel = model;
            
            [MBProgressHUD hideHUD];
            
            [self requsetPersonalMessage];
            
            [self.navigationController popViewControllerAnimated:YES];
    
        }else if ([responseObject[@"status"] isEqualToString:@"-99"]){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"优惠码错误"];
        }else{
            [MBProgressHUD hideHUD];
        }
        
    } failure:^(NSError *error) {
        
        MYLog(@"%@",error);
        [MBProgressHUD hideHUD];
        
    }];
    }
    
}

/*
 @brief 请求个人资料数据
 */
- (void)requsetPersonalMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [MYUserDefaults objectForKey:@"id"];
    params[@"signature"] = [MYStringFilterTool getSignature];
    params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/user/queryUserInfo",kOuternet1] params:params success:^(id responseObject) {
        
        MYUserModel *model = [MYUserModel objectWithKeyValues:responseObject[@"user"]];
        self.userModel = model;
        
        self.number = [responseObject[@"number"] intValue];
        
        [self setupScrollView];
        [self setupViews];
        [self.view layoutIfNeeded];
        
        
    } failure:^(NSError *error) {
        
        MYLog(@"%@",error);
    
    }];
}

-(void)cityDidChange:(NSNotification *)noti
{
    // 改变Item上的标题
    self.cityLabel.text = noti.userInfo[@"MYSelectCityName"];
    
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, MYScreenH)];
    scrollView.contentSize =  CGSizeMake(self.view.width, MYScreenH * 1.8);
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
}

- (void)setupViews
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.width, 80);
    [self.scrollView addSubview:view];
    
    //分割线
    for (int i = 0; i < 10; i ++) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, MYRowHeight * i + 80, self.view.width, 0.6);
        lineView.backgroundColor = lineViewBackgroundColor;
        [self.scrollView addSubview:lineView];
        
        if (i == 9) {
            lineView.frame = CGRectMake(0, MYRowHeight * (i + 1) + 80, self.view.width, 5);
        }
    }
    
    //第一行
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(MYMargin + 10, 10, 60, 60);
    imageView.image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,self.userModel.pic]] options:0 error:nil]] circleImage];
//    [imageView setHeaderWithURL:[NSString stringWithFormat:@"%@%@",kOuternet1,self.userModel.pic]];
    self.imaView = imageView;
    [self.scrollView addSubview:imageView];
    
    UILabel *iconLabel = [[UILabel alloc] init];
    iconLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + MYMargin * 0.5, 0, 80, 80);
    iconLabel.text = @"修改头像";
    iconLabel.textColor = titlecolor;
    self.iconLabel = iconLabel;
    iconLabel.font = MianFont;
    [self.scrollView addSubview:iconLabel];
    
    /**右侧箭头*/
    [self addImaViewWithFrame:CGRectMake(MYScreenW - 30, 35, 12, 12)];
    
    [self addBtnWithFrame:CGRectMake(0, 0, self.view.width, 80) action:@selector(clickIconBtn) target:self];
    
    
    //第二行
    [self addLabelWithFrame:CGRectMake(MYMargin * 1.75, CGRectGetMaxY(iconLabel.frame), 100, MYRowHeight) text:@"昵称"];
    
    self.nameField = [self addFieldWithFrame:CGRectMake(self.view.width / 2, CGRectGetMaxY(iconLabel.frame), self.view.width / 2 - MYMargin, MYRowHeight) text:self.userModel.name];
    
    
    //第三行
    [self addLabelWithFrame:CGRectMake(MYMargin * 1.75, CGRectGetMaxY(_nameField.frame), 100, MYRowHeight) text:@"性别"];
    
    self.titles = @[@"女",@"男"];
    for (int i = 0; i < self.titles.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        btn.width = self.view.width / 7;
        btn.frame = CGRectMake(self.view.width / 3 * 2 + kMargin + btn.width * i, CGRectGetMaxY(_nameField.frame), btn.width, MYRowHeight);
        [btn setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:subTitleColor forState:UIControlStateNormal];
        btn.titleLabel.font = MianFont;
        [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [self.sexArr addObject:btn];
        
    }
    
    ((UIButton *)[self.sexArr objectAtIndex:self.userModel.sex]).selected = YES;
    self.lastBtn = (UIButton *)[self.sexArr objectAtIndex:self.userModel.sex];
    
    /**第四行*/
    
    [self addLabelWithFrame:CGRectMake(MYMargin * 1.75, CGRectGetMaxY(self.lastBtn.frame), 100, MYRowHeight) text:@"出生日期"];
    
    self.ageLabel =  [self addLabelWithFrame:CGRectMake(MYScreenW - 130, CGRectGetMaxY(self.lastBtn.frame), 100, MYRowHeight) text:self.userModel.birthday];
    [MYUserDefaults setObject:self.ageLabel.text forKey:@"age"];
    [MYUserDefaults setObject:self.userModel.pic forKey:@"userPic"];
    [MYUserDefaults synchronize];
    
    /**右侧箭头*/
    [self addImaViewWithFrame:CGRectMake(MYScreenW - 30, _ageLabel.y + 15, 12, 12)];
    
    [self addBtnWithFrame:CGRectMake(0, _ageLabel.y + 15, MYScreenW, 12) action:@selector(setupAge) target:self];
    
    /**第五行*/
    [self addLabelWithFrame:CGRectMake(MYMargin * 1.75, CGRectGetMaxY(_ageLabel.frame), 100, MYRowHeight) text:@"地址"];
    
    self.regionField = [self addFieldWithFrame:CGRectMake(MYMargin * 1.75, CGRectGetMaxY(_ageLabel.frame), self.view.width - MYMargin * 1.75 - kMargin, MYRowHeight) text:self.userModel.region];
    
    [MYUserDefaults setObject:self.regionField.text forKey:@"region"];
    [MYUserDefaults synchronize];
    
    /**第六行*/
    [self addLabelWithFrame:CGRectMake(MYMargin * 1.75, CGRectGetMaxY(_regionField.frame), MYScreenW * 0.2, MYRowHeight) text:@"联系电话"];
    
    self.phoneField = [self addFieldWithFrame:CGRectMake(self.view.width / 2, CGRectGetMaxY(_regionField.frame), self.view.width / 2 - MYMargin, MYRowHeight) text:self.userModel.phone];
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
//    self.phoneField.tag = 1;
    
    [MYUserDefaults setObject:self.phoneField.text forKey:@"phone"];
    [MYUserDefaults synchronize];
    
    /**第七行*/
    self.detailLabel = [self addLabelWithFrame:CGRectMake(MYMargin * 1.75, CGRectGetMaxY(_phoneField.frame), 60, MYRowHeight) text:@"详细资料"];
    [self addLabelWithFrame:CGRectMake(CGRectGetMaxX(self.detailLabel.frame), CGRectGetMaxY(_phoneField.frame), 200, MYRowHeight) text:@"(完成详细资料奖励双倍积分)"];
    
    /**右侧箭头*/
    [self addImaViewWithFrame:CGRectMake(MYScreenW - 30, CGRectGetMaxY(_phoneField.frame) + 15, 12, 12)];
    [self addBtnWithFrame:CGRectMake(0, self.detailLabel.y, MYScreenW, MYRowHeight) action:@selector(setupDetailView) target:self];
    
    /**第八行*/
    [self addLabelWithFrame:CGRectMake(MYMargin * 1.75, self.detailLabel.bottom, 70, MYRowHeight) text:@"我的推荐码"];
    
    if (self.number) {
        
        UILabel *label = [self addLabelWithFrame:CGRectMake(self.detailLabel.right + 20, CGRectGetMaxY(_phoneField.frame) + MYRowHeight, 200, MYRowHeight) text:[NSString stringWithFormat:@"(已有%d位好友可享受优惠)",self.number]];
        label.textColor = MYColor(193, 177, 122);
    }
    
    [self addLabelWithFrame:CGRectMake(self.view.width - 65 - kMargin, self.detailLabel.bottom, 65, MYRowHeight) text:[NSString stringWithFormat:@"1601%ld",(long)self.userModel.id]];

    /**第九行*/
    self.promoCodeLabel = [self addLabelWithFrame:CGRectMake(MYMargin * 1.75, self.detailLabel.bottom + MYRowHeight, 60, MYRowHeight) text:@"优惠码"];
    
    if (self.userModel.inviteNum) {
        [self addLabelWithFrame:CGRectMake(self.view.width - 50 - kMargin, self.detailLabel.bottom + MYRowHeight, 50, MYRowHeight) text:@"已绑定"];
    }else{
        self.promoCodeField = [self addFieldWithFrame:CGRectMake(MYMargin * 1.7, self.detailLabel.bottom + MYRowHeight, self.view.width - MYMargin * 1.8 - kMargin, MYRowHeight) text:nil];
        self.promoCodeField.placeholder = @"(绑定后不可修改)";
        self.promoCodeField.keyboardType = UIKeyboardTypeNumberPad;
        self.promoCodeField.tag = 2;
    }
    
    /**第十行*/
    UILabel *inviteLabel = [self addLabelWithFrame:CGRectMake(MYMargin * 1.75, self.promoCodeLabel.bottom, 60, MYRowHeight) text:@"[推荐码]"];
    [self addLabelWithFrame:CGRectMake(inviteLabel.right + 5, self.promoCodeLabel.bottom, MYScreenW - inviteLabel.right - MYMargin , MYRowHeight) text:@"好友注册时输入您的推荐码,可在护肤品专区享受更低价格"];
    
    [self addLabelWithFrame:CGRectMake(MYMargin * 1.75, self.promoCodeLabel.bottom + MYRowHeight, 60, MYRowHeight) text:@"[优惠码]"];
    self.desLabel = [self addLabelWithFrame:CGRectMake(inviteLabel.right + 5, self.promoCodeLabel.bottom + MYRowHeight, MYScreenW - inviteLabel.right - MYMargin, MYRowHeight) text:@"输入好友的推荐码,您可在护肤品专区享受更低价格。或者输入魔颜官方优惠码:160159"];
    
    [self setupSecond];
    
}

- (void)setupSecond
{
    [self addLabelWithFrame:CGRectMake(MYMargin * 1.75,self.desLabel.bottom + 10, 150, 30) text:@"人家这么看我哒"];
    self.attitudeArr = @[@"国色天香",@"千娇百媚",@"貌美如花",@"小家碧玉",@"大 方",@"优 雅",@"开 朗",@"贤 惠",@"率 真",@"温 柔",@"女 神",@"女汉子",@"高 贵",@"有品位",@"白富美",@"名 媛",@"国际范",@"高级白领",@"甜 美",@"时 尚",@"有修养",@"小 资",@"大男子主义",@"单身贵族",@"帅 气",@"英 俊",@"好老公",@"高大威猛",@"阳 光",@"男 神",@"高富帅",@"肌肉男",@"屌 丝",@"冷 酷",@"成 熟"];
    
    for (int i = 0; i < self.attitudeArr.count; i ++ ) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        btn.titleLabel.font = MianFont;
        
        int col = i % MaxCols;
        int row = i / MaxCols;
        btn.width = (self.view.width - 2 * MYMargin - 3 * kMargin) / 4;
        btn.height = 25;
        btn.x = MYMargin + col * (btn.width + kMargin);
        btn.y = self.desLabel.bottom + 45 + row *  (btn.height + kMargin);
        
        [btn setTitle:[self.attitudeArr objectAtIndex:i] forState:UIControlStateNormal];
        
        [btn setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"reporttop2"] forState:UIControlStateSelected];
        btn.tag = i;
        self.viewBtn = btn;
        [btn addTarget:self action:@selector(clickViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [self.viewsBtns addObject:btn];
    }
    NSArray *tempArr = [self.userModel.views componentsSeparatedByString:@","];
    
    for(int i = 0; i < self.attitudeArr.count; i ++){
        
        //containsObject 判断元素是否存在于数组中(根据两者的内存地址判断，相同：YES  不同：NO）
        if([tempArr containsObject:[self.attitudeArr objectAtIndex:i]]) {
            
            ((UIButton *)[self.viewsBtns objectAtIndex:i]).selected = YES;
            [self.viewsArr addObject:[self.attitudeArr objectAtIndex:i]];
            
        }
    }
    
    /**第二组*/
    UILabel *hopeLabel = [[UILabel alloc]init];
    hopeLabel.frame = CGRectMake(MYMargin * 1.75, CGRectGetMaxY(self.viewBtn.frame) + 10, 200, 30);
    hopeLabel.text = @"希望自己哪里变得更美";
    hopeLabel.textColor = titlecolor;
    hopeLabel.font = MianFont;
    [self.scrollView addSubview:hopeLabel];
    
    
    self.partTitles = @[@"额部",@"眉部",@"眼部",@"鼻部",@"唇部",@"面部",@"牙齿",@"毛发",@"抗衰",@"皮肤",@"身体"];
    for (int i = 0; i < self.partTitles.count; i ++ ) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = (self.view.width - 30) / (self.partTitles.count);
        int col = i % MaxCol;
        int row = i / MaxCol;
        btn.width = (self.view.width - 2 * MYMargin - (MaxCol - 1) * kMargin) / MaxCol;
        btn.x = MYMargin + col * (btn.width + kMargin);
        btn.y = CGRectGetMaxY(hopeLabel.frame) + 15 + row *  (btn.height + kMargin * 3.8)  ;
        btn.height = 25;
        
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = MianFont;
        [btn setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:[self.partTitles objectAtIndex:i] forState:UIControlStateNormal];
        btn.tag = i;
        self.hopeBtn = btn;
        [btn setBackgroundImage:[UIImage imageNamed:@"reporttop2"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickPartBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [self.hopesBtns addObject:btn];
        
    }
    
    NSArray *tempArr1 = [self.userModel.hopes componentsSeparatedByString:@","];
    
    for(int i = 0; i < self.partTitles.count; i ++){
        
        //containsObject 判断元素是否存在于数组中(根据两者的内存地址判断，相同：YES  不同：NO）
        if([tempArr1 containsObject:[self.partTitles objectAtIndex:i]]) {
            
            ((UIButton *)[self.hopesBtns objectAtIndex:i]).selected = YES;
            [self.hopesArr addObject:[self.partTitles objectAtIndex:i]];
            
        }
        
    }
    
}

/*
 @brief 详情
 */
- (void)setupDetailView
{
    MYInfoDetailViewController *detaliVC = [[MYInfoDetailViewController alloc] init];
    //    detaliVC.userModel = self.userModel;
    [self.navigationController pushViewController:detaliVC animated:YES];
    
}

- (void)clickIconBtn
{
    /**
     
     与导航栏类似，操作表单也支持三种风格 ：
     UIActionSheetStyleDefault              //默认风格：灰色背景上显示白色文字
     UIActionSheetStyleBlackTranslucent     //透明黑色背景，白色文字
     UIActionSheetStyleBlackOpaque          //纯黑背景，白色文字
     
     */
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"从相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
}

- (void)setupAge
{
    
    MYCalendarView *calendarView = [[MYCalendarView alloc] init];
    calendarView.delegate = self;
    [calendarView showInRect:CGRectMake(30, 150, MYScreenW - 60, 240)];
    
}

- (void)calendarView:(MYCalendarView *)canendarView datePick:(UIDatePicker *)datePick
{
    NSString *str = [NSString stringWithFormat:@"%@", datePick.date];
    self.ageLabel.text = [str substringToIndex:10];
}

//选择图片方式
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        //打开相机
        [self camera];
        
    }else if (buttonIndex == 1) {
        //打开相册
        [self picture];
        
    }
}

//打开相机
-(void)camera
{
    if (![UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]){
        
        [MBProgressHUD showError:@"模拟器无法打开相机"];
        return;
    }
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

//打开相册
-(void)picture
{
    if (![UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)])  return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 拿到拍完（或者是选择完）的图片
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imaView.image = [selectedImage circleImage];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imaView.image, 0.0001);
    
    if([imageData length] > 0){
        
        self.currentImageName = [imageData base64Encoding];
       
        [MYUserDefaults setObject:imageData forKey:@"data"];
        [MYUserDefaults synchronize];
        
    }
    
    // 右边发送按钮变亮
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    // 退出
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self setupStatusBar];
    
}

- (void)setupStatusBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self.regionField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.promoCodeField resignFirstResponder];

}



/**
 *  IOS键盘出现时视图上移
 *
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    if (textField.tag && self.scrollView.contentOffset.y < 110) {
        
        const int movementDistance = 110; // tweak as needed
        
        [UIView animateWithDuration:0.3f animations:^{
            
            int movement = (up ? -movementDistance : movementDistance);
            
            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

//选择性别
- (void)selectSex:(UIButton *)btn
{
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    self.sex =  btn.tag;

}

//人家咋么看我的
- (void)clickAttitude:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    
}

/*
 @brief 多个按钮的选中状态 ---------人家怎么看我的---------------
 */
- (void)clickViewBtn:(UIButton *)btn
{
    if (btn.selected) {
        
        btn.selected = NO;
        [self.viewsArr removeObject:[self.attitudeArr objectAtIndex:btn.tag]];
        
    }else{
        
        btn.selected = YES;
        [self.viewsArr addObject:[self.attitudeArr objectAtIndex:btn.tag]];
    }
    
    self.currentViews = [self.viewsArr componentsJoinedByString:@","];
    
}

/*
 @brief 多个按钮的选中状态 ---------希望自己哪里变得更美---------------
 */
- (void)clickPartBtn:(UIButton *)btn
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
 @brief btn
 */

- (UIButton *)addBtnWithFrame:(CGRect)frame action:(SEL)action target:(id)target
{
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = frame;
    btn.backgroundColor = [UIColor  clearColor];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];
    
    return btn;
    
}
/*
 @brief textField
 */

- (UITextField *)addFieldWithFrame:(CGRect)frame text:(NSString *)text
{
    UITextField *nameField = [[UITextField alloc] init];
    nameField.delegate = self;
    nameField.placeholder = @"点击可编辑";
    nameField.font = MianFont;
    nameField.text = text;
    nameField.textColor = subTitleColor;
    nameField.textAlignment = NSTextAlignmentRight;
    nameField.returnKeyType = UIReturnKeyDone;
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.frame = frame;
    [self.scrollView addSubview:nameField];
    
    return nameField;
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
    leftLabel.font = MianFont;
    leftLabel.numberOfLines = 0;
    [leftLabel setRowSpace:5];
    [self.scrollView addSubview:leftLabel];
    
    return leftLabel;
}

/*
 @brief 右侧箭头
 */
- (UIImageView *)addImaViewWithFrame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = frame;
    imageView.image = [UIImage imageNamed:@"common_icon_arrow"];
    [self.scrollView addSubview:imageView];
    return imageView;
}

@end
