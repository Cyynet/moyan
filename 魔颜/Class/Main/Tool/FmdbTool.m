//
//  FmdbTool.m
//  魔颜
//
//  Created by abc on 16/2/29.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "FmdbTool.h"
#import "FMDatabase.h"
//#import "SBJson.h"
#import "JSONKit.h"

@implementation FmdbTool

{
    FMDatabase *db;
}
-(NSString*)createFMDBTable:(NSString *)type
{
    NSString *str;
    //1.获得数据库文件的路径
    NSString *doctorpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *filePath =  [doctorpath stringByAppendingPathComponent:@"doctor.sqlite"];
//    NSLog(@"-------路径----%@-------",filePath);
    //2.获得数据库
    db = [FMDatabase databaseWithPath:filePath];
    //3.打开数据库
    if ([db open]) {
        //4.创表
        BOOL result;
        if ([type isEqualToString:@"doctor"]) {
            
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_doctor (id integer PRIMARY KEY AUTOINCREMENT,doctordict blob NOT NULL,page_ID integer NOT NULL,datacount text)"];
            
        }else if([type isEqualToString:@"hospital"])
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_hospital (id integer PRIMARY KEY AUTOINCREMENT,doctordict blob NOT NULL,page_ID integer NOT NULL,datacount text )"];

        }else if([type isEqualToString:@"homelist"]){
        
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_homelist (id integer PRIMARY KEY AUTOINCREMENT,doctordict blob NOT NULL,page_ID integer,datacount text)"];

        }else if([type isEqualToString:@"tranform"]){
            
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_tranform (id integer PRIMARY KEY AUTOINCREMENT,doctordict blob NOT NULL,page_ID integer,datacount text)"];
            
        }else if ([type isEqualToString:@"tiezideatil"]){
        
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_tiezideatil (id integer PRIMARY KEY AUTOINCREMENT,diarybody text NOT NULL,spelist blob ,hospitallist blob,tiezi_ID integer NOT NULL,prisestatus integer NOT NULL,focusstatus integer NOT NULL,countsconments integer NOT NULL,diarycommentlist blob,praiseList blob)"];
//            主题文字 ／ 特惠信息 ／ 医院信息 ／ 帖子ID / 点赞状态 ／ 关注状态 ／ 评论数 ／ 评论数组 ／点赞头像数组

        }else if([type isEqualToString:@"videopic"])//首页
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_videopic (id integer PRIMARY KEY AUTOINCREMENT ,videoPath text NOT NULL ,vpath text NOT NULL)"];
            
        } else if([type isEqualToString:@"salonlist"])//美容院
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_salonlist (id integer PRIMARY KEY AUTOINCREMENT,salonarr blob NOT NULL,page integer NOT NULL,pagecount text)"];
        }else if([type isEqualToString:@"activelist"])//美容院活动
        {
         result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_activelist (id integer PRIMARY KEY AUTOINCREMENT,activelist blob NOT NULL)"];
        }else if([type isEqualToString:@"malldiscount"])//卖场中的特惠
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_malldiscount (id integer PRIMARY KEY AUTOINCREMENT,activelist blob NOT NULL)"];
            
        }else if([type isEqualToString:@"discount"])//特惠
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_discount (id integer PRIMARY KEY AUTOINCREMENT,activelist blob NOT NULL)"];
        }else if([type isEqualToString:@"diary"])//日常护肤
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_diary (id integer PRIMARY KEY AUTOINCREMENT,activelist blob NOT NULL)"];
        }else if([type isEqualToString:@"activesecond"])//生活美容
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_activesecond (id integer PRIMARY KEY AUTOINCREMENT,activelist blob NOT NULL, type text NOT NULL,page integer NOT NULL)"];
        }else if ([type isEqualToString:@"meirongfuwu"]) //去美容－->美容服务 1.1.2
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_meirongfuwusecond (id integer PRIMARY KEY AUTOINCREMENT,meirongAd,meirongfuwuqianggoulist blob NOT NULL,meirongfuwutoplist blob,meirongfuwuboomlist blob ,type text)"];
        }else if ([type isEqualToString:@"meirongyuan"]) //去美容－->美容院1.1.2
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_meirongyuan (id integer PRIMARY KEY AUTOINCREMENT,meirongfuwuqianggoulist blob,meirongfuwutoplist blob,meirongfuwuboomlist blob ,type text,page integer)"];
        }else if ([type isEqualToString:@"tiyan"]) //体验
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_tiyan (id integer PRIMARY KEY AUTOINCREMENT,banner blob,tiyanlist blob,type text,page integer)"];
        }else if ([type isEqualToString:@"discovergonglue"]) //  发现--攻略
        {
            result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_discovergonglue (id integer PRIMARY KEY AUTOINCREMENT,list blob,type text,page integer)"];
        }
        
        
        if (result) {
//            NSLog(@"====建表成功--------type=== %@",type);
            
            str = @"yes";
            
        }else
        {
//            NSLog(@"====建表失败");
            str = @"no";
        }
    }else {
        NSLog(@"faile to create a FMDB");
        str = @"no";
    }
    
    return str;
}

