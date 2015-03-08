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

@property(nonatomic) CLLocationManager* locationManager;

@end

