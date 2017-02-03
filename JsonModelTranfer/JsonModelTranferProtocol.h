//
//  JsonModelTranferProtocol.h
//  JsonModelTranfer
//
//  Created by Tintin on 2017/1/16.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JsonModelTranferProtocol <NSObject>

@optional
/**
 要替换的字段：key是Model的属性名，value是字典中的key

 @return @{@"model.propertyName":@"dictionary.key"};
 */
+ (NSDictionary *)jsonReplacedKeysFromDictionary;
/*
 数组中存放的字典
 +(NSDictionary *)jsonModelFromArray {
    return @{@"banks":[Model class],
          @"citys":[Model class]};
    }
 */
+ (NSDictionary *)jsonModelFromArray;
@end
