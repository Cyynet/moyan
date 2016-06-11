//
//  MYCollectionViewCell.h
//  魔颜
//
//  Created by Meiyue on 16/1/11.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSalonModel.h"


@interface MYCollectionViewCell : UICollectionViewCell

/**大图片*/
@property (weak, nonatomic) UIImageView *imagView;

@property (strong, nonatomic) MYSalonModel *salonMode;


@end
