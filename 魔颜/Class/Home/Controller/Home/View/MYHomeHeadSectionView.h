//
//  MYHomeHeadView.h
//  魔颜
//
//  Created by Meiyue on 16/4/12.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYAdModel.h"

typedef void(^MYSectionBlock)(NSArray *tagArr,UIButton *btn);

@interface MYHomeHeadSectionView : UITableViewHeaderFooterView


@property (retain, nonatomic) NSArray * showItems;

+(instancetype)headerWithTableView:(UITableView *)tableView section:(NSInteger)section adView:(MYAdModel *)adModel;

//+(CGFloat)heightWithView;

@property (copy, nonatomic) MYSectionBlock sectionBlock;

@end