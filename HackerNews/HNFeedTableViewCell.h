//
//  HNFeedTableViewCell.h
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNThinLineButton;
@class HNCellViewModel;

@interface HNFeedTableViewCell : UITableViewCell

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) UILabel *infoLabel;
@property (nonatomic) HNThinLineButton *commentsButton;


- (void)configureWithViewModel:(HNCellViewModel *)viewModel;

@end
