//
//  SearchNameViewController.m
//  GetStationName
//
//  Created by USER on 2015/03/03.
//  Copyright (c) 2015年 USER. All rights reserved.
//

#import "SearchNameViewController.h"

@interface SearchNameViewController ()

@end

@implementation SearchNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBar.delegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 駅名CSVファイル読み込み
    [self loadCsvFlie];
}

-(void)viewWillAppear:(BOOL)animated
{

}

-(void)viewDidLayoutSubviews
{
    if(_searchBar.canBecomeFirstResponder)
    {
        [_searchBar becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/// 配列検索処理
- (void)filterContainsWithSearchText:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        _searchResults = [NSMutableArray array];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
        
        NSArray* array = [_stationNameList filteredArrayUsingPredicate:predicate];
        _searchResults = [array mutableCopy];
    }
}

/// 駅名CSVファイル読み込み
-(void)loadCsvFlie
{
    // UTF8 エンコードされた CSV ファイル
    NSString *filePath = [[NSBundle mainBundle] pathForResource:CSV_FILE_NAME ofType:CSV_FILE_EXTENSION];
    NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    // 改行文字で区切って配列に格納する
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    
    self.stationList = [NSMutableArray array];
    self.stationNameList = [NSMutableArray array];
    for (NSString *row in lines)
    {
        if(row.length > 0)
        {
            // コンマで区切って配列に格納する
            NSArray *items = [row componentsSeparatedByString:@","];
            
            // 連想配列にする
            NSMutableDictionary* addList = [NSMutableDictionary dictionary];
            [addList setObject:[items objectAtIndex:0] forKey:@"station_cd"];
            [addList setObject:[items objectAtIndex:1] forKey:@"station_g_cd"];
            [addList setObject:[items objectAtIndex:2] forKey:@"station_name"];
            [addList setObject:[items objectAtIndex:3] forKey:@"station_name_k"];
            [addList setObject:[items objectAtIndex:4] forKey:@"station_name_r"];
            [addList setObject:[items objectAtIndex:5] forKey:@"line_cd"];
            [addList setObject:[items objectAtIndex:6] forKey:@"pref_cd"];
            [addList setObject:[items objectAtIndex:7] forKey:@"post"];
            [addList setObject:[items objectAtIndex:8] forKey:@"add"];
            [addList setObject:[items objectAtIndex:9] forKey:@"lon"];
            [addList setObject:[items objectAtIndex:10] forKey:@"lat"];
            [addList setObject:[items objectAtIndex:11] forKey:@"open_ymd"];
            [addList setObject:[items objectAtIndex:12] forKey:@"close_ymd"];
            [addList setObject:[items objectAtIndex:13] forKey:@"e_status"];
            [addList setObject:[items objectAtIndex:14] forKey:@"e_sort"];
            
            [self.stationList addObject:addList];
            
            // 名前検索用配列にも保存しておく
            [self.stationNameList addObject:[items objectAtIndex:2]];
        }
    }
}

#pragma mark - SearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]!=0)
    {
    }
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (BOOL)searchDisplayController:controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // 検索バーに入力された文字列を引数に、絞り込みをかけます
    [self filterContainsWithSearchText:searchString];
    
    return YES;
}

#pragma mark - TableViewDataSource delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger dataCount;
    
    dataCount = _searchResults.count;
    return dataCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _searchResults[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:^{
        for (NSDictionary* dic in _stationList)
        {
            if([dic objectForKey:@"station_name"] == _searchResults[indexPath.row])
            {                
                // delegateを呼んで終了
                if ([self.delegate respondsToSelector:@selector(searchNameViewSelectStationName:)])
                {
                    [self.delegate searchNameViewSelectStationName:dic];
                }
                break;
            }
        }
    }];
}

@end
