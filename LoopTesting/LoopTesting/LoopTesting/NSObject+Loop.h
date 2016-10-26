//
//  NSObject+Loop.h
//  LoopTesting
//
//  Created by allthings_LuYD on 2016/10/26.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Loop)

/**
 存在循环引用的变量

 @return dic
 */
- (NSDictionary *)ul_loopValues;
@end
