//
//  JsonModelTranferTests.m
//  JsonModelTranferTests
//
//  Created by Tintin on 2017/1/16.
//  Copyright © 2017年 Tintin. All rights reserved.
//

#import <XCTest/XCTest.h>
@interface JsonModelTranferTests : XCTestCase

@end
#import "TestJsonModel.h"
@implementation JsonModelTranferTests

- (void)setUp {
    [super setUp];
 
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSError * error ;
    TestJsonModel * jsonModel = [TestJsonModel jsonModelWithJsonModel:@{@"array12":@[@"1",@"2"],
//                                                                        @"string1":@"zifuchuan的值",
                                                                        @"abool":@"34",
                                                                        @"ainterger":@"11.202",
                                                                        @"aURL":@"https://www.baidu.com",
                                                                        @"subModel":@{@"name":@"liuxiangjing",
                                                                                      @"age":@"12344567890"},
                                                                        } error:&error];
    
    
//   NSArray * array1 = [TestJsonModel allProperties];
//    NSArray * array2 = [TestJsonModel allProperties];
    NSLog(@"ssssss ==%@",jsonModel);
    error = nil;
    NSArray * modelArray = [TestJsonModel jsonArrayModelWithJsonArray:@[@{@"array12":@[@"1",@"2"],
                                                                          //                                                                        @"string1":@"zifuchuan的值",
                                                                          @"abool":@"34",
                                                                          @"ainterger":@"11.202",
                                                                          @"aURL":@"aurldezhi",
                                                                          @"subModel":@{@"name":@"liuxiangjing",
                                                                                        @"age":@"12344567890"},
                                                                          },@{@"array12":@[@"1",@"2"],
                                                                              //                                                                        @"string1":@"zifuchuan的值",
                                                                              @"abool":@"34",
                                                                              @"ainterger":@"11.202",
                                                                              @"aURL":@"aurldezhi",
                                                                              @"subModel":@{@"name":@"liuxiangjing",
                                                                                            @"age":@"12344567890"},
                                                                              },@{@"array12":@[@"1",@"2"],
                                                                                  //                                                                        @"string1":@"zifuchuan的值",
                                                                                  @"abool":@"34",
                                                                                  @"ainterger":@"11.202",
                                                                                  @"aURL":@"aurldezhi",
                                                                                  @"subModel":@{@"name":@"liuxiangjing",
                                                                                                @"age":@"12344567890"},
                                                                                  }] error:&error];
    NSLog(@"array===%@",modelArray);
    
    NSLog(@"model转字典===%@",[jsonModel dictionaryValue]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
}

@end
