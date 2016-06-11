//
//  MYDiaryCell.h
//  魔颜
//
//  Created by Meiyue on 16/4/12.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYDiary.h"

@interface MYDiaryCell : UITableViewCell

@property(strong,nonatomic) MYDiary * diarymode;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
