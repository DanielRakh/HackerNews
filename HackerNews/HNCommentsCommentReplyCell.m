//
//  HNCommentsReplyCell.m
//  HackerNews
//
//  Created by Daniel on 6/20/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCommentReplyCell.h"
#import "HNConstants.h"
#import "HNRepliesCellViewModel.h"

@interface HNCommentsCommentReplyCell ()

//@property (nonatomic) UIView *threadLine;
//@property (nonatomic) NSInteger level;
@property (nonatomic) NSMutableArray *threadLines;
@property (nonatomic) UIView *lastThreadLine;
//@property (nonatomic, assign) BOOL shouldSetupConstraints;


@end

@implementation HNCommentsCommentReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupThreadView];
        _threadLines = [NSMutableArray array];
//        _shouldSetupConstraints = NO;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupThreadView];
        _threadLines = [NSMutableArray array];
//        _shouldSetupConstraints = NO;
    }
    return self;
}


- (void)setupThreadLinesForLevel:(NSInteger)level {
    
    for (int i = 0; i < level; i++) {
        UIView *threadLine = [UIView newAutoLayoutView];
        threadLine.backgroundColor = [UIColor colorWithRed:0.988 green:0.400 blue:0.129 alpha:1.0 / level];
        [self.threadLines addObject:threadLine];
        [self.contentView addSubview:threadLine];
        
        if (i == level - 1) {
            //This is the last threadline
            self.lastThreadLine = threadLine;
        }
    }
//    self.shouldSetupConstraints = YES;
}

- (void)setupThreadView {
    
    //Testing

    self.commentTextView.backgroundColor = [UIColor darkGrayColor];
//    self.threadLine = [UIView newAutoLayoutView];

//    self.contentView.backgroundColor = [UIColor blueColor];
//    [self.contentView addSubview:self.threadLine];
    
    
    // I need to check level of cell and add the number of threadlines according to level
    // So level 2 would be two threadlines. One on the same indentation as the parent and one 8 pts apart with a lighter shade.
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    [super configureWithViewModel:viewModel];
    self.originationLabel.text = [NSString stringWithFormat:@"%ld",viewModel.treeLevel];
    self.hasReplies = viewModel.repliesCount > 0;
    [self setupThreadLinesForLevel:viewModel.treeLevel];

}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}



- (void)updateConstraints {
    
    if (self.didUpdateConstraints == NO) {
        
        
        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            
            //Pin every threadline except the last one the top.
            
            [self.threadLines enumerateObjectsUsingBlock:^(UIView *threadline, NSUInteger idx, BOOL *stop) {
                if (idx == self.threadLines.count - 1) {
                    // Last threadlone
                    [threadline autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.originationLabel];
                } else {
                    [threadline autoPinEdgeToSuperviewEdge:ALEdgeTop];
                    
                }
                
                if (self.hasReplies == YES) {
                    [threadline autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                } else {
                    [threadline autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.commentTextView];
                }
            }];
        }];
        
        
        
        
        [self.threadLines enumerateObjectsUsingBlock:^(UIView *threadLine, NSUInteger idx, BOOL *stop) {
            // Pin 0 to the leading. Pin 1 to 0. Pin 2 to 1. Pin 3 to 2.
            // Pin view at idx to view at idx - 1 if idx == 1;
            //
            
            threadLine.tag = idx + 1;
            
            if (idx == 0) {
                [threadLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsCommentHorizontalInset];
            } else {
                [threadLine autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:[self.contentView viewWithTag:idx] withOffset:kCommentsCommentHorizontalInset];
            }
            
            [threadLine autoSetDimension:ALDimensionWidth toSize:2.0];
        }];
        
        
        
        
        
        [self.originationLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.lastThreadLine withOffset:kCommentsCommentsHorizontalThreadLineToTextInset];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCommentsCommentVerticalInset];
        
        
        [UIView autoSetPriority:996 forConstraints:^{
            [self.originationLabel autoSetContentHuggingPriorityForAxis:ALAxisVertical];
            [self.originationLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.originationLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.commentTextView withOffset:-kCommentsCommentVerticalInset relation:NSLayoutRelationEqual];
        }];
        
        [self.commentTextView autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.lastThreadLine withOffset:kCommentsCommentsHorizontalThreadLineToTextInset];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsCommentHorizontalInset];
        [UIView autoSetPriority:998 forConstraints:^{
            [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsCommentVerticalInset];
        }];
        
        [UIView autoSetPriority:749 forConstraints:^{
            self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:ceilf([self heightForWrappedTextView:self.commentTextView])];
        }];
        
        
        
        self.didUpdateConstraints = YES;
        self.didUpdateTextView = YES;
//        self.shouldSetupConstraints = NO;
    }
    
    
    self.textViewHeightConstraint.constant = ceilf([self heightForWrappedTextView:self.commentTextView]);
    
    
    [super updateConstraints];
}



- (CGFloat)heightForWrappedTextView:(UITextView *)textView {
    
    CGFloat wrappingWidth = [UIScreen mainScreen].bounds.size.width - (2 * kCardViewHorizontalInset) - ((1 + self.treeLevel) * kCommentsCommentHorizontalInset) - kCommentsCommentsHorizontalThreadLineToTextInset - 2;
    
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return CGRectGetHeight(rect);
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.threadLines removeAllObjects];
}


@end
