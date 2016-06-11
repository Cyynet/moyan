//
//  MYHomeHeadView.m
//  魔颜
//
//  Created by Meiyue on 16/4/12.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYHomeHeadSectionView.h"
#import "MYTagTool.h"
#import "MYSortsModel.h"
#import "MYHeader.h"
#define MaxCols 5

@interface MYHomeHeadSectionView ()

@property(weak, nonatomic) UIView *iconView;

/** 区分哪个组 */
@property (assign, nonatomic) NSInteger *section;

@property(strong,nonatomic) UIImageView * backimageView;

@property(strong,nonatomic) UIView * iconview;

/** 广告按钮(背景图片放广告) */
@property (weak, nonatomic) UIButton *adBtn;

/** 上一个按钮 */
@property (weak, nonatomic) UIButton *lastBtn;

/** 所有美容院数据 */
@property (strong, nonatomic) NSArray *allBeautyArray;

/** 所有美容院数据 */
@property (strong, nonatomic) NSArray *allHospitalArray;

/** 所有美容院数据 */
@property (strong, nonatomic) NSArray *allOwnArray;

@end

static CGFloat imageHeight = 0;

@implementation MYHomeHeadSectionView

//创建一个自定义的头部分组视图
+(instancetype)headerWithTableView:(UITableView *)tableView section:(NSInteger)section adView:(MYAdModel *)adModel
{
    
    //static NSString *indentifier = @"header";
    NSString *indentifier = [NSString stringWithFormat:@"header%ld%@",(long)section,adModel.id];
    
    //先到缓存池中去取数据
    MYHomeHeadSectionView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:indentifier];
    
    //如果没有，则自己创建
    if (headerview == nil) {
        headerview = [[MYHomeHeadSectionView alloc] initWithReuseIdentifier:indentifier section:section adView:adModel];
        //组头的背景色
        headerview.contentView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        
    }
    
    //返回一个头部视图
    return headerview;
}
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier section:(NSInteger )section adView:(MYAdModel *)adModel
{
    
    //初始化父类中的构造方法
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        if (adModel) {

            UIButton *adBtn = [[UIButton alloc] init];
            self.adBtn = adBtn;
            adBtn.tag = section;
            adBtn.frame = CGRectMake(0, 10, MYScreenW,MYScreenW / 3);
//            adBtn.contentMode = UIViewContentModeScaleAspectFit;
//            adBtn.clipsToBounds = YES;
       
      
            [adBtn addTarget:self action:@selector(clickAdBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:adBtn];
            
            SDWebImageManager *imageManager = [[SDWebImageManager alloc]init];
            [imageManager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet1,adModel.bannerPath]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error == nil) {
                    
                     MYMainGCD(^{
                         
                         [adBtn setBackgroundImage:image forState:UIControlStateNormal];
                         
//                         float a = image.size.width;
//                         float b = image.size.height;
//                         adBtn.frame = CGRectMake(0, 10, MYScreenW, MYScreenW * b / a);
//                         
//                         imageHeight = adBtn.height + kMargin;
     
                    });
                    
                }
                
            }];
        }
        
        // 3个颜色＋图片
        NSArray *jiahaoicon =@[@"粉色＋",@"黄色＋",@"蓝色＋"];
        NSArray *backimagearr = @[@"背景图－美容场.jpg",@"背景图－医美场.jpg",@"背景图－美购场.jpg"];
        NSArray *titleimagearr = @[@"美容专场－标题",@"医美专场－标题",@"美购专场－标题"];
        NSArray *btnbackcolor = @[@"fenbtnback",@"huangbtnback",@"lanbtnback"];


        UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, 10)];
        [self.contentView addSubview:topview];
        topview.backgroundColor = UIColorFromRGB(0xf7f7f7);
        
        UIImageView *backimageView = [[UIImageView alloc] init];
        self.backimageView = backimageView;
        backimageView.frame = CGRectMake(0, _adBtn.bottom + 10,MYScreenW, 155);
        backimageView.image = [UIImage imageNamed:[backimagearr objectAtIndex:section]];
        [self.contentView addSubview:backimageView];
        
        UIView *iconView = [[UIView alloc] init];
        self.iconView = iconView;
        iconView.backgroundColor = [UIColor whiteColor];
        iconView.frame = CGRectMake(kMargin/2, _adBtn.bottom + 32, MYScreenW - kMargin , 129);
        iconView.layer.cornerRadius = 2;
        iconView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:iconView];
        UIImageView *titleimage = [[UIImageView alloc]init];
        [self.iconView addSubview:titleimage];
        titleimage.image = [UIImage imageNamed:[titleimagearr objectAtIndex:section ]];
        titleimage.frame = CGRectMake(0 , 0, iconView.width, 48);
        
        NSArray *tempArray;
        if (section == 0) {
            if ([MYTagTool readBeautyInfo].count) {
                
                NSMutableArray *arr = [NSMutableArray array];
                NSArray *allArray = [MYTagTool arrayWithString:@"beauty.plist"];
                NSArray *cacheArray = [MYTagTool readBeautyInfo];
                
                for(int i = 0;i < allArray.count;i ++){
                    //containsObject 判断元素是否存在于数组中
                    if([cacheArray containsObject:allArray[i][@"title"]]) {
                        [arr addObject:allArray[i]];
                    }
                }
                tempArray = [MYSortsModel objectArrayWithKeyValuesArray:arr];
                
            }else{
                tempArray = [[MYTagTool beauties] subarrayWithRange:NSMakeRange(0, 5)];
            }
        }
        else if (section == 1){
            if ([MYTagTool readHospitalInfo].count) {

                NSMutableArray *arr = [NSMutableArray array];
                NSArray *allArray = [MYTagTool arrayWithString:@"hospital.plist"];//懒加载
                NSArray *cacheArray =  [MYTagTool readHospitalInfo];
                
                for(int i = 0;i < allArray.count;i ++){
                    //containsObject 判断元素是否存在于数组中
                    if([cacheArray containsObject:allArray[i][@"title"]]) {
                        [arr addObject:allArray[i]];
                    }
                }
                tempArray = [MYSortsModel objectArrayWithKeyValuesArray:arr];
            }else{
                tempArray = [[MYTagTool hospitals] subarrayWithRange:NSMakeRange(0, 5)];
            }
        }else{
            if ([MYTagTool readOwnInfo].count) {
               
                NSMutableArray *arr = [NSMutableArray array];
                NSArray *allArray = [MYTagTool arrayWithString:@"own.plist"];
                NSArray *cacheArray = [MYTagTool readOwnInfo];
                
                for(int i = 0;i < allArray.count;i ++){
                    //containsObject 判断元素是否存在于数组中
                    if([cacheArray containsObject:allArray[i][@"title"]]) {
                        [arr addObject:allArray[i]];
                    }
                }
                tempArray = [MYSortsModel objectArrayWithKeyValuesArray:arr];

            }else{
                tempArray = [[MYTagTool owns] subarrayWithRange:NSMakeRange(0, 5)];
            }
        }
        
        NSMutableArray *allArray = [NSMutableArray array];
        for (MYSortsModel *model in tempArray) {
            [allArray addObject:model.title];
        }
        
        if (allArray.count > 9) {
            allArray = (NSMutableArray *)[allArray subarrayWithRange:NSMakeRange(0, 9)];
        }
        self.showItems = allArray;
        
        UIView *line = [[UIView alloc]init];
        [iconView addSubview:line];
        line.backgroundColor = UIColorFromRGB(0xcccccc);
        line.frame = CGRectMake(kMargin, titleimage.bottom+1, iconView.width-kMargin*2, 0.5);
        line.alpha = 0.5;
        
        for (int i = 0; i < allArray.count + 1; i ++ ) {
            
            UIButton *tagBtn = [[UIButton alloc] init];
            tagBtn.backgroundColor = UIColorFromRGB(0xfafafa);
            
            int col = i % MaxCols;// 列号
            int row = i / MaxCols;
            tagBtn.width = (iconView.width - 6 * kMargin) / MaxCols;
            tagBtn.height = 25;
            tagBtn.x = kMargin + col * (tagBtn.width + kMargin);
            tagBtn.y =  titleimage.bottom +10+ row *  (tagBtn.height + kMargin);
            
            [tagBtn setTitleColor:titlecolor forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            tagBtn.titleLabel.font = MYFont(12);
            [tagBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [tagBtn setBackgroundImage:[UIImage imageNamed:[btnbackcolor objectAtIndex:section]] forState:UIControlStateSelected];
            
            if (i < allArray.count) {
                MYSortsModel *model = tempArray[i];
                tagBtn.tag = model.id;
                [tagBtn setTitle:model.title forState:UIControlStateNormal];
                
            }else{
                
                [tagBtn setImage:[UIImage imageNamed:[jiahaoicon objectAtIndex:section]] forState:UIControlStateNormal];
            }
            
            [self.iconView addSubview:tagBtn];

        }
    }
    return self;
}

- (void)clickBtn:(UIButton *)btn
{
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
     
    if (self.sectionBlock) {
        self.sectionBlock(self.showItems,btn);
    }
    
}

//+(CGFloat)heightWithView
//{
//    return imageHeight + 155;
//}

- (void)clickAdBtn:(UIButton *)btn
{
    
    [MYNotificationCenter postNotificationName:@"MYAdView" object:nil
                                      userInfo:@{@"MYAdTag" : @(btn.tag)}];
 
//    MYLog(@"点击了第几个广告%ld",(long)btn.tag);
    
}



@end
