//
//  MYSalonForFirstRowViewCell.h
//  魔颜
//
//  Created by abc on 16/4/26.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSalonForFirstRowViewCell : UITableViewCell

@property(strong,nonatomic) NSString * imageurl;
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
