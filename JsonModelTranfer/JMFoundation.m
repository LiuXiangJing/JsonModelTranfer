//
//  JMFoundation.m
//  JsonModelTranfer
//
//  Created by Tintin on 2017/1/22.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import "JMFoundation.h"
#import <CoreData/CoreData.h>
static NSSet *foundationClasses_;

@implementation JMFoundation
+ (BOOL)isClassFromFoundation:(Class)fClass {
    if (fClass == [NSObject class] ||fClass == [NSManagedObject class]) return YES;
    
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([fClass isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}
+ (NSSet *)foundationClasses
{
    if (foundationClasses_ == nil) {
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}
@end
