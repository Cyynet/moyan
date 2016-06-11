//
//  MYProjectViewController.m
//  魔颜
//
//  Created by Meiyue on 15/10/12.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYProjectViewController.h"

#import "MYDiscountListModel.h"
#import "MYProgectCell.h"
#import "MYPositionBtn.h"
#import "MYDescription.h"
#import "hospitaleListModel.h"
#import "MYHomeHospitalListCell.h"
#import "MYHomeDesignerTableViewController.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYHomeHospitalDeatilViewController.h"
#import "MYLoginViewController.h"
#import "MYHeader.h"

@interface MYProjectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *desModel;
@property (strong, nonatomic) MYDescription *desModels;
@property (weak, nonatomic) UIView *tableViewHead;

@property (strong, nonatomic) NSArray *hospitalList;

@property (nonatomic, assign) NSInteger page;

@property (strong, nonatomic) UITableView *tableView;

/*
 @brief 相关服务的总数和当前页
 */
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger num;


@property(strong,nonatomic) UILabel * pagelable;

@property(strong,nonatomic) UIButton * rightBtn;
@property(strong, nonatomic)NSString  *kefuid;

@property(strong,nonatomic) UIButton * topview;

@end

@implementation MYProjectViewController

- (NSArray *)hospitalList
{
    if (!_hospitalList) {
        _hospitalList = [NSArray array];
    }
    return _hospitalList;
}

- (NSMutableArray *)desModel
{
    if (!_desModel) {
        _desModel = [NSMutableArray array];
    }
    return _desModel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xeaeaea);
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden  = YES;
    [MobClick beginLogPageView:@"部位详情"];
    [self addbell];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.rightBtn.hidden = YES;
    [MobClick endLogPageView:@"部位详情"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self requestHeadData];

    [self requestTableViewData];
    [self refreshHospitalData];
    [self reloadMore];
    self.page = 1;

    self.tabBarController.tabBar.hidden = NO;
    

    
    [self addGotoTopView];
    
}
//置顶控件
-(void)addGotoTopView
{
    UIButton *topview = [[UIButton alloc]initWithFrame:CGRectMake(MYScreenW-60, MYScreenH - 170, 50, 50)];
    self.topview = topview;
    self.topview.hidden = YES;
    [self.view addSubview:topview];
    [topview setImage:[UIImage imageNamed:@"totop"] forState:UIControlStateNormal];
    [topview addTarget:self action:@selector(clickTopbtn1) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickTopbtn1
{
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView.contentOffset.y <= 600)
    {
        self.topview.hidden = YES;
        
    }else{
        self.topview.hidden = NO;
    }
}
/*
 @brief 显示当前页
 */
- (void)setupCurrentPage
{
    if (self.num) {
        
        self.pagelable.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.num,(long)self.count];

    }else{

        self.pagelable.text = [NSString stringWithFormat:@"1/%ld",(long)self.count];
        
    }
    
}
//页数
-(void)setpagea
{

    UIImageView *pageimage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 60, MYScreenH - 175, 50, 50)];
    [self.view addSubview:pageimage];
    pageimage.image = [UIImage imageNamed:@"page"];
    
    
    UILabel *pagelable = [[UILabel alloc]init];
    [pageimage addSubview:pagelable];
    self.pagelable = pagelable;
    pagelable.frame = pageimage.bounds;
    pagelable.layer.cornerRadius = 25;
    pagelable.layer.masksToBounds = YES;
    pagelable.backgroundColor = [UIColor clearColor];
    pagelable.font = [UIFont systemFontOfSize:13];
    pagelable.textColor = subTitleColor;
    pagelable.textAlignment = NSTextAlignmentCenter;
    

}

-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , self.view.width , self.view.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.height = MYScreenH - 70;
    self.tableView.tableFooterView.height = 1;
    self.tableView.tableHeaderView.height = 1;
    self.view.backgroundColor = [UIColor whiteColor];
 }

//刷新
- (void)refreshHospitalData
{
     self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestTableViewData)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header beginRefreshing];
    });
     
}

/*
 @brief 加载更多数据
 */
- (void)reloadMore
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf setupMoreData];
    }];
    
    self.tableView.footer.automaticallyChangeAlpha = YES;
    
}

