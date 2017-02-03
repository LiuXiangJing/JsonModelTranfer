//
//  TestJsonModel.h
//  JsonModelTranfer
//
//  Created by Tintin on 2017/1/18.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JsonModel.h"
#import "testSubModel.h"
@interface TestJsonModel : NSObject
@property (nonatomic, strong)   NSArray * array1;
@property (nonatomic, copy)     NSString * string1;
@property (nonatomic, assign)   BOOL abool;
@property (nonatomic, assign)   float ainterger;
@property (nonatomic, strong)   NSURL * aURL;
@property (nonatomic, strong)   testSubModel * subModel;
@property (nonatomic, copy) NSString * anill;
@end
