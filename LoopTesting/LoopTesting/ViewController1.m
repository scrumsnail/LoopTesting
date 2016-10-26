//
//  ViewController1.m
//  LoopTesting
//
//  Created by allthings_LuYD on 2016/10/26.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "ViewController1.h"
#import "LoopView.h"
#import "Loop.h"
@interface ViewController1 ()<Loop>
@property (nonatomic,strong) LoopView *loopView;
@end

@implementation ViewController1

+ (NSArray<NSString *> *)ul_loopPrivatelyKeys{
    return @[@"_loopView"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _loopView = [LoopView new];
    _loopView.backgroundColor = [UIColor redColor];
    _loopView.frame = CGRectMake(100, 150, 50, 50);
    [self.view addSubview:_loopView];
    _loopView.block = ^(){
        self.view.backgroundColor = [UIColor redColor];
    };
}


- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
