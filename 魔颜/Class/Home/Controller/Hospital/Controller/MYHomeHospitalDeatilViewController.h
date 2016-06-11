//
//  MYHomeHospitalDeatilViewController.h
//  魔颜
//
//  Created by abc on 15/11/2.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYHomeHospitalDeatilViewController : UIViewController

/**控制器来源*/
@property (nonatomic, assign) NSInteger tag;

/**医院id*/
@property (copy, nonatomic) NSString *id;

/**经度*/
@property(assign,nonatomic) double  latitude;

/**纬度*/
@property(assign,nonatomic) double  longitude;

/**分享的文字*/
@property (copy, nonatomic) NSString *titleName;

/**分享的图片*/
@property (copy, nonatomic) NSString *imageName;

/**医院特征*/
@property (copy, nonatomic) NSString *character;

/**banner图的链接地址 或者视频的链接地址   */
@property (nonatomic, copy) NSString *url;

@property(strong,nonatomic) NSString * classify; //卖场产品 自营和其他

@end
