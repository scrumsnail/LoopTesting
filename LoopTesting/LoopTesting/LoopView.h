//
//  LoopView.h
//  LoopTesting
//
//  Created by allthings_LuYD on 2016/10/26.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopView : UIView
@property (nonatomic,copy)void(^block)();
@end
