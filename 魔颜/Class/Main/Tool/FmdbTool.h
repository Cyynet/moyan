//
//  FmdbTool.h
//  魔颜
//
//  Created by abc on 16/2/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FmdbTool : NSObject

-(NSString*)createFMDBTable:(NSString *)type;
-(void)addDataInsetTable:(NSArray *)doctorListArry page:(NSInteger)id datacount:(NSString*)datacount type:(NSString *)type;
-(NSArray *)chekOutData:(NSString *)type;//页数
-(NSArray *)outdata:(NSString *)type;//大型数据


//拿到当前的page
-(NSString *)chekoutcurrpagenum:(NSString *)type;
- (void)deleteData:(NSString *)type;//删除表

//取出当前页数 在该type时
-(NSString *)checkoutpage:(NSString *)type;


//生活美容二级列表 按type筛查后删除
-(void)deleactiveseconddata:(NSString *)type;
//取出生活美容二级列表 按type筛查
-(NSArray *)outdataActive:(NSString *)type;




-(void)addDataInsetTable:(NSDictionary *)dict   listArr1:(NSArray *)ListArry1 listArr2:(NSArray *)listArr2 listArr3:(NSArray *)listArr3 page:(NSInteger)page  type:(NSString *)type;
-(NSMutableDictionary *)checkoutdata:(NSString *)type;




@end
