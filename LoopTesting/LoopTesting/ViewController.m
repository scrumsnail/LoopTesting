//
//  ViewController.m
//  LoopTesting
//
//  Created by allthings_LuYD on 2016/10/26.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController pushViewController:[ViewController1 new] animated:YES];
}

@end
