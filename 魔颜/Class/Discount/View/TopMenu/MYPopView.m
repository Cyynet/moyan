//
//  MYTopView.m
//  魔颜
//
//  Created by 易汇金 on 15/10/4.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYPopView.h"
#import "MYAreaNames.h"
#import "MYtradingModel.h"
#import "MYTagTool.h"
#import "MYSortsModel.h"

#define Duration 0.1

@interface MYPopView ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIButton *coverBtn;
@property (weak, nonatomic) UIButton *topBtn;
@property (weak, nonatomic) UITableView *popTableView;
@property (strong, nonatomic) UIView *contentView;

/** 商圈名字 */
@property (strong, nonatomic) NSArray *tradingNames;
@property (strong, nonatomic) NSArray *tradingIds;
/**
 *  一些参数
 */
@property (copy, nonatomic) NSString *areaId;
@property (copy, nonatomic) NSString *tradingId;
/** <#注释#> */
@property (strong, nonatomic) MYAreaNames *areaNames;

/** <#注释#> */
@property (nonatomic, assign) NSInteger indexPathZero;

@end

@implementation MYPopView

static NSString *str = @"cell";

+ (instancetype)popViewWithTopBtn:(UIButton *)topBtn
{
    return [[self alloc] initWithBtn:topBtn];
}

-(instancetype)initWithBtn:(UIButton *)topBtn
{
    if (self = [super init]) {
        
        UIButton *coverBtn = [[UIButton alloc]init];
        coverBtn.backgroundColor = [UIColor blackColor];
        coverBtn.alpha = 0.07;
        [coverBtn addTarget:self action:@selector(clickCover) forControlEvents:UIControlEventTouchUpInside];
        self.coverBtn = coverBtn;
        [self addSubview:coverBtn];
        
        //弹出视图
        UIView *contentView = [[UIView alloc]init];
        [self addSubview:contentView];
        self.contentView = contentView;
        
        self.topBtn = topBtn;
        
    }
    return self;
}
-(void)showInRect:(CGRect)rect
{
    //设置pop被指定的位置
    self.contentView.frame = rect;
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    if (self.tag) {
        self.frame = CGRectMake(0, 0, MYScreenW,MYScreenH);
    }else{
        self.frame = CGRectMake(0, 99, MYScreenW,MYScreenH);
    }

//    CGFloat width = MYScreenW / self.chooseArray.count;
    CGFloat width = MYScreenW;
    CGFloat count = self.showStyle ? 2 : 1;
    
    if (count == 2) {
        width = MYScreenW / 2;
    }
    
    for (int i = 0 ; i < count; i ++) {
        
        UITableView *popTableView = [[UITableView alloc] init];
        popTableView.frame = CGRectMake(i * width + 1, 0, width, self.contentView.height);
        popTableView.delegate = self;
        popTableView.dataSource = self;
        popTableView.tag = i;
        popTableView.backgroundColor = [UIColor whiteColor];
        popTableView.tableFooterView = [[UIView alloc]init];
        popTableView.showsVerticalScrollIndicator = NO;
        popTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.contentView addSubview:popTableView];
        self.popTableView = popTableView;
    }
    
    [window addSubview:self];

}

