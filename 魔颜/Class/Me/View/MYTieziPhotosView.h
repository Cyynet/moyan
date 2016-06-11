//
//  MYTieziPhotosView.h
//  魔颜
//
//  Created by Meiyue on 15/10/27.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYTieziPhotosView : UIView

@property (strong, nonatomic) NSArray *pictures;

@property (strong, nonatomic) UIImageView *photoView;

+(CGSize)sizeWithItemsCount:(NSUInteger)count;


@end
