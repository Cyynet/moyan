//
//  MYInfoDetailViewController.m
//  魔颜
//
//  Created by Meiyue on 15/9/30.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYInfoDetailViewController.h"
#import "UILabel+Extension.h"
#import "MYHeader.h"
#define MaxCols 4


@interface MYInfoDetailViewController ()

@property (strong, nonatomic) NSMutableArray *incomeBtns;
@property (strong, nonatomic) NSArray *incomeTitles;
@property (weak, nonatomic) UIButton *incomeBtn;
@property (copy, nonatomic) NSString *currentIncome;

@property (strong, nonatomic) NSMutableArray *favoriteViews;
@property (strong, nonatomic) NSMutableArray *favoriteBtns;
@property (strong, nonatomic) NSArray *favoriteTitles;
@property (weak, nonatomic) UIButton *favoriteBtn;
@property (copy, nonatomic) NSString *currentFavorite;

@property (strong, nonatomic) NSMutableArray *carViews;
@property (strong, nonatomic) NSMutableArray *carBtns;
@property (strong, nonatomic) NSArray *carTitles;
@property (weak, nonatomic) UIButton *carBtn;
@property (copy, nonatomic) NSString *currentCar;

@property (strong, nonatomic) NSMutableArray *familyBtns;
@property (strong, nonatomic) NSArray *familyTitles;
@property (weak, nonatomic) UIButton *familyBtn;
@property (copy, nonatomic) NSString *currentFamily;

@property (weak, nonatomic) UIButton *lastBtn;

@property (weak, nonatomic) UIButton *lastBtn1;

@property (strong, nonatomic) MYUserModel *userModel;

@end

@implementation MYInfoDetailViewController

- (NSMutableArray *)incomeBtns
{
    if (!_incomeBtns) {
        _incomeBtns = [NSMutableArray array];
    }
    return _incomeBtns;
}

- (NSMutableArray *)familyBtns
{
    if (!_familyBtns) {
        _familyBtns = [NSMutableArray array];
    }
    return _familyBtns;
}

- (NSMutableArray *)favoriteViews
{
    if (!_favoriteViews) {
        _favoriteViews = [NSMutableArray array];
    }
    return _favoriteViews;
}

- (NSMutableArray *)favoriteBtns
{
    if (!_favoriteBtns) {
        _favoriteBtns = [NSMutableArray array];
    }
    return _favoriteBtns;
}

- (NSMutableArray *)carViews
{
    if (!_carViews) {
        _carViews = [NSMutableArray array];
    }
    return _carViews;
}
- (NSMutableArray *)carBtns
{
    if (!_carBtns) {
        _carBtns = [NSMutableArray array];
    }
    return _carBtns;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requsetPersonalMessage];

    self.title = @"详细资料";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}

/*
 @brief 保存个人详细数据
 */
- (void)save
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [MYUserDefaults objectForKey:@"id"];
    params[@"signature"] = [MYStringFilterTool getSignature];
    params[@"msecs"] = [MYUserDefaults objectForKey:@"time"];
    params[@"income"] = self.currentIncome;
    params[@"interests"] = self.currentFavorite;
    params[@"cars"] = self.currentCar;
    params[@"family"] = self.currentFamily;
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@user/editUser",kOuternet1] params:params success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            [UIView animateWithDuration:0.5 animations:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
//            [UIView animateWithDuration:0.3 animations:^{
//                [MBProgressHUD showError:@"提交失败"];
//            }];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    [MYUserDefaults setObject:self.currentIncome forKey:@"income"];
    [MYUserDefaults setObject:self.currentFamily forKey:@"family"];
    [MYUserDefaults setObject:self.currentFavorite forKey:@"interests"];
    [MYUserDefaults setObject:self.currentCar forKey:@"cars"];
    
    [MYUserDefaults synchronize];
    
    
    //返回
    [self.navigationController popViewControllerAnimated:YES];
    
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
        
        [self setupIncome];
        [self setupFavorite];
        [self setCar];
        [self setupFamily];
        
        [self.view layoutIfNeeded];
    } failure:^(NSError *error) {
    }];
}


