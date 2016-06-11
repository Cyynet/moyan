//
//  JWHttpTool.h
//  河科院微博
//
//  Created by 👄 on 15/6/11.
//  Copyright (c) 2015年 sczy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYHttpTool : NSObject

+(void)getWithUrl:(NSString *)url params:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+(void)postWithUrl:(NSString *)url params:(NSDictionary *)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
