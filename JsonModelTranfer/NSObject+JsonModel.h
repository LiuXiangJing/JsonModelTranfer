//
//  NSObject+JsonModel.h
//  JsonModelTranfer
//
//  Created by Tintin on 2017/1/16.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModelTranferProtocol.h"

/**
 Model映射的类，只要在BaseModel引进此类即可使用，不过这个一个简单的映射Moedel。仅支持映射BOOL、NSNumber、int float 、double、long、NSString、NSArray、Model等简单的数据类型。NSData、NSDate、NSURL等一律按NSStrring处理了
 */
@interface NSObject (JsonModel)<JsonModelTranferProtocol>

/**
 json数组数据转化成model数组

 @param jsonArray json数据，一个Array、或者JsonSring、或者JsonData
 @return 数组，里面存放Model
 */
+ (NSArray *)jsonArrayModelWithJsonArray:(NSArray *)jsonArray error:(NSError **)error;

/**
 json数据转换成Model

 @param jsonObject json数据,一个JsonDic、或者JsonSring、或者JsonData
 @return model
 */
+ (instancetype)jsonModelWithJsonModel:(NSDictionary *)jsonObject error:(NSError **)error;

/**
 model转化成字典
 */
- (NSDictionary *)dictionaryValue;
@end
