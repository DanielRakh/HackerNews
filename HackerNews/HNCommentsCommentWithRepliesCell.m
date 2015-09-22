//
//  HNCommentsRootWithRepliesCell.m
//  HackerNews
//
//  Created by Daniel on 6/20/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCommentWithRepliesCell.h"
#import "HNConstants.h"

//View
#import "HNThinLineButton.h"

//View Model
#import "HNRepliesCellViewModel.h"


@implementation HNCommentsCommentWithRepliesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupRepliesButton];
        self.didUpdateTextView = NO;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRepliesButton];
        self.didUpdateTextView = NO;
    }
    return self;
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    [super configureWithViewModel:viewModel];
    
    [self.repliesButton setTitle:viewModel.repliesCount == 1 ? [NSString stringWithFormat:@"1 Reply"] : [NSString stringWithFormat:@"%ld Replies",(long)viewModel.repliesCount] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setupRepliesButton {
    
//    [super initalizeViews];
    //Set up Comments Button
    self.repliesButton = [HNThinLineButton newAutoLayoutView];
    self.repliesButton.titleLabel.font = [UIFont avenirNextWithWeight:ANTypeWeightRegular size:12.0];
    [self.repliesButton addTarget:self action:@selector(repliesButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    self.repliesButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.repliesButton];
}


- (void)updateConstraints {
    
    if (self.didUpdateConstraints == NO) {
        
        [self.originationLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kCommentsCommentVerticalInset, kCommentsCommentHorizontalInset, 0, kCommentsCommentHorizontalInset) excludingEdge:ALEdgeBottom];
        
//        [UIView autoSetPriority:996 forConstraints:^{
//            [self.originationLabel autoSetContentHuggingPriorityForAxis:ALAxisVertical];
//            [self.originationLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
//        }];
//        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
//            [self.originationLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.commentTextView withOffset:-kCommentsCommentVerticalInset relation:NSLayoutRelationEqual];
//        }];
    
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsCommentHorizontalInset];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsCommentHorizontalInset];
//        [UIView autoSetPriority:998 forConstraints:^{
//            [self.commentTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.repliesButton withOffset:-kCommentsCommentVerticalInset relation:NSLayoutRelationEqual];
//        }];
//
//        [UIView autoSetPriority:749 forConstraints:^{
//            self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:ceilf([self heightForWrappedTextView:self.commentTextView])];
//        }];

        [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsCommentHorizontalInset];
        [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsCommentHorizontalInset];
        [self.repliesButton autoSetDimension:ALDimensionHeight toSize:30.0];
        
//        [UIView autoSetPriority:997 forConstraints:^{
//            [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsCommentVerticalInset];
//            
//        }];
        
        // Thread Line constraints
        self.didUpdateConstraints = YES;
    }
    
    if (self.didUpdateTextView == NO) {
        self.textViewHeightConstraint.constant = ceilf([self heightForWrappedTextView:self.commentTextView]);
    }

    [super updateConstraints];
}


- (CGFloat)heightForWrappedTextView:(UITextView *)textView {

    CGFloat wrappingWidth = [UIScreen mainScreen].bounds.size.width - (2 * kCardViewHorizontalInset) - (2 * kCommentsCommentHorizontalInset);
    
    CGRect rect = [textView.attributedText boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return CGRectGetHeight(rect);
}

#pragma mark-
#pragma mark - Actions
- (void)repliesButtonDidTap:(id)sender {
    if (self.repliesButtonDidTapAction) {
        self.repliesButtonDidTapAction(sender);
    }
}


@end