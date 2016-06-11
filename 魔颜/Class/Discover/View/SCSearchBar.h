//
//  SCSearchBar.h
//  SCGoJD
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchdelegate <NSObject>

-(void)gotosearchdelegate:(NSString *)values;

@end


@interface SCSearchBar : UITextField<UITextFieldDelegate>
//typedef void(^searchblock)(NSString * searchstr);
//@property(copy,nonatomic) searchblock searchblock;

@property(weak,nonatomic) id  <searchdelegate> searchdelegate;


@end
