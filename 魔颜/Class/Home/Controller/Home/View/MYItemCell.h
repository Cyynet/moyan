//
//  MYItemCell.h
//  魔颜
//
//  Created by Meiyue on 16/4/12.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSalonSpe.h"
#import "MYHosSpe.h"
#import "MYOwnSpe.h"

typedef void(^MYBlock)(NSInteger tag,NSInteger id);

@interface MYItemCell : UIView

@property (copy, nonatomic) MYBlock  myBlock;
/** 美容模型 */
@property (strong, nonatomic) MYSalonSpe *salonArr;

/** 医美模型 */
@property (strong, nonatomic) MYHosSpe *hosArr;

/** 美购模型 */
@property (strong, nonatomic) MYOwnSpe *ownArr;

@property(strong,nonatomic) UILabel *discountPrice;

/** 视图上面放个按钮 */
@property (weak, nonatomic) UIButton *itemBtn;





@end