//插数据
-(void)addDataInsetTable:(NSArray *)doctorListArry page:(NSInteger)page datacount:(NSString*)datacount type:(NSString *)type
{
    if ([db open]) {
        
        NSString *pagestr = [NSString stringWithFormat:@"%ld",(long)page];
        NSError *err = nil;
        
        NSData *jsonData  = [NSJSONSerialization dataWithJSONObject:doctorListArry options:NSJSONWritingPrettyPrinted error:&err];
        
        NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if ([type isEqualToString:@"doctor"]) {
            
            [db executeUpdate:@"INSERT INTO t_doctor (doctordict,page_ID,datacount) VALUES (?,?,?);",jsonStr,pagestr,datacount];
            
        }else if([type isEqualToString:@"hospital"])
        {
            [db executeUpdate:@"INSERT INTO t_hospital (doctordict,page_ID,datacount) VALUES (?,?,?);",jsonStr,pagestr,datacount];
            
        }else if([type isEqualToString:@"homelist"])
        {
        
            [db executeUpdate:@"INSERT INTO t_homelist (doctordict,page_ID,datacount) VALUES (?,?,?);",jsonStr,pagestr,[NSNumber numberWithInt:10]];
            
        }else if([type isEqualToString:@"salonlist"]){
            
            [db executeUpdate:@"INSERT INTO t_salonlist (salonarr,page,pagecount) VALUES (?,?,?);",jsonStr,pagestr,datacount];
        }else if([type isEqualToString:@"activelist"])
        {
        
            [db executeUpdate:@"INSERT INTO t_activelist (activelist) VALUES (?);",jsonStr];

        }else if([type isEqualToString:@"tranform"])
        {
        
            [db executeUpdate:@"INSERT INTO t_tranform (doctordict,page_ID,datacount) VALUES (?,?,?);",jsonStr,pagestr,[NSNumber numberWithInt:10]];
        }else if([type isEqualToString:@"malldiscount"])
        {
            
            [db executeUpdate:@"INSERT INTO t_malldiscount (activelist) VALUES (?);",jsonStr];
            
        }else if([type isEqualToString:@"discount"])
        {
            [db executeUpdate:@"INSERT INTO t_discount (activelist) VALUES (?);",jsonStr];
        }else if([type isEqualToString:@"diary"])
        {
            [db executeUpdate:@"INSERT INTO t_diary (activelist) VALUES (?);",jsonStr];
        }else if([type isEqualToString:@"activesecond"])
        {
            [db executeUpdate:@"INSERT INTO t_activesecond (activelist,type,page) VALUES (?,?,?);",jsonStr,datacount,pagestr];
        }
        
        
    }
    
    
    [db close];

}

