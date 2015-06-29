//
//  HNRepliesCell.m
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsReplyWithRepliesCell.h"
#import "PureLayout.h"
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"
#import "HNThinLineButton.h"
#import "HNRepliesCellViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+FindUITableView.h"


CGFloat const kRepliesVerticalInset = 10;
CGFloat const kRepliesHorizontalInset = 8;

@interface HNCommentsReplyWithRepliesCell ()

@property (nonatomic) BOOL didUpdateConstraints;

@property (nonatomic) UIView *threadLine;
@property (nonatomic) UILabel *originationLabel;
@property (nonatomic) UITextView *commentTextView;


@end


@implementation HNCommentsReplyWithRepliesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    
    [self initalizeViews];
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    self.originationLabel.attributedText = viewModel.origination;
    self.commentTextView.attributedText = viewModel.text;
    [self.repliesButton setTitle:viewModel.repliesCount == 1 ? [NSString stringWithFormat:@"1 Reply"] : [NSString stringWithFormat:@"%ld Replies",viewModel.repliesCount] forState:UIControlStateNormal];
}

- (void)initalizeViews {
    
    self.didUpdateConstraints = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.234 alpha:1.000];
    
    // Set up Origination Label
    self.originationLabel = [UILabel newAutoLayoutView];
    self.originationLabel.numberOfLines = 1;
    self.originationLabel.textColor = [UIColor lightGrayColor];
    self.originationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.originationLabel.font = [UIFont proximaNovaWithWeight:TypeWeightSemibold size:12.0];
    self.originationLabel.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:self.originationLabel];
    
    self.commentTextView = [UITextView newAutoLayoutView];
    self.commentTextView.backgroundColor = [UIColor lightGrayColor];
    self.commentTextView.editable = NO;
    self.commentTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor HNOrange]};
    self.commentTextView.selectable = YES;
    self.commentTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.commentTextView.scrollEnabled = NO;
    self.commentTextView.textContainer.lineFragmentPadding = 0;
    self.commentTextView.textContainerInset = UIEdgeInsetsMake(0, 1, 0, 0);
    [self.contentView addSubview:self.commentTextView];
    
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
    
    CGFloat textViewWidth = self.contentView.frame.size.width - (kRepliesHorizontalInset * 2);
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    self.textViewHeightConstraint.constant = CGRectGetHeight(rect) + 1;
    
//    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
//    DLogNSObject(self.textViewHeightConstraint);
}

- (void)updateConstraints {
    
    if (self.didUpdateConstraints == NO) {
        
        [self.threadLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.originationLabel];
        [self.threadLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.commentTextView];
        [self.threadLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kRepliesHorizontalInset];
        [self.threadLine autoSetDimension:ALDimensionWidth toSize:1.0 relation:NSLayoutRelationEqual];
        
        
        
        [self.originationLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.threadLine withOffset:6.0];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kRepliesVerticalInset];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];
        
        
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.originationLabel autoSetContentHuggingPriorityForAxis:ALAxisVertical];
        }];
        //
        [self.commentTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.originationLabel withOffset:kRepliesVerticalInset];
        [self.commentTextView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.threadLine withOffset:6.0];
        
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];
        [self.commentTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop
                                   ofView:self.repliesButton withOffset:-kRepliesVerticalInset relation:NSLayoutRelationEqual];
//
        
        // Replies Button Constraints
        [self.repliesButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.threadLine withOffset:6.0];
        [self.repliesButton autoSetDimension:ALDimensionHeight toSize:30.0];
        [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];
        
        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kRepliesVerticalInset];
        }];
        
        // Thread Line constraints
        

        

        self.didUpdateConstraints = YES;
    }

    CGFloat textViewWidth = self.contentView.bounds.size.width - (kRepliesHorizontalInset * 2);
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
   
    if (!self.textViewHeightConstraint) {
        self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:CGRectGetHeight(rect) + 1];
    } else {
        self.textViewHeightConstraint.constant = CGRectGetHeight(rect) + 1;
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
