//
//  NSObject+Property.h
//  JsonModelTranfer
//
//  Created by Tintin on 2017/1/17.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMProperty.h"
typedef void (^PropertiesEnumeration)(JMProperty *property, BOOL *stop);

@interface NSObject (Property)
/**
 所有的属性名,JMProperty 数组(JMProperty: 仅会返回属性类型是：NSString,NSURL,NSDate,NSData,NSArray,NSDictionary等等)
 */
+ (NSArray<JMProperty *>*)allProperties;

/**
 遍历Object的属性

 @param enumeration 遍历block，
 */
+ (void)enumerateProperties:(PropertiesEnumeration)enumeration;
@end
