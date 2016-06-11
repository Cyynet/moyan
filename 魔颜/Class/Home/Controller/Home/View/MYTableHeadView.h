//
//  MYTableHeadView.h
//  魔颜
//
//  Created by Meiyue on 16/4/11.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYHomeMenuView.h"
#import "AdView.h"

@interface MYTableHeadView : UITableViewHeaderFooterView
/** banner图 */
@property (strong, nonatomic)  AdView * adView;

@property(strong,nonatomic) NSMutableArray * imageArr;

/** <#注释#> */
@property (strong, nonatomic) MYHomeMenuView *menuView;



@end