//查询大型数据
-(NSArray *)outdata:(NSString *)type
{
    NSArray *dataArr;
    
    NSMutableArray  *aaarr = [[NSMutableArray alloc]init];
    if ([db open]) {
    
        if ([type isEqualToString:@"doctor"]) {
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_doctor"];
            
            while (res.next) {
                
                NSString *s = [res stringForColumn:@"doctordict"];
                
                NSArray *aa = [s objectFromJSONString];
                
                [aaarr addObjectsFromArray:aa];
                dataArr = aaarr;
                
            }
            
        }
        else if([type isEqualToString:@"hospital"])
        {
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_hospital"];
            
            while (res.next) {
            
                NSString *s = [res stringForColumn:@"doctordict"];
                
                NSArray *aa = [s objectFromJSONString];
                
                [aaarr addObjectsFromArray:aa];
                dataArr = aaarr;
            }

        }
        else if([type isEqualToString:@"homelist"])
        {
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_homelist"];
            
            while (res.next) {
                
                NSString *s = [res stringForColumn:@"doctordict"];
                
                NSArray *aa = [s objectFromJSONString];
                
                [aaarr addObjectsFromArray:aa];
                dataArr = aaarr;
                
            }
        }
        else if([type isEqualToString:@"salonlist"])
        {
            
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_salonlist"];
            
            while (res.next) {
                
                NSString *s = [res stringForColumn:@"salonarr"];
                
                NSArray *aa = [s objectFromJSONString];
                
                [aaarr addObjectsFromArray:aa];
                dataArr = aaarr;
            }
            
        }
        else if([type isEqualToString:@"activelist"])
        {
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_activelist"];
            
            while (res.next) {
                
                NSString *s = [res stringForColumn:@"activelist"];
                
                NSArray *aa = [s objectFromJSONString];
                
                [aaarr addObjectsFromArray:aa];
                dataArr = aaarr;
            }
        }
        else if([type isEqualToString:@"tranform"])
        {
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_tranform"];
            
            while (res.next) {
                
                NSString *s = [res stringForColumn:@"doctordict"];
                
                NSArray *aa = [s objectFromJSONString];
                
                [aaarr addObjectsFromArray:aa];
                dataArr = aaarr;
            }
        }
        else if([type isEqualToString:@"malldiscount"])
        {
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_malldiscount"];
            
            while (res.next) {
                
                NSString *s = [res stringForColumn:@"activelist"];
                
                NSArray *aa = [s objectFromJSONString];
                
                [aaarr addObjectsFromArray:aa];
                dataArr = aaarr;
            }
        }
        else if([type isEqualToString:@"discount"])
        {
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_discount"];
            
            while (res.next) {
                
                NSString *s = [res stringForColumn:@"activelist"];
                
                NSArray *aa = [s objectFromJSONString];
                
                [aaarr addObjectsFromArray:aa];
                dataArr = aaarr;
            }
        }else if([type isEqualToString:@"diary"])
        {
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_diary"];
            
            while (res.next) {
                
                NSString *s = [res stringForColumn:@"activelist"];
                
                NSArray *aa = [s objectFromJSONString];
                
                [aaarr addObjectsFromArray:aa];
                dataArr = aaarr;
            }
        }else if([type isEqualToString:@"discovergonglue"]) //发现－－攻略
        {
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_discovergonglue"];
            
            while (res.next) {
                
                NSString *s = [res stringForColumn:@"list"];
                
                NSArray *aa = [s objectFromJSONString];
                
                [aaarr addObjectsFromArray:aa];
                dataArr = aaarr;
            }
        }

    }
    
    [db close];

    return dataArr;
}
//取出生活美容二级列表 按type筛查
-(NSArray *)outdataActive:(NSString *)type
{
    NSArray *activearr;
       NSMutableArray  *aaarr = [[NSMutableArray alloc]init];
    if ([db open]) {
        
    FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_activesecond WHERE type = ?",type];
    
    while (res.next) {
        
        NSString *s = [res stringForColumn:@"activelist"];
        
        NSArray *aa = [s objectFromJSONString];
        
        [aaarr addObjectsFromArray:aa];
        activearr = aaarr;
        }
    }
    [db close];
    return activearr;
}
//生活美容二级列表 按type筛查后删除
-(void)deleactiveseconddata:(NSString *)type
{
    if([db open])
    {
    NSString *deleteSql = [NSString stringWithFormat:@"delete from t_activesecond WHERE type = %@",type];

   [db executeUpdate:deleteSql];
    }
    [db close];
    
}
//取出当前页数 在该type时
-(NSString *)checkoutpage:(NSString *)type
{
    NSString *str;
    if ([db open]) {
    
            FMResultSet *res = [db executeQuery:@"SELECT * FROM t_activesecond where type = ?",type];
            
            while (res.next)
            {
                str = [res stringForColumn:@"page"];
        }
    }
    [db close];
    
    return str;
}

