//
//  ViewController.m
//  GCDOperationQueue
//
//  Created by 曾超 on 17/10/30.
//  Copyright © 2017年 曾超. All rights reserved.
//  GCD执行四个任务，要求前三个同时执行，执行完成前三个后，在执行第四个任务，四个任务全部执行完成后回到主线程。

#import "ViewController.h"

@interface ViewController ()

//@property (nonatomic,strong)NSString * one;
//
//@property (nonatomic,strong)NSString * two;
//
//@property (nonatomic,strong)NSString * three;

@property (nonatomic)BOOL first ;

@property (nonatomic)BOOL second;

@property (nonatomic)BOOL  third;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
    
    //方法1:用group的通知方法
//    [self firstMethod];
    
    //方法2：用notification通知中心
//    [self secondMethod];
    
    //方法3：串行里面嵌套并发
    [self thirdMethod];
    
}
-(void)firstMethod{
    //串行队列
    dispatch_queue_t serial = dispatch_queue_create("com.serial.gcd", DISPATCH_QUEUE_SERIAL);
    //全局队列(并发)
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //主队列
    dispatch_queue_t mainqueue = dispatch_get_main_queue();
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, global, ^{
        NSLog(@" 执行任务1");
    });
    dispatch_group_async(group, global, ^{
        NSLog(@" 执行任务2");
    });
    dispatch_group_async(group, global, ^{
        NSLog(@"执行任务3");
    });
    dispatch_group_notify(group, global, ^{
        NSLog(@"前三个任务已执行完成，开始执行第四个任务");
        dispatch_async(serial, ^{
            NSLog(@"执行第四个任务");
            dispatch_async(mainqueue, ^{
                NSLog(@"任务全部执行完毕，回到主线程");
            });
        });
        
    });
}
-(void)secondMethod{
        dispatch_queue_t concurrent = dispatch_queue_create("com.concurrent2.gcd", DISPATCH_QUEUE_CONCURRENT);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishTask:) name:@"task" object:nil];

    dispatch_async(concurrent, ^{
        NSLog(@"misson 1");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"task" object:@"1" ];
    });

    dispatch_async(concurrent, ^{
        NSLog(@"mission 2");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"task" object:@"2"];
    });

    dispatch_async(concurrent, ^{
        NSLog(@"mission 3");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"task" object:@"3"];
    });
}

-(void)finishTask:(NSNotification *)notify{
    
    if ([[notify object]isEqualToString:@"1"]) {
        self.first = YES;
    }
    if ([[notify object]isEqualToString:@"2"]) {
        self.second = YES;
    }
    if ([[notify object]isEqualToString:@"3"]) {
        self.third = YES;
    }

    if (self.first ==YES && self.second == YES  &&self.third == YES) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"前三个任务完成，开始第四个任务");
            self.first = NO;
            self.second = NO;
            self.third = NO;
        });
    }
}

-(void)thirdMethod{
    dispatch_queue_t concurrent3 = dispatch_queue_create("com.current3.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t seiral = dispatch_queue_create("com,serial3.gcd", DISPATCH_QUEUE_SERIAL);
    
        dispatch_sync(seiral, ^{
            dispatch_async(concurrent3, ^{
                NSLog(@"任务1");
            });
            dispatch_async(concurrent3, ^{
                NSLog(@"任务2");
            });
            dispatch_async(concurrent3, ^{
                NSLog(@"任务3");
            });

        });
    dispatch_sync(seiral, ^{
        NSLog(@"任务4");
    });

}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"task" object:nil] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
