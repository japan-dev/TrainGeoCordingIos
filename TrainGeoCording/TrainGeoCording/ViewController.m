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
    _scaleX = screenWidth / SIZE_X;
    _scaleY = screenHeight / SIZE_Y;
    
    /*
    // get time
    {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger flags;
        NSDateComponents *comps;
        
        flags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        comps = [calendar components:flags fromDate:now];
        _time = (int)comps.hour;
        
        NSString* imgName = @"";
        if(_time >= 18 && _time <= 5){
            imgName = @"daytime.png";
        }
        else{
            imgName = @"night2.png";
        }
        //imgName = @"daytime.png";
        
        UIImage* backImg = [UIImage imageNamed:imgName];
        
        CGRect rect = CGRectMake(0, 90 * _scaleX, screenWidth * _scaleX, 222 * _scaleY);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
        
        // 画像の読み込み
        imageView.image = backImg;
        // UIImageViewのインスタンスをビューに追加
        [self.view addSubview:imageView];
    }
    */
    
    // 画像の生成
    UIImage* onBtnImg = [UIImage imageNamed:@"button_on"];
    UIImage* offBtnImg = [UIImage imageNamed:@"button_off"];
    
    // 電車画像
    [self LoadTrainImage];
    
    // ボタンの生成(ON)
    UIButton *btnOn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOn setImage:onBtnImg forState:(UIControlStateNormal)];
    btnOn.frame = CGRectMake(40 * _scaleX, 450 * _scaleY, 70 * _scaleX, 70 * _scaleY);
    [btnOn addTarget:self action:@selector(tapOnBtn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnOn];
    
    // ボタン生成(OFF)
    UIButton *btnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOff setImage:offBtnImg forState:(UIControlStateNormal)];
    btnOff.frame = CGRectMake(210 * _scaleX, 450 * _scaleY, 70 * _scaleX, 70 * _scaleY);
    [btnOff addTarget:self action:@selector(tapOffBtn:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnOff];
    
    // 駅名ラベル
    /*
    UILabel *stationLabel = [[UILabel alloc]init];
    stationLabel.frame = CGRectMake((screenWidth / 2) - (150 / 2 * _scaleX), 100 * _scaleY, 150 * _scaleX, 25 * _scaleY);
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
        btnDestination.frame = CGRectMake(30 * _scaleX, 50 * _scaleY, 60 * _scaleX, 40 * _scaleY);
        [btnDestination setTitle:@"目的地" forState:UIControlStateNormal];
        // ボタンタップイベントを追加
        [btnDestination addTarget:self action:@selector(tapDestinationBtn:)
                 forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btnDestination];
        
        // 目的地表示ボタン
        _stationNameBtn = [[UIButton alloc]init];
        _stationNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stationNameBtn.frame = CGRectMake((30 + 60) * _scaleX, 50 * _scaleY, (SIZE_X - 90 - 40) * _scaleX, 40 * _scaleY);
        
        [_stationNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_stationNameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted]; //ハイライト時
        // border
        [[_stationNameBtn layer] setBorderColor:[[UIColor greenColor] CGColor]];
        [[_stationNameBtn layer] setBorderWidth:1.0];

        
        // ボタンタップイベントを追加
        [_stationNameBtn addTarget:self action:@selector(tapDestinationBtn:)
                     forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_stationNameBtn];
        [_stationNameBtn setTitle:@"選択してください" forState:UIControlStateNormal];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];  // 取得

    // 駅までの表示距離
    {
        _distanceLabel = [[UILabel alloc] init];
        // getdistance
        int distance = [userDefault integerForKey:DISTANCE_KEY];
        distance = 10000;
        _distanceLabel.frame = CGRectMake((HARF_X - (220 / 2 )) * _scaleX, 312 * _scaleY, 220 * _scaleX, 25 * _scaleY);

        NSString* distanceStr = @"";
        // km
        if(distance >= 1000){
            distance /= 1000;
            distanceStr = [NSString stringWithFormat:@"あと%dkm",distance];
        }
        // m
        else{
            distanceStr = [NSString stringWithFormat:@"あと%dm",distance];
        }
        [_distanceLabel setText:distanceStr];
        // border
        [[_distanceLabel layer] setBorderColor:[[UIColor greenColor] CGColor]];
        [[_distanceLabel layer] setBorderWidth:1.0];
        
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_distanceLabel];
    }
    
    // 選択駅名取得
    //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];  // 取得
    NSString* stationName = [userDefault stringForKey:STATION_NAME_KEY];
    if([stationName length] <= 0){
        stationName = @"選択してください";
    }
    //stationLabel.text = _stationName;
    //[self.view addSubview:stationLabel];
    
    
    // 位置情報
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 50.0f;
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locationManager requestAlwaysAuthorization];
    }
    
    _stationLat = 0.0f;
    _stationLon = 0.0f;
    
    _isPush = YES;
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

/*
    on tap
*/
-(void)tapOnBtn:(UIButton*)button
{
    [_trainImg startAnimating];
    // 位置情報取得開始
    [_locationManager startUpdatingLocation];
    _isPush = NO;
}

/*
    off tap
*/
-(void)tapOffBtn:(UIButton*)button
{
    [_trainImg stopAnimating];
    [_locationManager stopUpdatingLocation];
    _isPush = YES;
    
    // TODO:テストで5秒後に表示
    [self addNotification:5];
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
        distanceStr = [NSString stringWithFormat:@"あと%dkm",(int)distance];
    }
    // m
    else{
        distanceStr = [NSString stringWithFormat:@"あと%dm",(int)distance];
    }
    _distanceLabel.text = distanceStr;
    
    if(distance <= 100 && !_isPush)
    {
        // 通知する
        [self addNotification:1];
        _isPush = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",@"位置情報が取得できませんでした。");
}

/*
    電車
*/

/*
    電車画像読み込み
*/
-(void)LoadTrainImage{
    // rail
    UIImageView *railImage = [[UIImageView alloc] initWithFrame:CGRectMake((HARF_X - 22.5) * _scaleX , (264 + 10) * _scaleY, 45 * _scaleX, 13 * _scaleY)];
    railImage.image = [UIImage imageNamed:@"train_rail.png"];
    [self.view addSubview:railImage];
    
    // Load images
    NSArray *imageNames = @[@"train1.png", @"train2.png"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    _trainImg = [[UIImageView alloc] initWithFrame:CGRectMake((HARF_X - 24.5) * _scaleX , (220 + 10) * _scaleY, 49 * _scaleX, 49 * _scaleY)];
    _trainImg.animationImages = images;
    _trainImg.image = [UIImage imageNamed:@"train_off.png"];
    _trainImg.animationDuration = 2;
    [self.view addSubview:_trainImg];
}

/*
    電車アニメーション
*/
-(void)StartTrainAnimation{
    [_trainImg startAnimating];
}

-(void)StopTrainAnimation{
    [_trainImg stopAnimating];
}

/// 通知追加
-(void)addNotification:(CGFloat)sec
{
    // インスタンス生成
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 秒後に通知をする（設定は秒単位）
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:sec];
    // タイムゾーンの設定
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 通知時に表示させるメッセージ内容
    notification.alertBody = @"到着しました！";
    // 通知に鳴る音の設定
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // 通知の登録
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
