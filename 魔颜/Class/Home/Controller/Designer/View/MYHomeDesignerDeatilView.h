//
//  MYHomeDesignerDeatilView.h
//  魔颜
//
//  Created by abc on 15/9/30.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "designerdeatilModel.h"
@protocol MYHomeDesignerScrollViewHightDelegate <NSObject>

-(void)designerScrollViewHight:(double)scrollviewhight;

@end
@interface MYHomeDesignerDeatilView : UIView

@property(assign,nonatomic) double scrollviewHight;

@property(weak,nonatomic) id <MYHomeDesignerScrollViewHightDelegate> ScrollViewhight;


@property(strong,nonatomic) designerdeatilModel * designerdeatilmodel;

@end
