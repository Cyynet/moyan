//
//  MYHomeDoctorDeatilView.h
//  魔颜
//
//  Created by 朱玉辉 on 15/10/1.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "doctordeatilListModel.h"
@protocol clickOrganizationcontentPushVc <NSObject>

-(void)organizationPushToVC ;

@end

@protocol doctordeatilHeight <NSObject>

-(void)toVcdoctordeatilHeight:(double)height;

@end

@interface MYHomeDoctorDeatilView : UIView

@property(assign,nonatomic) double doctordeatilscrollviewHight;
@property(weak,nonatomic) id <clickOrganizationcontentPushVc> organizationdelegate;

@property(weak,nonatomic) id <doctordeatilHeight> doctordeatilheigt;

@property(strong,nonatomic) doctordeatilListModel * doctordeatileModel;

@end
