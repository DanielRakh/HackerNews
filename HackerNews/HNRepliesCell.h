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

@interface HNRepliesCell : UITableViewCell

@property (nonatomic) UILabel *originationLabel;
@property (nonatomic) HNThinLineButton *repliesButton;
@property (nonatomic) UITextView *commentTextView;


@property (nonatomic) HNRepliesCellViewModel *viewModel;

@property (nonatomic) BOOL expanded;



@property (nonatomic, weak) RATreeView *parentTreeView;
@property (nonatomic, weak) NSLayoutConstraint *treeConstraint;



- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel;


@property (nonatomic, copy) void (^repliesButtonDidTapAction)(id sender);

@property (nonatomic) NSMutableArray *repliesButtonConstraints;
@property (nonatomic) NSMutableArray *threadLineConstraints;
//@property (nonatomic) NSLayoutConstraint *textViewToBottomConstraint;


@end
