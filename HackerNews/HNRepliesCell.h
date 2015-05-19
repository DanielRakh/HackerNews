//
//  HNRepliesCell.h
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNRepliesCellViewModel;
@class HNThinLineButton;

@interface HNRepliesCell : UITableViewCell

@property (nonatomic) UILabel *originationLabel;
@property (nonatomic) HNThinLineButton *repliesButton;
@property (nonatomic) UITextView *commentTextView;


@property (nonatomic) HNRepliesCellViewModel *viewModel;

@property (nonatomic) BOOL expanded;



- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel;

@end