//取出总页数
-(NSArray *)chekOutData:(NSString *)type
{
    NSArray *pagearr;
    NSMutableArray *pagecount = [[NSMutableArray alloc]init];
    
    if ([db open]) {
        if ([type isEqualToString:@"doctor"]) {
            FMResultSet *res = [db executeQuery:@"SELECT * FROM t_doctor"];
            
            while (res.next) {
                
                NSString * datacount = [res stringForColumn:@"datacount"];
                
                [pagecount addObject:datacount];
                
                pagearr = pagecount;
                
            }
            
            
        }else if([type isEqualToString:@"hospital"])
        {
            FMResultSet *res = [db executeQuery:@"SELECT * FROM t_hospital"];
            
            while (res.next) {
                
                NSString * datacount = [res stringForColumn:@"datacount"];
                
                [pagecount addObject:datacount];
                
                pagearr = pagecount;
                
            }
        
        }
        else if([type isEqualToString:@"salonlist"])
        {
            FMResultSet *res = [db executeQuery:@"SELECT * FROM t_salonlist"];
            
            while (res.next) {
                
                NSString * datacount = [res stringForColumn:@"pagecount"];
                
                [pagecount addObject:datacount];
                
                pagearr = pagecount;
                
            }
            
        }
    }
    [db close];
    
    return pagearr;
}
#pragma mark-－拿到当前的page
//拿到当前的page
-(NSString *)chekoutcurrpagenum:(NSString *)type
{
    
    NSString *pagenum;
    if ([db open]) {
        
        if ([type isEqualToString:@"doctor"]) {
            FMResultSet *res = [db executeQuery:@"SELECT * FROM t_doctor"];
            
            while (res.next)
            {
                
                pagenum = [res stringForColumn:@"page_ID"];
                
            }
            
        }else if([type isEqualToString:@"hospital"])
        {
            FMResultSet *res = [db executeQuery:@"SELECT * FROM t_hospital"];
            
            while (res.next)
            {
                
                pagenum = [res stringForColumn:@"page_ID"];
                
            }

        }else if([type isEqualToString:@"homelist"])
        {
            FMResultSet *res = [db executeQuery:@"SELECT * FROM t_homelist"];
            
            while (res.next)
            {
                
                pagenum = [res stringForColumn:@"page_ID"];
                
            }

        }
        else if ([type isEqualToString:@"salonlist"])
        {
            FMResultSet *res = [db executeQuery:@"SELECT * FROM t_salonlist"];
            
            while (res.next)
            {
                
                pagenum = [res stringForColumn:@"page"];
                
            }


        }else if([type isEqualToString:@"tranform"])
            {
                FMResultSet *res = [db executeQuery:@"SELECT * FROM t_tranform"];
                
                while (res.next)
                {
                    pagenum = [res stringForColumn:@"page_ID"];
                    
                }

            }else if([type isEqualToString:@"meirongyuan"])
            {
                FMResultSet *res = [db executeQuery:@"SELECT * FROM t_meirongyuan"];
                
                while (res.next)
                {
                    pagenum = [res stringForColumn:@"page"];
                    
                }
                
            }else if ([type isEqualToString:@"tiyan"])
            {
                FMResultSet *res = [db executeQuery:@"SELECT * FROM t_tiyan"];
                
                while (res.next)
                {
                    pagenum = [res stringForColumn:@"page"];
                }
            }else if ([type isEqualToString:@"discovergonglue"])
            {
                FMResultSet *res = [db executeQuery:@"SELECT * FROM t_discovergonglue"];
                while (res.next)
                {
                    pagenum = [res stringForColumn:@"page"];
                    
                }
            }
        

    }
    [db close];
    
    return pagenum;
}

