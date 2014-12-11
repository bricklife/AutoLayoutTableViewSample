//
//  AutoLayoutTableViewCell.m
//  AutoLayoutTableTest
//
//  Created by Shinichiro Oba on 2014/12/11.
//  Copyright (c) 2014年 Shinichiro Oba. All rights reserved.
//

#import "AutoLayoutTableViewCell.h"

@implementation AutoLayoutTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // コンテナビューを再レイアウト
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];

        // preferredMaxLayoutWidth を自身の幅と同じにする
        // iOS 8のときは 0 のままにしておけば自動計算してくれるので必要ない
        self.label.preferredMaxLayoutWidth = CGRectGetWidth(self.label.frame);
    }
}

@end
