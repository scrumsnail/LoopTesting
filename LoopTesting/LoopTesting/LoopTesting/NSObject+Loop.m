//
//  NSObject+Loop.m
//  LoopTesting
//
//  Created by allthings_LuYD on 2016/10/26.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "NSObject+Loop.h"
#import <objc/runtime.h>
@implementation NSObject (Loop)

- (NSArray *)ul_allPropertys{
    NSMutableArray *propertyArr = [NSMutableArray array];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propertyArr addObject:propertyName];
    }
    free(properties);
    return propertyArr;
}

- (NSDictionary *)ul_loopValues{
    NSArray *propertys = @[@"debugDescription",@"description",@"hash",@"superclass"];
    NSArray *allPropertys = [self ul_allPropertys];
    NSMutableDictionary *loopValues = [NSMutableDictionary dictionary];
    [allPropertys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![propertys containsObject:obj]) {
            id value = [self valueForKey:obj];
            if (value) {
                [loopValues setObject:value forKey:obj];
            }
        }
    }];
    return [loopValues copy];
}
@end
