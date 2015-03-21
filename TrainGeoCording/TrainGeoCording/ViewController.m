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
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];  // 取得

    // ボタンの生成(ON)
    UIButton *btnOn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOn setImage:onBtnImg forState:(UIControlStateNormal)];
    btnOn.frame = CGRectMake(40 * scaleX, 450 * scaleY, 70 * scaleX, 70 * scaleY);
    [btnOn addTarget:self action:@selector(tapOnBtn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnOn];
    
    // ボタン生成(OFF)
    UIButton *btnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOff setImage:offBtnImg forState:(UIControlStateNormal)];
    btnOff.frame = CGRectMake(210 * scaleX, 450 * scaleY, 70 * scaleX, 70 * scaleY);
    [self.view addSubview:btnOff];
    
    // 駅名ラベル
    /*
    UILabel *stationLabel = [[UILabel alloc]init];
    stationLabel.frame = CGRectMake((screenWidth / 2) - (150 / 2 * scaleX), 100 * scaleY, 150 * scaleX, 25 * scaleY);
    //stationLabel.backgroundColor = [UIColor yellowColor];
    stationLabel.textColor = [UIColor blueColor];
    stationLabel.font = [UIFont fontWithName:@"AppleGothic" size:14];
    stationLabel.textAlignment = UITextAlignmentCenter;
    */
    // 駅名検索画面に遷移する為のボタン
    {
        UIColor *color = [UIColor greenColor];
        
        // 目的地
        UIButton *btnDestination = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDestination setBackgroundColor:color];
        btnDestination.frame = CGRectMake(40 * scaleX, 50 * scaleY, 50 * scaleX, 40 * scaleY);
        [btnDestination setTitle:@"目的地" forState:UIControlStateNormal];
        // ボタンタップイベントを追加
        [btnDestination addTarget:self action:@selector(tapDestinationBtn:)
                 forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btnDestination];
        
        // 目的地表示ボタン
        _stationNameBtn = [[UIButton alloc]init];
        _stationNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stationNameBtn.frame = CGRectMake((40 + 50) * scaleX, 50 * scaleY, (SIZE_X - 90 - 40) * scaleX, 40 * scaleY);
        
        [_stationNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_stationNameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted]; //ハイライト時
        // border
        [[_stationNameBtn layer] setBorderColor:[[UIColor greenColor] CGColor]];
        [[_stationNameBtn layer] setBorderWidth:1.0];

        
        // ボタンタップイベントを追加
        [_stationNameBtn addTarget:self action:@selector(tapDestinationBtn:)
                     forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_stationNameBtn];
        [_stationNameBtn setTitle:@"bbkdjflaj" forState:UIControlStateNormal];
    }

    // 駅までの表示距離
    {
        _distanceLabel = [[UILabel alloc] init];
        // getdistance
        int distance = [userDefault integerForKey:DISTANCE_KEY];
        _distanceLabel.frame = CGRectMake((HARF_X - (150 / 2 )) * scaleX, 120 * scaleY, 150 * scaleX, 25 * scaleY);
        [_distanceLabel setBackgroundColor:[UIColor greenColor]];
        NSString* distanceStr = @"";
        // km
        if(distance >= 1000){
            distance /= 1000;
            distanceStr = [NSString stringWithFormat:@"目的地まであと%dkm",distance];
        }
        // m
        else{
            distanceStr = [NSString stringWithFormat:@"目的地まであと%dm",distance];
        }
        [_distanceLabel setText:distanceStr];
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_distanceLabel];
    }
    
    /*
    UILabel *stationLabel = [[UILabel alloc]init];
    stationLabel.frame = CGRectMake((screenWidth / 2) - (150 / 2 * scaleX), 100 * scaleY, 150 * scaleX, 25 * scaleY);
    //stationLabel.backgroundColor = [UIColor yellowColor];
    stationLabel.textColor = [UIColor blueColor];
    stationLabel.font = [UIFont fontWithName:@"AppleGothic" size:14];
    stationLabel.textAlignment = UITextAlignmentCenter;
    */
    
    // 選択駅名取得
    //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];  // 取得
    NSString* stationName = [userDefault stringForKey:STATION_NAME_KEY];
    if([stationName length] <= 0){
        stationName = @"駅名を選択してください";
    }
    //stationLabel.text = _stationName;
    //[self.view addSubview:stationLabel];
    
    
    // 位置情報
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 1000.0;
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locationManager requestAlwaysAuthorization];
    }
    
    _stationLat = 0.0f;
    _stationLon = 0.0f;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

/*
    目的地ボタンをタップ
    駅名入力画面に遷移する
*/
-(void)tapDestinationBtn:(UIButton*)button{
    SearchNameViewController* v = [[SearchNameViewController alloc]init];
    v.delegate = self;
    [self presentViewController:v animated:YES completion:^{
    }];
}

-(void)tapOnBtn:(UIButton*)button
{
    // 位置情報取得開始
    [_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 駅検索delegate
-(void)searchNameViewSelectStationName:(NSDictionary*)selectStation
{
    NSLog(@"%@", [selectStation objectForKey:@"station_name"]);
    NSLog(@"%@", [selectStation objectForKey:@"lon"]);
    NSLog(@"%@", [selectStation objectForKey:@"lat"]);
    _stationName = [selectStation objectForKey:@"station_name"];
    [_stationNameBtn setTitle:_stationName forState:(UIControlStateNormal)];
    
    _stationLon = [[selectStation objectForKey:@"lon"] floatValue];
    _stationLat = [[selectStation objectForKey:@"lat"] floatValue];
    
    NSLog(@"%f",_stationLat);
    NSLog(@"%f",_stationLon);
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
    
    // 最初は無視
    if(_stationLat == 0.0f && _stationLon == 0.0f)
        return;
    
    // 2点の経緯・緯度を設定
    double latA = latitude;
    double lngA = longitude;
    double latB = _stationLat;
    double lngB = _stationLon;
    // 経緯・緯度からCLLocationを作成
    CLLocation *A = [[CLLocation alloc] initWithLatitude:latA longitude:lngA];
    CLLocation *B = [[CLLocation alloc] initWithLatitude:latB longitude:lngB];
    //　距離を取得
    CLLocationDistance distance = [A distanceFromLocation:B];
    NSLog(@"distance:%f", distance);
    // 距離を四捨五入する
    distance = round(distance);
    
    // ラベルに表示する
    NSString* distanceStr = @"";
    // km
    if(distance >= 1000){
        distance /= 1000;
        distanceStr = [NSString stringWithFormat:@"目的地まであと%dkm",(int)distance];
    }
    // m
    else{
        distanceStr = [NSString stringWithFormat:@"目的地まであと%dm",(int)distance];
    }
    _distanceLabel.text = distanceStr;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",@"位置情報が取得できませんでした。");
}

@end
