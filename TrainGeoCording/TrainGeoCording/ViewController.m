//
//  ViewController.m
//  TrainGeoCording
//
//  Created by USER on 2015/02/21.
//  Copyright (c) 2015年 USER. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // view did load
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSearchClick:(id)sender
{
    SearchNameViewController* v = [[SearchNameViewController alloc]init];
    v.delegate = self;
    [self presentViewController:v animated:YES completion:^{
    }];
}

/// 駅検索delegate
-(void)searchNameViewSelectStationName:(NSDictionary*)selectStation
{
    NSLog(@"%@", [selectStation objectForKey:@"station_name"]);
    NSLog(@"%@", [selectStation objectForKey:@"lon"]);
    NSLog(@"%@", [selectStation objectForKey:@"lat"]);

}

@end
