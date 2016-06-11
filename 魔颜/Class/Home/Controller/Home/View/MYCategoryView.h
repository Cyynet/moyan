//
//  WQCategoryView.h
//  魔颜
//
//  Created by 周文静 on 15/9/23.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

//部位
@protocol clickseationBtnaddVCDelegate <NSObject>

-(void)clickSeactionBtn;

@end
//医生
@protocol clickDoctorBtnDelegate <NSObject>

-(void)clickDoctorBtn;

@end
//医院
@protocol clickHospitalBtnDelegate <NSObject>

-(void)clickHosptialBtnaddVC;

@end
//商城
@protocol clickMallBtnDelegate <NSObject>

-(void)clickMallBtnaddVC;

@end

//特色
@protocol clickCharacterBtnDelegate <NSObject>

-(void)clickCharacterBtnaddVC;

@end


@interface MYCategoryView : UIView


@property(weak,nonatomic) id <clickseationBtnaddVCDelegate> Seactiondelegate;
@property(weak,nonatomic) id <clickDoctorBtnDelegate> Doctordelegate;
@property(weak,nonatomic) id <clickHospitalBtnDelegate> Hospitaldelegate;
@property(weak,nonatomic) id <clickMallBtnDelegate> Malldelegate;
@property(weak,nonatomic) id <clickCharacterBtnDelegate> Charaterdelegate;

@end
