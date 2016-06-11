//
//  MYTagTool.m
//  魔颜
//
//  Created by Meiyue on 16/4/15.
//  Copyright © 2016年 Meiyue. All rights reserved.
//
#import "MYTagTool.h"
#import "MYSortsModel.h"
#import "MYHeader.h"

static NSArray *_beauties;
static NSArray *_hospitals;
static NSArray *_owns;
static NSArray *_areas;
static NSMutableArray *_selectedBeautyNames;

#define MYSelectedBeautyNamesFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_beauty_names.plist"]

#define MYSelectedHospitalNamesFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_hospital_names.plist"]

#define MYSelectedOwnNamesFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selected_own_names.plist"]



@implementation MYTagTool

+(NSMutableArray *)selectedBeautyNames
{
    if (!_selectedBeautyNames) {
        _selectedBeautyNames = [NSKeyedUnarchiver unarchiveObjectWithFile:MYSelectedBeautyNamesFile];
        
        if (!_selectedBeautyNames) {
            _selectedBeautyNames = [NSMutableArray array];
        }
    }
    return _selectedBeautyNames;
}

/**
 *  美容
 */
+ (void)saveBeauty:(NSArray *)userInfo
{
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:MYSelectedBeautyNamesFile error:nil];
    //保存新数据
    [NSKeyedArchiver archiveRootObject:userInfo toFile:MYSelectedBeautyNamesFile];

}
+ (NSArray *)readBeautyInfo
{
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:MYSelectedBeautyNamesFile];
}

/**
 *  医美
 */
+ (void)saveHospital:(NSArray *)userInfo
{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:MYSelectedHospitalNamesFile];
    
}
+ (NSArray *)readHospitalInfo
{
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:MYSelectedHospitalNamesFile];
}


/**
 *  美购
 */
+ (void)saveOwn:(NSArray *)userInfo
{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:MYSelectedOwnNamesFile];
}
+ (NSArray *)readOwnInfo
{
     return  [NSKeyedUnarchiver unarchiveObjectWithFile:MYSelectedOwnNamesFile];
}


+(NSArray *)beauties
{
    if (!_beauties) {
        _beauties = [MYSortsModel objectArrayWithFilename:@"beauty.plist"];
    }
    return _beauties;
}

+(NSArray *)hospitals
{
    if (!_hospitals) {
        _hospitals = [MYSortsModel objectArrayWithFilename:@"hospital.plist"];
    }
    return _hospitals;
}


+ (NSArray *)owns
{
    if (_owns == nil) {
        _owns = [MYSortsModel objectArrayWithFilename:@"own.plist"];;
    }
    return _owns;
}
//体验里面的地区
+(NSArray *)areas
{
    if (_areas == nil) {
        _areas = [MYSortsModel objectArrayWithFilename:@"areas.plist"];;
    }
    return _areas;

}

+(NSArray *)arrayWithString:(NSString *)string{
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:string ofType:nil];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:plistPath];
    return array;
}



@end
