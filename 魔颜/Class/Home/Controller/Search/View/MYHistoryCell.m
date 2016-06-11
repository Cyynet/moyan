
//  Created by MacBook on 15/7/17.
//  Copyright (c) 2015年 abc. All rights reserved.
//  搜索历史tableView的cell,每次操作需要持久化存储数据

#import "MYHistoryCell.h"

@interface MYHistoryCell ()

//历史搜索记录的文件路径
#define MYSearchHistoryPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hisDatas.data"]

/** 记录自己是哪个数据 */
@property (nonatomic, weak) NSIndexPath *indexPath;
/** 记录模型数据 */
@property (nonatomic, weak) NSMutableArray *hisDatas;
/** 记录tableView */
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation MYHistoryCell

+ (instancetype)historyCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath atNSMutableArr:(NSMutableArray *)datas
{
    static NSString *identifier = @"historyCell";
    MYHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
          cell = [[MYHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = MYFont(13);
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    cell.tableView = tableView;
    cell.hisDatas = datas;
    cell.indexPath = indexPath;
    
    return cell;
}



@end