//删除数据
- (void)deleteData:(NSString *)type
{

    if ([db open]) {
        
        if ([type isEqualToString:@"doctor"]) {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_doctor"];
            [db executeUpdate:deleteSql];
            
        }else if([type isEqualToString:@"hospital"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_hospital"];
           [db executeUpdate:deleteSql];
          


        }else if([type isEqualToString:@"homelist"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_homelist"];
            [db executeUpdate:deleteSql];


        }else if([type isEqualToString:@"videopic"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_videopic"];
            [db executeUpdate:deleteSql];
      
        }else if([type isEqualToString:@"salonlist"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_salonlist"];
            [db executeUpdate:deleteSql];
         
        }
        else if([type isEqualToString:@"activelist"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_activelist"];
            [db executeUpdate:deleteSql];
            
        }else if([type isEqualToString:@"tranform"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_tranform"];
            [db executeUpdate:deleteSql];
        }else if([type isEqualToString:@"malldiscount"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_malldiscount"];
            [db executeUpdate:deleteSql];
        }else if([type isEqualToString:@"discount"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_discount"];
            [db executeUpdate:deleteSql];
        }else if([type isEqualToString:@"diary"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_diary"];
            [db executeUpdate:deleteSql];
        }else if([type isEqualToString:@"meirongfuwu"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_meirongfuwusecond"];
            [db executeUpdate:deleteSql];
        }else if([type isEqualToString:@"meirongyuan"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_meirongyuan"];
            [db executeUpdate:deleteSql];
        }else if([type isEqualToString:@"discovergonglue"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_discovergonglue"];
            [db executeUpdate:deleteSql];
        }else if([type isEqualToString:@"tiyan"])
        {
            NSString *deleteSql = [NSString stringWithFormat:@"delete from t_tiyan"];
            [db executeUpdate:deleteSql];
        }

    }
    
    [db close];
}



#pragma  mark--去美容 二级页面 美容服务
//插数据
-(void)addDataInsetTable:(NSDictionary *)dict  listArr1:(NSArray *)ListArry1 listArr2:(NSArray *)listArr2 listArr3:(NSArray *)listArr3 page:(NSInteger)page  type:(NSString *)type
{
    if ([db open]) {
        NSError *err = nil;
        NSString *jsonStr0;
        NSString *jsonStr1;
        NSString *jsonStr2;
        NSString *jsonStr3;
         NSString *pagestr = [NSString stringWithFormat:@"%ld",(long)page];
        
        if (dict != nil) {
            NSData *jsonData0  = [NSJSONSerialization dataWithJSONObject:ListArry1 options:NSJSONWritingPrettyPrinted error:&err];
            jsonStr0 = [[NSString alloc]initWithData:jsonData0 encoding:NSUTF8StringEncoding];
        }
        
        
        if (ListArry1 != nil) {
            NSData *jsonData1  = [NSJSONSerialization dataWithJSONObject:ListArry1 options:NSJSONWritingPrettyPrinted error:&err];
           jsonStr1 = [[NSString alloc]initWithData:jsonData1 encoding:NSUTF8StringEncoding];
        }
        
        if(listArr2 !=nil){
            NSData *jsonData2  = [NSJSONSerialization dataWithJSONObject:listArr2 options:NSJSONWritingPrettyPrinted error:&err];
            jsonStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        }
        if (listArr3 != nil) {
            
            NSData *jsonData3  = [NSJSONSerialization dataWithJSONObject:listArr3 options:NSJSONWritingPrettyPrinted error:&err];
            jsonStr3 = [[NSString alloc]initWithData:jsonData3 encoding:NSUTF8StringEncoding];
        }
        
        if ([type isEqualToString:@"meirongfuwu"])
        {
            
           BOOL s= [db executeUpdate:@"INSERT INTO t_meirongfuwusecond (meirongAd,meirongfuwuqianggoulist,meirongfuwutoplist,meirongfuwuboomlist,type) VALUES (?,?,?,?,?);",jsonStr0,jsonStr1,jsonStr2,jsonStr3,type];
            
            if (s) {
                NSLog(@"======");
            }else{
                NSLog(@"--------shibai");
            }
        }else if([type isEqualToString:@"meirongyuan"])
        {
            [db executeUpdate:@"INSERT INTO t_meirongyuan (meirongfuwutoplist,type,page) VALUES (?,?,?);",jsonStr2,type,pagestr];
        }else if ([type isEqualToString:@"tiyan"])
        {
         [db executeUpdate:@"INSERT INTO t_tiyan (banner,tiyanlist,type,page) VALUES (?,?,?,?);",jsonStr1,jsonStr2,type,pagestr];
//            if (s) {
//                NSLog(@"--cehegn-------");
//            }else{NSLog(@"----shibai=====");
//            }
        }else if([type isEqualToString:@"discovergonglue"])//发现-－ 攻略
        {
           [db executeUpdate:@"INSERT INTO t_discovergonglue (list,type,page) VALUES (?,?,?);",jsonStr1,type,pagestr];
        
//            if (s) {
//                NSLog(@"--cehegn-------");
//            }else{NSLog(@"----shibai=====");
//            }

            
        }
        
    }
    [db close];
}
#pragma  mark--去美容 二级页面 美容服务
//查询大型数据
-(NSMutableDictionary *)checkoutdata:(NSString *)type
{
    NSMutableDictionary *datadict = [NSMutableDictionary dictionary];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray  *qianggouarr = [[NSMutableArray alloc]init];
    NSMutableArray  *toparr = [[NSMutableArray alloc]init];
    NSMutableArray  *boomarr = [[NSMutableArray alloc]init];
    

    
    if ([db open]) {
        
        if ([type isEqualToString:@"meirongfuwu"]) {
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_meirongfuwusecond"];
            
            while (res.next)
            {
                
                NSString *ad = [res stringForColumn:@"meirongAd"];
                NSDictionary *dict = [ad objectFromJSONString];
                
                NSString *qianggoustr = [res stringForColumn:@"meirongfuwuqianggoulist"];
                NSArray *qianggou = [qianggoustr objectFromJSONString];
                [qianggouarr addObjectsFromArray:qianggou];
                
                NSString *topstr = [res stringForColumn:@"meirongfuwutoplist"];
                NSArray *top = [topstr objectFromJSONString];
                [toparr addObjectsFromArray:top];

                NSString *boomstr = [res stringForColumn:@"meirongfuwuboomlist"];
                NSArray *boom = [boomstr objectFromJSONString];
                [boomarr addObjectsFromArray:boom];

                [datadict setValue:dict forKey:@"meirongAd"];
                [datadict setValue:qianggouarr forKey:@"qianggou"];
                [datadict setValue:toparr forKey:@"toparr"];
                [datadict setValue:boomarr forKey:@"boomarr"];

            }
            
        }else  if ([type isEqualToString:@"meirongyuan"]) {
            
            
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_meirongyuan"];
            
            while (res.next)
            {
                NSString *topstr = [res stringForColumn:@"meirongfuwutoplist"];
                NSArray *top = [topstr objectFromJSONString];
                [toparr addObjectsFromArray:top];
                
                [datadict setValue:toparr forKey:@"toparr"];
                
            }
            
        }
        else if ([type isEqualToString:@"tiyan"])
        {
            NSMutableArray  *bannerarr = [[NSMutableArray alloc]init];
            NSMutableArray  *listarr = [[NSMutableArray alloc]init];
            
            FMResultSet  *res = [db executeQuery:@"SELECT * FROM t_tiyan"];
            
            while (res.next)
            {
                
                NSString *qianggoustr = [res stringForColumn:@"banner"];
                NSArray *qianggou = [qianggoustr objectFromJSONString];
                [bannerarr addObjectsFromArray:qianggou];
                
                NSString *topstr = [res stringForColumn:@"tiyanlist"];
                NSArray *top = [topstr objectFromJSONString];
                [listarr addObjectsFromArray:top];
            
                [datadict setValue:bannerarr forKey:@"banner"];
                [datadict setValue:listarr forKey:@"tiyanlist"];
                
            }

        }
    }

    [db close];

    return datadict;
}
@end
