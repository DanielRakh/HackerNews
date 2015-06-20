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


NS_ENUM(NSUInteger, HNRepliesCellMode) {
    
    HNRepliesCellModeCollapsed = 0,
    HNRepliesCellModeCollapsedNoReplies,
    HNRepliesCellModeExpanded
};



CGFloat const kRepliesVerticalInset = 10;
CGFloat const kRepliesHorizontalInset = 8;

@interface HNCommentsReplyWithRepliesCell ()


@property (nonatomic) BOOL didUpdateConstraints;
@property (nonatomic) NSLayoutConstraint *textViewHeightConstraint;
@property (nonatomic) UIView *threadLine;

@property (nonatomic, assign) enum HNRepliesCellMode mode;

@end


@implementation HNCommentsReplyWithRepliesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setupForMode:(enum HNRepliesCellMode)mode {
    
    switch (mode) {
        case HNRepliesCellModeCollapsed:
            //
            break;
            
        case HNRepliesCellModeCollapsedNoReplies:
            //
            break;
            
        case HNRepliesCellModeExpanded:
        
            break;
            
        default:
            break;
    }
}


- (void)setup {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initalizeViews];
    
//    @weakify(self);
//    [[[RACObserve(self, expanded) ignore:nil] skip:1] subscribeNext:^(NSNumber *x) {
//        NSLog(@"%@",x);
//        
//        @strongify(self);
//        self.repliesButton.hidden = x.boolValue;
    
//        if (x.boolValue == YES) {
//            [self.repliesButtonConstraints autoRemoveConstraints];
//            [self.contentView addConstraint:self.textViewToBottomConstraint];
//        } else {
//            [self.contentView removeConstraint:self.textViewToBottomConstraint];
//            [self.repliesButtonConstraints autoInstallConstraints];
//        }
        
//    }];
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    self.originationLabel.attributedText = viewModel.origination;
    self.commentTextView.attributedText = viewModel.text;
    
    if (viewModel.repliesCount > 0) {
        NSString *title = viewModel.repliesCount == 1 ? [NSString stringWithFormat:@"1 Reply"] : [NSString stringWithFormat:@"%ld Replies",viewModel.repliesCount];
        [self.repliesButton setTitle:title forState:UIControlStateNormal];
    } else {
        [self.repliesButton setTitle:nil forState:UIControlStateNormal];
    }
    
    
}

- (void)initalizeViews {
    
    self.didUpdateConstraints = NO;
    
    _repliesButtonConstraints = [NSMutableArray array];
//    _threadLineConstraints = [NSMutableArray array];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // Set up Origination Label
    self.originationLabel = [UILabel newAutoLayoutView];
    self.originationLabel.numberOfLines = 1;
    self.originationLabel.textColor = [UIColor lightGrayColor];
    self.originationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.originationLabel.font = [UIFont proximaNovaWithWeight:TypeWeightSemibold size:12.0];
    self.originationLabel.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:self.originationLabel];
    
    self.commentTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    self.commentTextView.translatesAutoresizingMaskIntoConstraints = NO;
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

//
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat textViewWidth = self.contentView.frame.size.width - (kRepliesHorizontalInset * 2);
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    self.textViewHeightConstraint.constant = CGRectGetHeight(rect) + 1;
    
    [self updateConstraintsIfNeeded];
}


- (void)updateConstraints {
    
    if (self.didUpdateConstraints == NO) {
        // Origination Label Constraints
        [self.originationLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.commentTextView];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kRepliesVerticalInset];
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
//            [self.originationLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            [self.originationLabel autoSetContentHuggingPriorityForAxis:ALAxisVertical];
        }];
//
        [self.commentTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.originationLabel withOffset:kRepliesVerticalInset];
        self.commentTextViewToThreadline = [self.commentTextView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.threadLine withOffset:6.0];
        
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];
        [self.commentTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop
                                   ofView:self.repliesButton withOffset:-kRepliesVerticalInset relation:NSLayoutRelationEqual];
        
        
        // Replies Button Constraints
        [self.repliesButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.commentTextView];

        NSLayoutConstraint *height = [self.repliesButton autoSetDimension:ALDimensionHeight toSize:30.0];
        [self.repliesButtonConstraints addObject:height];

        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            NSLayoutConstraint *bottom = [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kRepliesVerticalInset];
            [self.repliesButtonConstraints addObject:bottom];
           [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];
        }];
        
        // Thread Line constraints
        
        [self.threadLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.originationLabel];
        [self.threadLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.commentTextView];
        
        self.leadingThreadLineConstraint = [self.threadLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kRepliesHorizontalInset];
        self.widthThreadLineConstraint = [self.threadLine autoSetDimension:ALDimensionWidth toSize:1.0 relation:NSLayoutRelationEqual];
      
        
        
        
        self.didUpdateConstraints = YES;
    }

    CGFloat textViewWidth = self.contentView.bounds.size.width - (kRepliesHorizontalInset * 2);
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
   
    if (!self.textViewHeightConstraint) {
        self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:CGRectGetHeight(rect) + 1];
    } else {
        self.textViewHeightConstraint.constant = CGRectGetHeight(rect) + 1;
    }
//
//    if (!self.textViewToBottomConstraint) {
//        self.textViewToBottomConstraint = [NSLayoutConstraint constraintWithItem:self.commentTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
//        self.textViewToBottomConstraint.priority = UILayoutPriorityRequired;
////        [self.contentView addConstraint:self.textViewToBottomConstraint];
//    }
    

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
