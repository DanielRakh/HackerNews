//
//  HNFeedTableViewCell.h
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNFeedCellViewModel;

@interface HNFeedCell : UITableViewCell

@property (nonatomic, weak) UINavigationController *navController;

- (void)configureWithViewModel:(HNFeedCellViewModel *)viewModel;


@end
