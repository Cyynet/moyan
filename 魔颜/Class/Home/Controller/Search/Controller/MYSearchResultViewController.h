//
//  MYSearchResultViewController.h
//  魔颜
//
//  Created by Meiyue on 15/10/13.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYSearchBar;

typedef void (^MyBlock)(NSString *name);
@interface MYSearchResultViewController : UIViewController

@property (strong, nonatomic) MYSearchBar *searchBar;

@property (nonatomic,copy) MyBlock myBlock;



@end
