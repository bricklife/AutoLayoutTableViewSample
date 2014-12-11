//
//  AutoLayoutTableViewController.m
//  AutoLayoutTableTest
//
//  Created by Shinichiro Oba on 2014/12/11.
//  Copyright (c) 2014年 Shinichiro Oba. All rights reserved.
//

#import "AutoLayoutTableViewController.h"

#import "AutoLayoutTableViewCell.h"

@interface AutoLayoutTableViewController ()

@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) AutoLayoutTableViewCell *heightCalculateCell;

@end

@implementation AutoLayoutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textArray = [NSMutableArray arrayWithCapacity:200];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < 200; i++) {
        [string appendString:@"あ"];
        [_textArray addObject:[NSString stringWithFormat:@"%lu\n%@", (unsigned long)string.length, string]];
    }
   
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // 高さ計算用のセルを生成
        self.heightCalculateCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
}

- (void)viewWillLayoutSubviews {
    // estimatedRowHeight から正しい高さになるタイミングで再レイアウトが発生するためか、スクロール中に呼ばれまくるので注意
    [super viewWillLayoutSubviews];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AutoLayoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.label.text = _textArray[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // 高さ計算用のセルに必要な値だけセット
        _heightCalculateCell.label.text = _textArray[indexPath.row];
        
        // セルが持つラベルの preferredMaxLayoutWidth を再計算させるために、テーブルに合わせたサイズでレイアウトさせる
        _heightCalculateCell.bounds = CGRectMake(0.f, 0.f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(_heightCalculateCell.bounds));
        [_heightCalculateCell setNeedsLayout];
        [_heightCalculateCell layoutIfNeeded];
        
        CGFloat height = [_heightCalculateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        return height + 1.f;
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 何か値を返さないとiOS 8で回転したときに高さが計算されない。0 でも UITableViewAutomaticDimensionでもダメみたい
    // 常に同じ値を返すなら self.tableView.estimatedRowHeight = 100.f; としたほうがパフォーマンスがよいが、このプロパティはiOS 7からなので注意
    return 100.f;
}

@end