//上拉加载更多
- (void)setupMoreData
{
    self.page ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"secProCode"] = @(self.id);
    
    [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@specialdeals/querySpecialdealsInfoList",kOuternet1] params:param success:^(id responseObject) {
        
        NSString *lastObject = responseObject[@"status"];
        if ([lastObject isEqualToString:@"-106"]) {
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.footer endRefreshingWithNoMoreData];

        }else{
            
            NSArray *newdeatildata = [MYDiscount objectArrayWithKeyValuesArray:responseObject[@"querySpecialdealsInfoList"]];
            
            [self.desModel  addObjectsFromArray:newdeatildata];
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 拿到当前的下拉刷新控件，结束刷新状态
                [self.tableView.footer endRefreshing];
            });
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.footer endRefreshing];
    }];
    
}
- (void)requestHeadData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = [MYUserDefaults objectForKey:@"btn"];
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@/project/queryProjectInfoById",kOuternet1] params:params success:^(id responseObject) {
        
        self.hospitalList = [hospitaleListModel objectArrayWithKeyValuesArray:responseObject[@"hospitalList"]];
        self.desModels = [MYDescription objectWithKeyValues:responseObject[@"queryProjectInfoById"]];
      
        [self setupTableViewHeader];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestTableViewData
{
#pragma mark 相关服务
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"secProCode"] = @(self.id);
    
    [MYHttpTool getWithUrl:[NSString stringWithFormat:@"%@specialdeals/querySpecialdealsInfoList",kOuternet1] params:params success:^(id responseObject) {
        
        NSInteger num = [[responseObject objectForKey:@"count"] intValue];
        
        self.count = num / 5 + 2;
            
//        [self setpagea];
//        [self setupCurrentPage];

        self.desModel = [MYDiscount objectArrayWithKeyValuesArray:responseObject[@"querySpecialdealsInfoList"]];
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer resetNoMoreData];
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    
    }];
    
}
/*
 @brief 组头
 */
- (void)setupTableViewHeader
{
    UIView *view = [[UIView alloc] init];
    self.tableViewHead = view;
    view.backgroundColor = [UIColor whiteColor];
    NSArray  *pictures = [self.desModels.detailPic componentsSeparatedByString:@","];
    view.frame = CGRectMake(0, 0, self.view.width, 420);
    self.tableView.tableHeaderView = view;
    
    
    for (int i = 0; i < pictures.count; i ++ ) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.width = (self.view.width - 3 * MYMargin) / 2;
        imageView.height = imageView.width * 0.91;
        
        // 列号
        int col = i % 2;
        // 行号
        int row = i / 2;
        imageView.x = MYMargin +  (imageView.width + MYMargin) * col;
        imageView.y = 10 + (imageView.height + MYMargin) * row;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,[pictures objectAtIndex:i]]] ];
        [view addSubview:imageView];
        
    }
    
    //项目详情
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(kMargin ,self.view.width - 1.8 * MYMargin, 100, 30);
    label.textColor = titlecolor;
    label.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
    label.text = @"部位详情";
    [view addSubview:label];
    
    if (pictures.count == 2) {
        label.frame = CGRectMake(kMargin ,self.view.width / 2 - MYMargin, 100, 30);
    }
    
    //描述
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:11.0];
    desLabel.numberOfLines = 0;    
    desLabel.text = self.desModels.des;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:desLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, desLabel.text.length)];
    desLabel.attributedText = attributedString;
    
    
    CGSize maxSize = CGSizeMake(self.view.width -  1.5 * kMargin, MAXFLOAT);
    CGSize desLabelSize = [desLabel sizeThatFits:maxSize];
    desLabel.textColor = subTitleColor;
    desLabel.frame = CGRectMake(kMargin ,CGRectGetMaxY(label.frame), desLabelSize.width, desLabelSize.height + MYMargin);
    [view addSubview:desLabel];
    
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width - 170) / 2, CGRectGetMaxY(desLabel.frame) + 5, 170, 30)];
//    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    btn.layer.borderWidth = 0.5;
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = 4;
//    btn.titleLabel.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 0);
//    [btn setTitle:@"预约美颜设计师" forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@"yuyue"] forState:UIControlStateNormal];
//    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(clickDesign) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:btn];
    
    [self.tableViewHead setNeedsLayout];
    [self.tableViewHead layoutIfNeeded];
    
    
    if (pictures.count == 2) {
        view.frame = CGRectMake(0, 0, self.view.width, CGRectGetMaxY(desLabel.frame) + kMargin);
        
    }else{
        
        view.frame = CGRectMake(0, 0, self.view.width, CGRectGetMaxY(desLabel.frame) + kMargin);
    }
    self.tableView.tableHeaderView = view;
    
}

