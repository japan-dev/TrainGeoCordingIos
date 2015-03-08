//
//  ViewController.m
//  TrainGeoCording
//
//  Created by USER on 2015/02/21.
//  Copyright (c) 2015年 USER. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // display size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // get display scale
    float scaleX = screenWidth / SIZE_X;
    float scaleY = screenHeight / SIZE_Y;
    
    
    // 画像の生成
    UIImage* onBtnImg = [UIImage imageNamed:@"button_on"];
    UIImage* offBtnImg = [UIImage imageNamed:@"button_off"];
    
    
    // ボタンの生成(ON)
    UIButton *btnOn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOn setImage:onBtnImg forState:(UIControlStateNormal)];
    btnOn.frame = CGRectMake(40 * scaleX, 450 * scaleY, 70 * scaleX, 70 * scaleY);
    [self.view addSubview:btnOn];
    
    // ボタン生成(OFF)
    UIButton *btnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOff setImage:offBtnImg forState:(UIControlStateNormal)];
    btnOff.frame = CGRectMake(210 * scaleX, 450 * scaleY, 70 * scaleX, 70 * scaleY);
    [self.view addSubview:btnOff];
    
    // 駅名ラベル
    UILabel *stationLabel = [[UILabel alloc]init];
    stationLabel.frame = CGRectMake((screenWidth / 2) - (150 / 2 * scaleX), 100 * scaleY, 150 * scaleX, 25 * scaleY);
    //stationLabel.backgroundColor = [UIColor yellowColor];
    stationLabel.textColor = [UIColor blueColor];
    stationLabel.font = [UIFont fontWithName:@"AppleGothic" size:14];
    stationLabel.textAlignment = UITextAlignmentCenter;
    
    // 選択駅名取得
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];  // 取得
    NSString* stationName = [userDefault stringForKey:STATION_NAME_KEY];
    if([stationName length] <= 0){
        stationName = @"駅名を選択してください";
    }
    stationLabel.text = stationName;
    [self.view addSubview:stationLabel];
    
    
    // 位置情報
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 1000.0;
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locationManager requestAlwaysAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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

#pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 位置情報を取り出す
    CLLocation *newLocation = [locations lastObject];
    //緯度
    CGFloat latitude = newLocation.coordinate.latitude;
    //経度
    CGFloat longitude = newLocation.coordinate.longitude;

    NSLog(@"%f",latitude);
    NSLog(@"%f",longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",@"位置情報が取得できませんでした。");
}

@end
