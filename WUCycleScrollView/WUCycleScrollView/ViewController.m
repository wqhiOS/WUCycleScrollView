//
//  ViewController.m
//  WUCycleScrollView
//
//  Created by wuqh on 16/4/10.
//  Copyright © 2016年 吴启晗. All rights reserved.
//

#import "ViewController.h"
#import "WUCycleScrollView.h"
@interface ViewController ()<WUCycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *imagesurl = @[@"http://image.shanlincaifu.com/slcf//banner/2016/03/28/ee96a403-b1d2-464e-9cc0-3b74f0851192.png",
                           @"http://image.shanlincaifu.com/slcf//banner/2016/03/28/d4d5da6b-d470-4e3b-becb-e225f1f7ffe9.png"];
    
    WUCycleScrollView *cycleScrollView = [[WUCycleScrollView alloc] initWithImageArray:imagesurl frame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width*2/5)];
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
}

- (void)cycleScrollView:(WUCycleScrollView *)cycleScrollView didSelectedImageView:(NSInteger)index {
    NSLog(@"%ld",index);
}

@end
