//
//  MYCollectionLikeCell.h
//  魔颜
//
//  Created by Meiyue on 16/4/25.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYServiceLike.h"
#import "MYHosSpe.h"
#import "MYOwnSpe.h"

@interface MYCollectionLikeCell : UICollectionViewCell

/** <#注释#> */
@property (strong, nonatomic) MYServiceLike *serviceLike;

//@property(strong,nonatomic) MYHosSpe * myhosSpe;
//
//@property(strong,nonatomic) MYOwnSpe * ownSpe;

@property(strong,nonatomic) UIView * line;
@end