- (void)clickDesign
{
    MYHomeDesignerTableViewController *mallVC = [[MYHomeDesignerTableViewController alloc]init];
    
    [self.navigationController pushViewController:mallVC animated:YES];
 
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.hospitalList.count;
    }else if (section == 2){
        return 1;
    }else{
        return self.desModel.count;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section == 0 || indexPath.section == 2) {
        
        static NSString *str = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }else
        {
            for (UIView *subview in cell.contentView.subviews)
            {
                [subview removeFromSuperview];
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            UIView *topView = [[UIView alloc] init];
            topView.backgroundColor = lineViewBackgroundColor;
            topView.frame = CGRectMake(0, 0, self.view.width, 0.5);
            [cell.contentView addSubview:topView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 0, 100, 30)];
            label.textColor = titlecolor;
            label.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
            label.text = @"相关医院";
            [cell.contentView addSubview:label];
            
            UIView *bottomView = [[UIView alloc] init];
            bottomView.backgroundColor = lineViewBackgroundColor;
            bottomView.frame = CGRectMake(0, 30, self.view.width, 0.5);
            [cell.contentView addSubview:bottomView];

        }else{
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 0, 100, 15)];
            label.textColor = titlecolor;
            label.font = [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0];
            label.text = @"相关服务";
            [cell.contentView addSubview:label];
            
            UIView *bottomView = [[UIView alloc] init];
            bottomView.backgroundColor = lineViewBackgroundColor;
            bottomView.frame = CGRectMake(0, 20, self.view.width, 0.5);
            [cell.contentView addSubview:bottomView];

        }
        return cell;

      }else if (indexPath.section ==1){

          MYHomeHospitalListCell *cell = [MYHomeHospitalListCell cellWithTableView:tableView indexPath:indexPath];
          hospitaleListModel *model = self.hospitalList[indexPath.row];
          cell.hospitalmodel = model;

          if (cell) {
              self.num = 0;
//              [self setupCurrentPage];

          }
          return cell;
       }else{
        
            MYProgectCell *cell = [MYProgectCell progectCell];
            cell.progect = self.desModel[indexPath.row];
               
        self.num = (indexPath.row) / 5 + 2;
           
//        [self setupCurrentPage];
        return cell;
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 30;
    }if (indexPath.section == 2) {
        return 15;
    }if (indexPath.section == 3) {
        return 120;
    }else{
        return 135;
    }
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        MYHomeHospitalDeatilViewController  *hospitaleDeatilVC = [[MYHomeHospitalDeatilViewController alloc]init];
        hospitaleListModel *hospitalemodel = self.hospitalList[indexPath.row];
        hospitaleDeatilVC.id = hospitalemodel.id;
        [self.navigationController pushViewController:hospitaleDeatilVC animated:YES];
        hospitaleDeatilVC.tag= 0;
        hospitaleDeatilVC.latitude = hospitalemodel.latitude;
        hospitaleDeatilVC.longitude = hospitalemodel.longitude;
        
        hospitaleDeatilVC.titleName = hospitalemodel.name;
        hospitaleDeatilVC.imageName = hospitalemodel.listPic;
        hospitaleDeatilVC.character = hospitalemodel.feature;

    }
    
    if (indexPath.section == 3) {
        
        MYHomeHospitalDeatilViewController *discountVC = [[MYHomeHospitalDeatilViewController alloc]init];
        MYDiscount *progect = self.desModel[indexPath.row];
        discountVC.id = progect.id;
        discountVC.tag = 1;

        [self.navigationController pushViewController:discountVC animated:YES];    }

}


-(void)addbell
{
    UIButton *rightBtn = [[UIButton alloc]init];
    self.rightBtn =rightBtn;
    rightBtn.frame = CGRectMake(MYScreenW -66, 15, 50, 50);
    [rightBtn setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rightBtn addTarget:self action:@selector(clickBell) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:rightBtn];
    
}

//小铃铛
-(void)clickBell
{
}



@end
