//
//  SecondViewController.m
//  PthreadsDemo
//
//  Created by xiaoL on 17/2/3.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

#import "SecondViewController.h"
#import "XLDataFetchHandler.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[XLDataFetchHandler sharedInstance] requestAllHomeThemeListWithCompletion:^(NSArray *themeList, BOOL httpDone) {
        
        NSLog(@"[%@]  requestAllHomeThemeListWithCompletion   httpDone:%@",NSStringFromClass([self class]),@(httpDone));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
