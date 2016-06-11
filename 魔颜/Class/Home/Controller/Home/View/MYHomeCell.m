//
//  MYHomeCellTableViewCell.m
//  魔颜
//
//  Created by Meiyue on 16/4/12.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYHomeCell.h"
#import "UIImageView+Extension.h"
#define MaxCols 2
#define COUNT 4

@interface MYHomeCell ()

@property (strong, nonatomic) NSMutableArray *itemsArr;
/** 视图上面放个按钮 */
@property (strong, nonatomic) NSMutableArray *itemsBtn;

@end
@implementation MYHomeCell

- (NSMutableArray *)itemsArr
{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (NSMutableArray *)itemsBtn
{
    if (!_itemsBtn) {
        _itemsBtn = [NSMutableArray array];
    }
    return _itemsBtn;
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"Cell%ld%ld",(long)[indexPath section],(long)[indexPath row]];
    MYHomeCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID section:indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier section:(NSInteger) section
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for (int i = 0; i < COUNT; i ++) {
            
            MYItemCell *item = [[MYItemCell alloc] init];
            item.tag = section;
            item.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:item];
            [self.itemsArr addObject:item];    
            
            if (section == 0) {
//                item.discountPrice.textColor = MYRedColor;
                self.backgroundColor = UIColorFromRGB(0xfcf2fd);
            }else if(section == 1)
            {
//                item.discountPrice.textColor = MYYellowColor;
                self.backgroundColor = UIColorFromRGB(0xfcf9ea);

            }else if (section == 2)
            {
//                item.discountPrice.textColor = MYGreenColor;
                self.backgroundColor = UIColorFromRGB(0xdffffe);

            }
        }

    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
   for (int i = 0; i < COUNT; i ++) {
       
       MYItemCell *item = self.itemsArr[i];
       
       if (i >= items.count) {
           item.hidden = YES;
       }else{
           item.hidden = NO;
           item.itemBtn.tag = i;
           item.layer.cornerRadius =2;
           item.layer.masksToBounds = YES;
           
           if (self.tag == 0) {//美容
               item.salonArr = items[i];
           }else if (self.tag == 1){//医美
               item.hosArr = items[i];
           }else{//美购
               item.ownArr = items[i];
           }
       }
    }
    
//    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 5;
    CGFloat width = (MYScreenW - margin * (MaxCols + 1)) / MaxCols;
    CGFloat height = width *1.3;

    
    for (int i = 0; i < COUNT; i++) {

        MYItemCell *item = self.itemsArr[i];
        item.width = width;
        item.height = height;
        
        // 列号
        int col = i % MaxCols;
        
        // 行号
        int row = i / MaxCols;
        
        item.x = margin + col * (margin + width);
        item.y = margin + row * (margin + height);
        
    }
    
}



@end
