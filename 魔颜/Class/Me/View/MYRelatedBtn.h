//
//  MYRelatedBtn.h
//  魔颜
//
//  Created by Meiyue on 16/1/25.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , NSType) {
    
    MYDOCTORTYPE,
    MYDISCOUNTTYPE,

};

@interface MYRelatedBtn : UIButton

@property (nonatomic, assign) NSType type;
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *imageURL;


@end
