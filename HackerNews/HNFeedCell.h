//
//  HNFeedTableViewCell.h
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNThinLineButton;
@class HNFeedCellViewModel;

@interface HNFeedCell : UITableViewCell

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) UILabel *infoLabel;
@property (nonatomic) HNThinLineButton *commentsButton;
@property (nonatomic, weak) UINavigationController *navController;


- (void)configureWithViewModel:(HNFeedCellViewModel *)viewModel;


@end
