//
//  MYPositionView.h
//  魔颜
//
//  Created by Meiyue on 15/10/19.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPositionGroup.h"
#import "MYItem.h"
#import "MYPositionBtn.h"

@class MYPositionView;
@interface MYPositionView : UIView

// 里面是MYItem对象
@property (strong, nonatomic) NSArray *items;

/**二级列表id*/
@property (nonatomic, assign) NSInteger secondCode;

+(CGSize)sizeWithItemsCount:(NSUInteger)count;

@end
