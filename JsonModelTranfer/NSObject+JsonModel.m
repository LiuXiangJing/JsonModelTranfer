//
//  NSObject+JsonModel.m
//  JsonModelTranfer
//
//  Created by Tintin on 2017/1/16.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import "NSObject+JsonModel.h"
#import "JsonModelConst.h"
#import "NSObject+Property.h"
#import <objc/runtime.h>
#import "JMFoundation.h"
const NSInteger JsonModelTranferFailInvalidJsonArray = 1;
const NSInteger JsonModelTranferFailInvalidJSONDictionary = 2;

@implementation NSObject (JsonModel)
#pragma mark - json数组转Model数组
+ (NSArray *)jsonArrayModelWithJsonArray:(NSArray *)jsonArray error:(NSError *__autoreleasing *)error {
    if ([jsonArray isKindOfClass:[NSString class]] || [jsonArray isKindOfClass:[NSData class]]) {
        jsonArray = [jsonArray jsonObject];
    }
    if (error) {
        error = nil;
    }
    NSMutableArray * modelArray = [NSMutableArray array];
    if ([jsonArray isKindOfClass:[NSArray class]] && [jsonArray count] >0 ) {
        for (NSInteger index = 0; index < jsonArray.count; index++) {
            id jsonData = [jsonArray objectAtIndex:index];
            id jsonResult;
            if ([jsonData isKindOfClass:[NSArray class]]) {
                jsonResult = [self jsonArrayModelWithJsonArray:jsonData error:error];
            }else if([jsonData isKindOfClass:[NSDictionary class]]){
                jsonResult = [self jsonModelWithJsonModel:jsonData error:error];
            }
            if (jsonResult) {
                [modelArray addObject:jsonResult];
            }else{
                //这里只要有一个Model映射失败了就直接结束，以防后面还有其他Model映射失败之后错误就改变了。
                break;
            }
        }
    }else{
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:@"Json数据错误",
                                   NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"映射%@失败，因为Json数组是空的或者格式不是数组)",NSStringFromClass(self)],
                                   };
        *error = [NSError errorWithDomain:JsonModelErrorDomain code:JsonModelTranferFailInvalidJsonArray userInfo:userInfo];
    }
    return modelArray;
}
#pragma mark - json直接转Model
+ (instancetype)jsonModelWithJsonModel:(NSDictionary *)jsonObject error:(NSError *__autoreleasing *)error {
    if ([jsonObject isKindOfClass:[NSString class]] || [jsonObject isKindOfClass:[NSData class]]) {
        jsonObject = [jsonObject jsonObject];
    }
    if (jsonObject && [jsonObject isKindOfClass:[NSDictionary class]]) {
        return [[[self alloc] init] jsonModelWithDictionary:jsonObject error:error];
        
    }else{
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:@"Json数据错误",
                                   NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"映射%@失败，因为Json字典是空的或者格式不是字典",NSStringFromClass(self)],
                                   };
        *error = [NSError errorWithDomain:JsonModelErrorDomain code:JsonModelTranferFailInvalidJSONDictionary userInfo:userInfo];
    }
    return [[self alloc]init];
}
#pragma mark - 给Model赋值。核心么算？？
- (instancetype)jsonModelWithDictionary:(NSDictionary *)jsonObject error:(NSError *__autoreleasing *)error {
    
    Class class = [self class];
    NSDictionary * replaceDic;
    if ([class respondsToSelector:@selector(jsonReplacedKeysFromDictionary)]) {
        replaceDic = [class performSelector:@selector(jsonReplacedKeysFromDictionary)];
    }
    NSDictionary * jsonDic;
    if ([class respondsToSelector:@selector(jsonModelFromArray)]) {
        jsonDic = [class performSelector:@selector(jsonModelFromArray)];
    }
    [class enumerateProperties:^(JMProperty *property, BOOL *stop) {
        @try {
            id propertyValue;
            BOOL isReplaceProperty = NO;
            if (replaceDic && replaceDic.allKeys.count > 0) {
                if ([[replaceDic allKeys] containsObject:property.propertyName]) {
                    property.replaceName = replaceDic[property.propertyName];
                    isReplaceProperty = YES;
                }
            }
            if ([[jsonObject allKeys] containsObject:property.propertyName]) {
                propertyValue = jsonObject[property.propertyName];
            }else if (property.replaceName && [[jsonObject allKeys] containsObject:property.replaceName]){
                propertyValue = jsonObject[property.replaceName];
            }
            
            if (propertyValue && [propertyValue isKindOfClass:[NSArray class]]) {
                if (jsonDic && jsonDic.allKeys.count > 0) {
                    if (isReplaceProperty && [[jsonDic allKeys] containsObject:property.replaceName]) {
                        Class subClass =  jsonDic[property.replaceName];
                        propertyValue = [subClass jsonArrayModelWithJsonArray:propertyValue error:error];
                    }else if ([[jsonDic allKeys] containsObject:property.propertyName]){
                        Class subClass = jsonDic[property.propertyName];
                        propertyValue = [subClass jsonArrayModelWithJsonArray:propertyValue error:error];
                    }
                }
            }else if (propertyValue && [propertyValue isKindOfClass:[NSDictionary class]]){
                Class class = NSClassFromString(property.propertyType);
                NSError * error;
                propertyValue = [class jsonModelWithJsonModel:propertyValue error:&error];
            }
            if (propertyValue) {
                [self setValue:propertyValue forKey:property.propertyName];
            }

        } @catch (NSException *exception) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey:@"映射失败",
                                       NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"映射%@失败，因为%@",NSStringFromClass(class),exception.reason],
                                       };
            *error = [NSError errorWithDomain:JsonModelErrorDomain code:1 userInfo:userInfo];
        }
       
    }];
    return self;
}
#pragma mark - model转化成字典
- (NSDictionary *)dictionaryValue {
    NSMutableDictionary * keyValues = [NSMutableDictionary dictionary];
    [[self class] enumerateProperties:^(JMProperty *property, BOOL *stop) {
        id value = [self valueForKey:property.propertyName];
        switch (property.keyType) {
            case JMPropertyTypeModel: {
                NSDictionary * dic = [value dictionaryValue];
                if (dic) {
                    [keyValues setObject:dic forKey:property.propertyName];
                }
                break;
            }
            case JMPropertyTypeArray: {
                if ([value count]>0) {
                    NSArray *arrayValue = value;
                    id firstObject = [arrayValue firstObject];
                    if ([JMFoundation isClassFromFoundation:[firstObject class]]) {
                        if (arrayValue) {
                            [keyValues setObject:arrayValue forKey:property.propertyName];
                        }
                    }else{
                        NSMutableArray * rempArray  = [NSMutableArray arrayWithCapacity:arrayValue.count];
                        for (NSInteger index = 0; index < arrayValue.count; index++) {
                            id mdoelValue = [arrayValue objectAtIndex:index];
                             NSDictionary * tempDic = [mdoelValue dictionaryValue];
                            if (tempDic) {
                                [rempArray addObject:tempDic];
                            }
                        }
                        [keyValues setObject:rempArray forKey:property.propertyName];
                    }
                }
                break;
            }
            case JMPropertyTypeNumber:
            case JMPropertyTypeBOOL:
            case JMPropertyTypeString: {
                if (value) {
                    [keyValues setObject:value forKey:property.propertyName];
                }
                break;
            }
            default:
                break;
        }
    }];
    return keyValues;
}
#pragma mark - 私有方法
#pragma mark 要转换的数据先转换成字典或者数组
- (id)jsonObject {
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([self isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    if ([self isKindOfClass:[NSArray class]]||[self isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    return self.dictionaryValue;
}




@end
