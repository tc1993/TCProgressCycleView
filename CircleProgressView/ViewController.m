//
//  ViewController.m
//  CircleProgressView
//
//  Created by 唐超 on 8/15/18.
//  Copyright © 2018 tcc. All rights reserved.
//

#import "ViewController.h"
#import "TCCircleProgressView.h"

#import "CircleProgressView-Swift.h"

@interface ViewController ()

@property (nonatomic, strong) TCCircleProgressView * progressView;

@property (nonatomic, strong) CircleProgressView * swiftView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //oc版
//    _progressView = [[TCCircleProgressView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
//    [self.view addSubview:_progressView];
//    _progressView.progress = 0.5;
    
    //swift版
    CircleProgressView * swiftView = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    [self.view addSubview:swiftView];
    swiftView.progress = 0.5;
    _swiftView = swiftView;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static int count = 0;
//    _progressView.progress = (count%5)/4.0;
    _swiftView.progress = (count%5)/4.0;
    count++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
