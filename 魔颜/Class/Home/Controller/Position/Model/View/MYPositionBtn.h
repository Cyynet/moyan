//
//  MYPositionBtn.h
//  魔颜
//
//  Created by Meiyue on 15/10/19.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYItem.h"
@class MYPositionBtn;
@protocol MYPositionBtnDelegate <NSObject>

- (void)positionBtn:(MYPositionBtn *)positionBtn btn:(NSInteger)btn;
@end

@interface MYPositionBtn : UIButton

/**二级列表id*/
@property (nonatomic, assign) NSInteger secondCode;

@property (strong, nonatomic) MYItem *itme;
@property (weak, nonatomic) id<MYPositionBtnDelegate> delegate;


@end
