//
//  NSObject+Property.m
//  JsonModelTranfer
//
//  Created by Tintin on 2017/1/17.
//  Copyright © 2017年 Tintin. All rights reserved.
//


#import "NSObject+Property.h"
#import <objc/runtime.h>
#import "JMProperty.h"


static const char CachedPropertiesKey = '\0';

static NSMutableDictionary *cachedPropertiesDict_;

@implementation NSObject (Property)
+ (void)load {
    cachedPropertiesDict_ = [NSMutableDictionary dictionary];
}
+ (NSMutableDictionary *)dictForKey:(const void *)key
{
    @synchronized (self) {
        if (key == &CachedPropertiesKey) return cachedPropertiesDict_;
        return nil;
    }
}
+ (NSArray<JMProperty *> *)allProperties {
    
    NSMutableArray *cachedProperties = [self dictForKey:&CachedPropertiesKey][NSStringFromClass(self)];
    
    if (cachedProperties == nil) {
        cachedProperties = [NSMutableArray array];
        // 1.获得所有的成员变量
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList(self, &outCount);
        // 2.遍历每一个成员变量
        for (unsigned int i = 0; i<outCount; i++) {
            objc_property_t aproperty = properties[i];
            JMProperty * property = [[JMProperty alloc] init];
            property.propertyName = [[NSString alloc] initWithCString:property_getName(aproperty) encoding:NSUTF8StringEncoding];
            property.className = NSStringFromClass(self);
            property.propertyType = [self propertyTypeWithProperty:aproperty];
            [cachedProperties addObject:property];
        }
        // 3.释放内存
        free(properties);
        [self dictForKey:&CachedPropertiesKey][NSStringFromClass(self)] = cachedProperties;
    }
    NSLog(@"===========%@",[self dictForKey:&CachedPropertiesKey]);
    return cachedProperties;
    
}
+ (NSString *)propertyTypeWithProperty:(objc_property_t)property {
    NSString *attrs = @(property_getAttributes(property));
    NSUInteger dotLoc = [attrs rangeOfString:@","].location;
    NSString *propertyType = nil;
    NSUInteger loc = 1;
    if (dotLoc == NSNotFound) { // 没有,
        propertyType = [attrs substringFromIndex:loc];
    } else {
        propertyType = [attrs substringWithRange:NSMakeRange(loc, dotLoc - loc)];
    }
    return propertyType;
}
+ (void)enumerateProperties:(PropertiesEnumeration)enumeration {
    // 获得成员变量
    NSArray *cachedProperties = [self allProperties];
    // 遍历成员变量
    BOOL stop = NO;
    for (JMProperty *property in cachedProperties) {
        enumeration(property, &stop);
        if (stop) break;
    }
}

@end
