//
//  MYPublicView.h
//  魔颜
//
//  Created by Meiyue on 16/5/12.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYPublicView : UIView

@property (strong, nonatomic) NSArray *pictures;

+(CGSize)sizeWithPicturesCount:(NSUInteger)count;

@end
