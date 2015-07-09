//
//  HNRepliesCell.m
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsReplyWithRepliesCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PureLayout.h"

//Categories
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"
#import "UIView+FindUITableView.h"

//View Model
#import "HNRepliesCellViewModel.h"

// View
#import "HNThinLineButton.h"



@interface HNCommentsReplyWithRepliesCell ()


@property (nonatomic) UIView *threadLine;

@property (nonatomic) NSLayoutConstraint *textViewHeightConstraint;
@property (nonatomic) HNThinLineButton *repliesButton;


@end


@implementation HNCommentsReplyWithRepliesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initalizeViews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initalizeViews];
    }
    return self;
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    self.originationLabel.attributedText = viewModel.origination;
    self.commentTextView.attributedText = viewModel.text;
    [self.repliesButton setTitle:viewModel.repliesCount == 1 ? [NSString stringWithFormat:@"1 Reply"] : [NSString stringWithFormat:@"%ld Replies",(long)viewModel.repliesCount] forState:UIControlStateNormal];
}

- (void)initalizeViews {

    //Set up Comments Button
    self.repliesButton = [HNThinLineButton newAutoLayoutView];
    self.repliesButton.titleLabel.font = [UIFont proximaNovaWithWeight:TypeWeightRegular size:12.0];
    [self.repliesButton addTarget:self action:@selector(repliesButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    self.repliesButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.repliesButton];
    
    //Set up thread line
    self.threadLine = [UIView newAutoLayoutView];
    self.threadLine.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.threadLine];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    if (self.didUpdateConstraints == NO) {
        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.threadLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.originationLabel];
            [self.threadLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.commentTextView];
        }];
        [self.threadLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kRepliesHorizontalInset];
        [self.threadLine autoSetDimension:ALDimensionWidth toSize:1.0 relation:NSLayoutRelationEqual];
        
        
        [self.originationLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.threadLine withOffset:6.0];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kRepliesVerticalInset];

        
        [UIView autoSetPriority:996 forConstraints:^{
            [self.originationLabel autoSetContentHuggingPriorityForAxis:ALAxisVertical];
            [self.originationLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.originationLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.commentTextView withOffset:-10 relation:NSLayoutRelationEqual];
        }];
        
        
        [self.commentTextView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.threadLine withOffset:6.0];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];
        [UIView autoSetPriority:998 forConstraints:^{
            [self.commentTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.repliesButton withOffset:-10 relation:NSLayoutRelationEqual];
        }];
        

        [self.repliesButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.threadLine withOffset:6.0];
        [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];
        [self.repliesButton autoSetDimension:ALDimensionHeight toSize:30.0];
      
        [UIView autoSetPriority:997 forConstraints:^{
            [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];

        }];
        
        // Thread Line constraints
        self.didUpdateConstraints = YES;
    }
    
#warning We need to fuck around with these values for different cell types.
    CGFloat wrappingWidth = [UIScreen mainScreen].bounds.size.width - 20 - 24;

    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

    
    if (!self.textViewHeightConstraint) {
        [UIView autoSetPriority:749 forConstraints:^{
        self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:ceilf(CGRectGetHeight(rect))];

        }];
    } else {
        self.textViewHeightConstraint.constant = ceilf(CGRectGetHeight(rect));

    }
    
    [super updateConstraints];
}

#pragma mark-
#pragma mark - Actions
- (void)repliesButtonDidTap:(id)sender {
    if (self.repliesButtonDidTapAction) {
        self.repliesButtonDidTapAction(sender);
    }
}


@end
