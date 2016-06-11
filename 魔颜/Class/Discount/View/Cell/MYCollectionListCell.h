//
//  MYCollectionListCell.h
//  魔颜
//
//  Created by Meiyue on 16/2/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSalonListModel.h"

@interface MYCollectionListCell : UICollectionViewCell

/**小图片*/
@property (weak, nonatomic) UIImageView *sImagView;
/**首页大标题*/
@property (weak, nonatomic) UILabel *titleLabel;
/**价格*/
@property (weak, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) MYSalonListModel *salonListMode;

@end