- (void)setupIncome
{
    UILabel *incomeLabel = [[UILabel alloc] init];
    incomeLabel.frame =  CGRectMake(20, 74, 100, 20);
    incomeLabel.text = @"家庭年收入";
    incomeLabel.font = leftFont;
    incomeLabel.textColor = titlecolor;
    [self.view addSubview:incomeLabel];
    
    self.incomeTitles = @[@"8-15万元",@"15-30万元",@"30-100万元",@"100万元以上"];
    
    for (int i = 0; i < self.incomeTitles.count; i ++ ) {
        
        UIButton *btn = [[UIButton alloc] init];
        //         btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        btn.titleLabel.font = leftFont;
        btn.frame = CGRectMake(self.view.width * i / 4, CGRectGetMaxY(incomeLabel.frame), self.view.width  / 4, 30);
        [btn setTitle:[self.incomeTitles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickIncomeBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.incomeBtn = btn;
        [self.incomeBtns addObject:btn];
        
        btn.tag = i;
        
        [self.view addSubview:btn];
    }
    
    
    NSArray *tempArr = [self.userModel.income componentsSeparatedByString:@","];
    for(int i = 0; i < self.incomeTitles.count; i ++){
        
        //containsObject 判断元素是否存在于数组中(根据两者的内存地址判断，相同：YES  不同：NO）
        if([tempArr containsObject:[self.incomeTitles objectAtIndex:i]]) {
            
            ((UIButton *)[self.incomeBtns objectAtIndex:i]).selected = YES;
            self.lastBtn = (UIButton *)[self.incomeBtns objectAtIndex:i];
            
        }
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame =  CGRectMake(0, CGRectGetMaxY(self.incomeBtn.frame), self.view.width, 0.5);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
}

- (void)setupFavorite
{
    UILabel *incomeLabel = [[UILabel alloc] init];
    incomeLabel.frame =  CGRectMake(20, 130, 100, 20);
    incomeLabel.text = @"兴趣爱好";
    incomeLabel.textColor = titlecolor;
    incomeLabel.font = leftFont;
    [self.view addSubview:incomeLabel];
    
    self.favoriteTitles = @[@"旅游",@"看电影",@"跳舞",@"唱歌",@"瑜伽",@"高尔夫",@"滑雪",@"潜水",@"摄影",@"沙滩浴",@"骑马",@"极限运动",@"网球",@"美容",@"购物",@"其他"];
    
    for (int i = 0; i < self.favoriteTitles.count; i ++ ) {
        
        UIButton *btn = [[UIButton alloc] init];
        //        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        btn.titleLabel.font = leftFont;
        
        int col = i % MaxCols;
        int row = i / MaxCols;
        btn.width = self.view.width / 4;
        btn.height = 30;
        btn.x = col * btn.width;
        btn.y = CGRectGetMaxY(incomeLabel.frame) + row *  btn.height;
        
        [btn setTitle:[self.favoriteTitles objectAtIndex:i] forState:UIControlStateNormal];
        
        [btn setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
        self.familyBtn = btn;
        [btn addTarget:self action:@selector(clickBtnFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [self.favoriteBtns addObject:btn];
        
        if (i == 11) {
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
        }else if (i == 13){
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, -27, 0, 0);
        }else if (i==15)
        {
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, -11, 0, 0);
        }
        btn.tag = i;
        
        [self.view addSubview:btn];
    }
    
    NSArray *tempArr = [self.userModel.interests componentsSeparatedByString:@","];
    
    for(int i = 0; i < self.favoriteTitles.count; i ++){
        
        //containsObject 判断元素是否存在于数组中(根据两者的内存地址判断，相同：YES  不同：NO）
        if([tempArr containsObject:[self.favoriteTitles objectAtIndex:i]]) {
            
            ((UIButton *)[self.favoriteBtns objectAtIndex:i]).selected = YES;
            [self.favoriteViews addObject:[self.favoriteTitles objectAtIndex:i]];
        }
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame =  CGRectMake(0, CGRectGetMaxY(self.familyBtn.frame), self.view.width, 0.5);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
}

- (void)setCar
{
    UILabel *carLabel = [[UILabel alloc] init];
    carLabel.frame =  CGRectMake(20, 275, 100, 20);
    carLabel.text = @"驾驶车辆";
    carLabel.textColor = titlecolor;
    carLabel.font = leftFont;
    [self.view addSubview:carLabel];
    
    self.carTitles = @[@"奔驰",@"奥迪",@"宾利",@"路虎",@"捷豹",@"大众",@"尼桑",@"皇冠",@"本田",@"雷克萨斯",@"现代",@"起亚",@"途胜",@"伊兰特",@"其他"];
    
    for (int i = 0; i < self.carTitles.count; i ++ ) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        btn.titleLabel.font =leftFont;
        
        int col = i % MaxCols;
        int row = i / MaxCols;
        btn.width = self.view.width / 4;
        btn.height = 30;
        btn.x = col * btn.width;
        btn.y = CGRectGetMaxY(carLabel.frame) + row *  btn.height;
        
        [btn setTitle:[self.carTitles objectAtIndex:i] forState:UIControlStateNormal];
        
        [btn setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
        self.carBtn = btn;
        [btn addTarget:self action:@selector(clickBtnCar:) forControlEvents:UIControlEventTouchUpInside];
        [self.carBtns addObject:btn];
        
        if (i == 1) {
            
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
            
        }else if (i == 9){
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
        }else if (i==5)
        {
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, -24, 0, 0);
            
        }
        btn.tag = i;
        
        [self.view addSubview:btn];
        
    }
    
    NSArray *tempArr = [self.userModel.cars componentsSeparatedByString:@","];
    
    for(int i = 0; i < self.carTitles.count; i ++){
        
        //containsObject 判断元素是否存在于数组中(根据两者的内存地址判断，相同：YES  不同：NO）
        if([tempArr containsObject:[self.carTitles objectAtIndex:i]]) {
            
            ((UIButton *)[self.carBtns objectAtIndex:i]).selected = YES;
            [self.carViews addObject:[self.carTitles objectAtIndex:i]];
        }
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame =  CGRectMake(0, CGRectGetMaxY(self.carBtn.frame), self.view.width, 0.5);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
}

- (void)setupFamily
{
    
    UILabel *incomeLabel = [UILabel addLabelWithFrame:CGRectMake(20, 420, 100, 20) title:@"家庭成员" titleColor:titlecolor  font:leftFont];
    [self.view addSubview:incomeLabel];
    
    
    self.familyTitles = @[@"单身贵族",@"新婚夫妇",@"宝爸宝妈",@"其他"];
    
    for (int i = 0; i < self.familyTitles.count; i ++ ) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        btn.titleLabel.font = leftFont;
        btn.frame = CGRectMake(self.view.width * i / 4, CGRectGetMaxY(incomeLabel.frame), self.view.width / 4, 30);
        [btn setTitle:[self.familyTitles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:subTitleColor forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"r2"] forState:UIControlStateSelected];
        self.familyBtn = btn;
        [btn addTarget:self action:@selector(clickFamilyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.familyBtns addObject:btn];
        
        if (i == 1) {
            
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
        }
        
        btn.tag = i;
        
        [self.view addSubview:btn];
    }
    
    NSArray *tempArr = [self.userModel.family componentsSeparatedByString:@","];
    for(int i = 0; i < self.familyTitles.count; i ++){
        
        //containsObject 判断元素是否存在于数组中(根据两者的内存地址判断，相同：YES  不同：NO）
        if([tempArr containsObject:[self.familyTitles objectAtIndex:i]]) {
            
            ((UIButton *)[self.familyBtns objectAtIndex:i]).selected = YES;
            self.lastBtn1 = (UIButton *)[self.familyBtns objectAtIndex:i];
            
        }
    }
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame =  CGRectMake(0, CGRectGetMaxY(self.familyBtn.frame) + 5, self.view.width, 0.5);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
}

//单一选择状态
- (void)clickIncomeBtn:(UIButton *)btn
{
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    self.currentIncome = [self.incomeTitles objectAtIndex:btn.tag];
}

- (void)clickFamilyBtn:(UIButton *)btn
{
    self.lastBtn1.selected = NO;
    btn.selected = YES;
    self.lastBtn1 = btn;
    self.currentFamily = [self.familyTitles objectAtIndex:btn.tag];
    
}

//多个选择状态
- (void)clickBtnFavorite:(UIButton *)btn
{
    if (btn.selected) {
        
        btn.selected = NO;
        [self.favoriteViews removeObject:[self.favoriteTitles objectAtIndex:btn.tag]];
        
    }else{
        btn.selected = YES;
        [self.favoriteViews addObject:[self.favoriteTitles objectAtIndex:btn.tag]];
    }
    
    self.currentFavorite = [self.favoriteViews componentsJoinedByString:@","];
}

- (void)clickBtnCar:(UIButton *)btn
{
    if (btn.selected) {
        
        btn.selected = NO;
        [self.carViews removeObject:[self.carTitles objectAtIndex:btn.tag]];
        
    }else{
        
        btn.selected = YES;
        [self.carViews addObject:[self.carTitles objectAtIndex:btn.tag]];
    }
    
    self.currentCar = [self.carViews componentsJoinedByString:@","];
    
}


@end
