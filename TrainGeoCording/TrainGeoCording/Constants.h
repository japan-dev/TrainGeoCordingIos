//
//  Constants.h
//  GetStationName
//
//  Created by USER on 2015/02/28.
//  Copyright (c) 2015年 USER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

/// 駅名CSVファイル名
extern NSString* const CSV_FILE_NAME;

/// 駅名CSVファイル拡張子
extern NSString* const CSV_FILE_EXTENSION;

// user default
extern NSString* const STATION_NAME_KEY;
extern NSString* const DISTANCE_KEY;

#define SCREEN_BOUNDS   ([UIScreen mainScreen].bounds)
#define SIZE_X 320
#define SIZE_Y 568
#define HARF_X 160
#define HARF_Y 284

@end
