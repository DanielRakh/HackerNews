//
//  HNCommentsReplyCell.m
//  HackerNews
//
//  Created by Daniel on 6/20/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCommentReplyCell.h"
#import "HNConstants.h"

@interface HNCommentsCommentReplyCell ()

@property (nonatomic) UIView *threadLine;

@end

@implementation HNCommentsCommentReplyCell

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
    
    self.threadLine = [UIView newAutoLayoutView];
    self.threadLine.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.threadLine];
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
            [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsCommentVerticalInset];
        }];
        
        [UIView autoSetPriority:749 forConstraints:^{
            self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:ceilf([self heightForWrappedTextView:self.commentTextView])];
        }];
        
        
        
        self.didUpdateConstraints = YES; 
    }
    
    
    self.textViewHeightConstraint.constant = ceilf([self heightForWrappedTextView:self.commentTextView]);
    
    
    [super updateConstraints];
}


- (CGFloat)heightForWrappedTextView:(UITextView *)textView {
    
    CGFloat wrappingWidth = [UIScreen mainScreen].bounds.size.width - (2 * kCardViewHorizontalInset) - (2 * kCommentsCommentHorizontalInset) - kCommentsCommentsHorizontalThreadLineToTextInset - 1;
    
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return CGRectGetHeight(rect);
    
}


@end