-(void)clickCover
{
    [UIView animateWithDuration:Duration animations:^{
        
        self.coverBtn.alpha = 0;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.showStyle == UITableViewShowStyleDouble) {
        
        if (tableView.tag == 0) {
            
            return ((NSArray *)[self.chooseArray objectAtIndex:self.topBtn.tag]).count + 1;
        }else{
            if (self.indexPathZero) {
                return self.tradingNames.count;
            }else{
                return self.areaNames.trading.count ? self.areaNames.trading.count + 1:0;
                
            }
    }
    }else{
         return ((NSArray *)[self.chooseArray objectAtIndex:self.topBtn.tag]).count;
    }
    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];

    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    if (self.showStyle == UITableViewShowStyleDouble) {
        //左边
        if (tableView.tag == 0)
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"不限地区";
            }
            else{
                MYAreaNames *areaNames = self.chooseArray[self.topBtn.tag][indexPath.row - 1];
                self.areaNames = areaNames;
                cell.textLabel.text = areaNames.areaName;
             }
            cell.backgroundColor = MYColor(240, 240, 240);
        }
        //右边
        if (tableView.tag)
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"全部商圈";
            }
            else{
                if (self.indexPathZero)
                {
                    cell.textLabel.text = self.tradingNames[indexPath.row];
                }else{
                    MYtradingModel *model = self.areaNames.trading[indexPath.row - 1];
                    cell.textLabel.text = model.tradingName;
                }
            }
            cell.backgroundColor = MYColor(255, 255, 255);
        }
        
    }
    else
    {
        cell.textLabel.text = [[self.chooseArray objectAtIndex:self.topBtn.tag] objectAtIndex:indexPath.row];
    }
    
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_card_middle_background"]];
    cell.textLabel.font = leftFont;
    cell.textLabel.textColor = subTitleColor;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showStyle == UITableViewShowStyleDouble)
    {
        if (tableView.tag == 0)
        {
            
            NSMutableArray *tradingName = [NSMutableArray arrayWithObject:@"全部商圈"];
            NSMutableArray *trandingId = [NSMutableArray array];
            if (indexPath.row == 0)
            {
                self.areaId = @"";
                self.tradingId = @"";
                
                for (MYAreaNames *areaNames in self.chooseArray[self.topBtn.tag])
                {
                    for (MYtradingModel *model in areaNames.trading)
                    {
                        [tradingName addObject:model.tradingName];
                        [trandingId  addObject:model.tradingId];
                    }
                }
                self.tradingIds = trandingId;
                self.indexPathZero = 1;
                
            }
            else
            {
                
                MYAreaNames *areaNames = self.chooseArray[self.topBtn.tag][indexPath.row - 1];
                self.areaNames = areaNames;
                self.areaId = areaNames.areaId;
      
                
                for (MYtradingModel *model in areaNames.trading)
                {
                    [tradingName addObject:model.tradingName];
                }
                
                MYLog(@"您点击了%@,它的areaId是%@",areaNames.areaName,areaNames.areaId);
            }
            self.tradingNames = tradingName;
            [self.popTableView reloadData];
            
        }
        else{
            
            if (self.indexPathZero) {
                if (indexPath.row == 0) {
                    self.areaId = @"";
                    self.tradingId = @"";
                }else{
                    self.tradingId = self.tradingIds[indexPath.row - 1];
                }
            }
            else{
                if (indexPath.row == 0) {
                    self.tradingId = @"";
                }else{
                    MYtradingModel *model = self.areaNames.trading[indexPath.row - 1];
                    self.tradingId = model.tradingId;
                }
            }
            MYLog(@"您点击的areaId是%@ tradingId是%@",self.areaId,self.tradingId);
            [MYNotificationCenter postNotificationName:@"MYSecondTitleChange" object:nil userInfo:@{@"MYTypeBtn" : self.topBtn,@"MYType" : self.areaId, @"MYTitle" : self.tradingId , @"MYTopTitle" : [tableView cellForRowAtIndexPath:indexPath].textLabel.text}];
            [UIView animateWithDuration:0.4 animations:^{
                [self removeFromSuperview];
            }];
         }
        
    }else{
        
        //取出特殊符号
        NSString *title;
        NSString *id = @"-1";
        NSString *name = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        title = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([self.type isEqualToString:@"tiyan"]) {
            
            if (self.topBtn.tag == 1) {
                
                if (indexPath.row) {
                    MYSortsModel *model = [MYTagTool beauties][indexPath.row - 1];
                    id = [NSString stringWithFormat:@"%ld",(long)model.id];
                }
                
            }
            if (self.topBtn.tag == 2){
            
                MYSortsModel *model = [MYTagTool areas][indexPath.row];
                id = [NSString stringWithFormat:@"%ld",(long)model.id];
            }
         
#pragma mark--体验
            [MYNotificationCenter postNotificationName:@"MYExperienceChange" object:nil userInfo:@{@"MYTypeBtn" : self.topBtn, @"MYTitle": id, @"MYTopTitle" : title}];
            [UIView animateWithDuration:0.4 animations:^{
                [self removeFromSuperview];
            }];
            
          }
        
        
#pragma mark--美容院
        [MYNotificationCenter postNotificationName:@"MYBeautyTitleChange" object:nil userInfo:@{@"MYTypeBtn" : self.topBtn, @"MYTitle" : @(indexPath.row) , @"MYTopTitle" : title}];
        [UIView animateWithDuration:0.4 animations:^{
            [self removeFromSuperview];
        }];

#pragma mark--医院
        [MYNotificationCenter postNotificationName:@"MYHospitalTitleChange" object:nil userInfo:@{@"MYTypeBtn" : self.topBtn, @"MYTitle" : @(indexPath.row ) , @"MYTopTitle" : title}];
        [UIView animateWithDuration:0.4 animations:^{
            [self removeFromSuperview];
        }];
        
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MYRowHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverBtn.frame = [UIScreen mainScreen].bounds;
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

@end
