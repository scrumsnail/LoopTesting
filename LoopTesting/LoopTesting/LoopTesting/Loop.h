//
//  Loop.h
//  LoopTesting
//
//  Created by allthings_LuYD on 2016/10/26.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Loop <NSObject>

@optional

/**
 需要查询的私有变量key

 @return Keys
 */
+ (NSArray <NSString *> *)ul_loopPrivatelyKeys;

@end
