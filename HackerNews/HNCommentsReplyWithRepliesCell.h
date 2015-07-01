//
//  HNRepliesCell.h
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"


@class HNRepliesCellViewModel;
@class HNThinLineButton;

@interface HNCommentsReplyWithRepliesCell : UITableViewCell


@property (nonatomic) HNRepliesCellViewModel *viewModel;
@property (nonatomic) NSLayoutConstraint *textViewHeightConstraint;
@property (nonatomic) HNThinLineButton *repliesButton;

@property (nonatomic, copy) void (^repliesButtonDidTapAction)(id sender);

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel;




@end
