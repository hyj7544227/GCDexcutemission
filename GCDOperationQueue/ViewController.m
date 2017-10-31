//
//  ViewController.m
//  GCDOperationQueue
//
//  Created by 曾超 on 17/10/30.
//  Copyright © 2017年 曾超. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
    [self OperationQueueExcute];
    
}
-(void)OperationQueueExcute{
    //串行队列
    dispatch_queue_t serial = dispatch_queue_create("com.serial.gcd", DISPATCH_QUEUE_SERIAL);
    //并行队列
    dispatch_queue_t concurrent = dispatch_queue_create("com.concurrent.gcd", DISPATCH_QUEUE_CONCURRENT);
    //全局队列(并发)
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //主队列
    dispatch_queue_t mainqueue = dispatch_get_main_queue();
    
    dispatch_semaphore_t sem =dispatch_semaphore_create(0);
    
    dispatch_async(serial, ^{
        NSLog(@"1");
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
