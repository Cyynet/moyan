//
//  MYqianggouview.h
//  魔颜
//
//  Created by abc on 16/4/12.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYqianggoumodel.h"

@interface MYqianggouview : UIView

@property(strong,nonatomic) NSArray* model;

-(instancetype)initWithFrame:(CGRect)frame imagearr:(NSArray *)imagearr imagcount:(NSInteger)count urlarr:(NSArray*)urlarr type:(NSArray*) type;
@end
