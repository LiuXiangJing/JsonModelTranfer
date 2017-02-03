//
//  JMProperty.h
//  JsonModelTranfer
//
//  Created by Tintin on 2017/1/17.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    JMPropertyTypeModel = 0, //
    JMPropertyTypeArray, //
    JMPropertyTypeNumber, //
    JMPropertyTypeBOOL,//
    JMPropertyTypeString,// String
} JMPropertyType;
/**
 属性
 */
@interface JMProperty : NSObject

/**
 属性的名字objc_property_t
 */
@property (nonatomic, copy) NSString * propertyName;

/**
 要替换字典中的的key，如果没有，则就是`propertyName`
 */
@property (nonatomic, copy) NSString * replaceName;

/**
 属性的类型：NSString、NSArray、BOOL 等，赋值用
 */
@property (nonatomic, copy) NSString * propertyType;

/**
 属性的类型，读取的话，以此为准，目前映射，仅支持这几种类型
 */
@property (nonatomic, assign,readonly) JMPropertyType keyType;

/**
 所属的类，Model
 */
@property (nonatomic, copy)NSString * className;

@end
