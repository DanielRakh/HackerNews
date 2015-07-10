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
#import "HNConstants.h"

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

@end


@implementation HNCommentsReplyWithRepliesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupThreadView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupThreadView];
    }
    return self;
}

- (void)setupThreadView {

//    [super initalizeViews];
    
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
        [self.threadLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsCommentHorizontalInset];
        [self.threadLine autoSetDimension:ALDimensionWidth toSize:1.0 relation:NSLayoutRelationEqual];
        
        
        [self.originationLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.threadLine withOffset:kCommentsCommentsHorizontalThreadLineToTextInset];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCommentsCommentVerticalInset];

        
        [UIView autoSetPriority:996 forConstraints:^{
            [self.originationLabel autoSetContentHuggingPriorityForAxis:ALAxisVertical];
            [self.originationLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.originationLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.commentTextView withOffset:-kCommentsCommentVerticalInset relation:NSLayoutRelationEqual];
        }];
        
        
        [self.commentTextView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.threadLine withOffset:kCommentsCommentsHorizontalThreadLineToTextInset];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsCommentHorizontalInset];
        [UIView autoSetPriority:998 forConstraints:^{
            [self.commentTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.repliesButton withOffset:-kCommentsCommentVerticalInset relation:NSLayoutRelationEqual];
        }];
        

        [self.repliesButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.threadLine withOffset:kCommentsCommentsHorizontalThreadLineToTextInset];
        [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsCommentHorizontalInset];
        [self.repliesButton autoSetDimension:ALDimensionHeight toSize:30.0];
      
        [UIView autoSetPriority:997 forConstraints:^{
            [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsCommentVerticalInset];

        }];
        
        // Thread Line constraints
        self.didUpdateConstraints = YES;
    }
    
//    CGFloat wrappingWidth = [UIScreen mainScreen].bounds.size.width - 18 - 24;
    
    CGFloat wrappingWidth = [UIScreen mainScreen].bounds.size.width - (2 * kCardViewHorizontalInset) - (2 * kCommentsCommentHorizontalInset) - kCommentsCommentsHorizontalThreadLineToTextInset - self.threadLine.bounds.size.width;

    
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

    
    if (!self.textViewHeightConstraint) {
        [UIView autoSetPriority:749 forConstraints:^{
        self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:ceilf(CGRectGetHeight(rect))];
        }];
        
        self.didUpdateTextView = YES;
        
    } else {
        self.textViewHeightConstraint.constant = ceilf(CGRectGetHeight(rect));
        self.didUpdateTextView = YES;
    }
    
    [super updateConstraints];
}

@end
