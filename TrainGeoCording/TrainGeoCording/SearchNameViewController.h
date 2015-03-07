//
//  SearchNameViewController.h
//  GetStationName
//
//  Created by USER on 2015/03/03.
//  Copyright (c) 2015年 USER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

/// デリゲートを定義
@protocol SearchNameViewDelegate <NSObject>

/// 駅名検索画面から駅を選択したときに呼ばれます
- (void)searchNameViewSelectStationName:(NSDictionary*)selectStation;

@end

@interface SearchNameViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>

/// デリゲートプロパティ
@property (nonatomic, assign) id<SearchNameViewDelegate> delegate;

/// テーブルビュー
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 検索バー
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
/// 検索結果
@property (nonatomic) NSMutableArray *searchResults;
/// 駅データ保存用配列
@property(nonatomic) NSMutableArray* stationList;
/// 駅名保存用配列
@property(nonatomic) NSMutableArray* stationNameList;

@end
