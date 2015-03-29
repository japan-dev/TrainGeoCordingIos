//
//  ViewController.h
//  TrainGeoCording
//
//  Created by USER on 2015/02/21.
//  Copyright (c) 2015年 USER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchNameViewController.h"

@interface ViewController : UIViewController<SearchNameViewDelegate, CLLocationManagerDelegate>

// object
@property(nonatomic) CLLocationManager* locationManager;
@property(nonatomic) UIImageView* trainImg;

@property(nonatomic) NSString* stationName;

@property(nonatomic) CGFloat stationLat;
@property(nonatomic) CGFloat stationLon;


@property(nonatomic) UIButton* stationNameBtn;
@property(nonatomic) UILabel* distanceLabel;

/// 通知フラグ
@property(nonatomic) BOOL isPush;

// value
@property float scaleX;
@property float scaleY;
@property int time;

-(void)tapDestinationBtn:(UIButton*)button;
-(void)LoadTrainImage;
-(void)StartTrainAnimation;


@end

