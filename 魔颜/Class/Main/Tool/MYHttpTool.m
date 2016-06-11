//
//  JWHttpTool.m
//  河科院微博
//
//  Created by 👄 on 15/6/11.
//  Copyright (c) 2015年 sczy. All rights reserved.
//

#import "MYHttpTool.h"
#import "AFNetworking.h"

@implementation MYHttpTool

+(void)getWithUrl:(NSString *)url params:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];

    [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (success) {
            // 调用外面的block
            success(responseObject);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (failure) {
            failure(error);
        }
    }];
}

+(void)postWithUrl:(NSString *)url params:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];

    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        // 调用外面的block
        success(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        failure(error);
    }];
}

@end
