//
//  JMProperty.m
//  JsonModelTranfer
//
//  Created by Tintin on 2017/1/17.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import "JMProperty.h"
#import "NSObject+JsonModel.h"
#import "JMFoundation.h"
/**
 *  成员变量类型（属性类型）
 */

#define JMPropertyTypeInt           @"i"
#define JMPropertyTypeShort         @"s"
#define JMPropertyTypeFloat         @"f"
#define JMPropertyTypeDouble        @"d"
#define JMPropertyTypeLong          @"l"
#define JMPropertyTypeLongLong      @"q"
#define JMPropertyTypeBOOL1         @"c"
#define JMPropertyTypeBOOL2         @"b"

#define JMPropertyTypeArray1        @"NSMutableArray"
#define JMPropertyTypeArray2        @"NSArray"
@implementation JMProperty
- (void)setPropertyType:(NSString *)propertyType {
    _propertyType = [propertyType copy];
    _keyType = JMPropertyTypeString;
    if (propertyType.length >0) {
        if (propertyType.length > 3 && [propertyType hasPrefix:@"@\""]) {
            _propertyType = [propertyType substringWithRange:NSMakeRange(2, propertyType.length - 3)];
        }
        Class typeClass = NSClassFromString(_propertyType);
        BOOL isFoundation  = [JMFoundation isClassFromFoundation:typeClass];
        if (typeClass && !isFoundation) {
            _keyType = JMPropertyTypeModel;
        }
        if ([_propertyType isEqualToString:JMPropertyTypeArray1]||[_propertyType isEqualToString:JMPropertyTypeArray2]) {
            _keyType = JMPropertyTypeArray;
        }

        // 是否为数字类型
        NSString *lowerCode = _propertyType.lowercaseString;
        NSArray *numberTypes = @[JMPropertyTypeInt, JMPropertyTypeShort, JMPropertyTypeFloat, JMPropertyTypeDouble, JMPropertyTypeLong, JMPropertyTypeLongLong, JMPropertyTypeBOOL1, JMPropertyTypeBOOL2];
        if ([numberTypes containsObject:lowerCode]) {
            _keyType = JMPropertyTypeNumber;
            if ([lowerCode isEqualToString:JMPropertyTypeBOOL1]
                || [lowerCode isEqualToString:JMPropertyTypeBOOL2]) {
                _keyType = JMPropertyTypeBOOL;
            }
        }
    }
}


@end
