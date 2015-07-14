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
//@property (nonatomic) NSInteger level;

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
    
    //Testing

    self.commentTextView.backgroundColor = [UIColor lightGrayColor];
    self.threadLine = [UIView newAutoLayoutView];
    self.threadLine.backgroundColor = [UIColor orangeColor];
//    self.contentView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.threadLine];
    
    
    // I need to check level of cell and add the number of threadlines according to level
    // So level 2 would be two threadlines. One on the same indentation as the parent and one 8 pts apart with a lighter shade.
    
    
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    [super configureWithViewModel:viewModel];
    self.originationLabel.text = [NSString stringWithFormat:@"%ld",self.treeLevel];
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
        
        DLog(@"%ld",self.treeLevel);
        [self.threadLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsCommentHorizontalInset * self.treeLevel];
        [self.threadLine autoSetDimension:ALDimensionWidth toSize:2.0 relation:NSLayoutRelationEqual];
        
        
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
        self.didUpdateTextView = YES;
    }
    
    
    self.textViewHeightConstraint.constant = ceilf([self heightForWrappedTextView:self.commentTextView]);
    
    
    [super updateConstraints];
}


- (CGFloat)heightForWrappedTextView:(UITextView *)textView {
    
    
     
//    NSInteger tst = (1 + self.treeLevel) * kCommentsCommentHorizontalInset;
//    DLog(@"%ld",tst);
    
    CGFloat wrappingWidth = [UIScreen mainScreen].bounds.size.width - (2 * kCardViewHorizontalInset) - ((1 + self.treeLevel) * kCommentsCommentHorizontalInset) - kCommentsCommentsHorizontalThreadLineToTextInset - 2;
    
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return CGRectGetHeight(rect);
    
}


@end
