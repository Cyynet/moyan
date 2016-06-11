//
//  MYRegionViewController.m
//  魔颜
//
//  Created by 易汇金 on 15/10/4.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYRegionViewController.h"
#import "MYCityGroup.h"

#define MYRegionX MYScreenW * 0.048 //18
#define MYMarginY MYScreenH * 0.0225 //15
#define MYRegionFont [UIFont systemFontOfSize:13]
#define MYRegionColor  [UIColor grayColor]
#define MaxCols 3

@interface MYRegionViewController ()

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *cityGroups;

@end

@implementation MYRegionViewController

-(NSArray *)cityGroups
{
    if (!_cityGroups) {
        _cityGroups = [MYCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _cityGroups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"城市选择";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupHeader
{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, self.view.width, 70);
    self.tableView.tableHeaderView = headView;
    
    UILabel *locationCityLabel = [[UILabel alloc] init];
    locationCityLabel.frame = CGRectMake(MYRegionX, MYMarginY, 90, 15);
    locationCityLabel.font = MYFont(13);
    locationCityLabel.textColor = titlecolor;
    locationCityLabel.text = @"定位城市";
    [headView addSubview:locationCityLabel];
    
    UILabel *cureentCityLabel = [[UILabel alloc] init];
    cureentCityLabel.frame = CGRectMake(MYRegionX, CGRectGetMaxY(locationCityLabel.frame) + MYMarginY, 90, 20);
    cureentCityLabel.font = MYRegionFont;
    cureentCityLabel.textColor = [UIColor redColor];
    cureentCityLabel.text = self.currentCity;
    cureentCityLabel.textAlignment = NSTextAlignmentCenter;
    cureentCityLabel.layer.borderColor = [UIColor redColor].CGColor;
    cureentCityLabel.layer.borderWidth = 0.5;
    [headView addSubview:cureentCityLabel];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroups.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MYCityGroup *g = self.cityGroups[section];
    return g.cities.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.textLabel.font = MYFont(12);
    cell.textLabel.textColor = titlecolor;
    MYCityGroup *g = self.cityGroups[indexPath.section];
    cell.textLabel.text = g.cities[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 发通知给home
    MYCityGroup *cityGroup = self.cityGroups[indexPath.section];
  
    if (self.myBlock) {
        self.myBlock((NSString*)(cityGroup.cities[indexPath.row]));
    }
    [self.navigationController popViewControllerAnimated:YES];
    
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
