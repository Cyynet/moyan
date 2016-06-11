//
//  MYTieziRelatedView.h
//  魔颜
//
//  Created by Meiyue on 16/1/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CyyBlock)(NSInteger type,NSString *id,NSString *name,NSString *imageURL);

@interface MYTieziRelatedView : UIView

@property (copy, nonatomic) CyyBlock myBlock;

@property (strong, nonatomic) NSArray *doctorItem;
@property (strong, nonatomic) NSArray *specialItem;


@end
