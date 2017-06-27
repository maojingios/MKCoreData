//
//  ViewController.m
//  MKCoreData
//
//  Created by gw on 2017/6/27.
//  Copyright © 2017年 VS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    

}


-(void)basicUse{

    [[BasicUse manager] prepare];
    [[BasicUse manager] insert]; //增
    [[BasicUse manager] query]; //查
    [[BasicUse manager] mkDelete];//删
    [[BasicUse manager] update];//改
}

@end
