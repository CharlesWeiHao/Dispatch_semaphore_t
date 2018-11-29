//
//  ViewController.m
//  Dispatch_semaphore_t
//
//  Created by Howie on 2018/11/29.
//  Copyright © 2018年 Howie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 信号量操作
    [self semaphore];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)semaphore
{
    //创建一个队列，串行并行都可以，主要为了操作信号量
    dispatch_queue_t queue = dispatch_queue_create("alert_queue_t", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        //创建一个初始为0的信号量
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        //第一个弹框，UI的创建和显示，要在主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"弹框1" message:@"第一个弹框" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //点击Alert上的按钮，我们发送一次信号。
                dispatch_semaphore_signal(sema);
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        });
        
        //等待信号触发，注意，这里是在我们创建的队列中等待
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //上面的等待到信号触发之后，再创建第二个Alert
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"弹框2" message:@"第二个弹框" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                dispatch_semaphore_signal(sema);
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        });
        
        //同理，创建第三个Alert
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"弹框3" message:@"第三个弹框" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                dispatch_semaphore_signal(sema);
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        });
    });
}


@end
