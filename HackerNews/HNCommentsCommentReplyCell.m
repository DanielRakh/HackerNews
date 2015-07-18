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
@property (nonatomic) HNRepliesCellViewModel *viewModel;
//@property (nonatomic, assign) BOOL shouldSetupConstraints;


@end

@implementation HNCommentsCommentReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupThreadView];
        _threadLines = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupThreadView];
        _threadLines = [NSMutableArray array];
    }
    return self;
}


- (void)setupThreadLinesForLevel:(NSInteger)level {
    
    if (self.threadLines.count > 0) {
        [self.threadLines removeAllObjects];
    }
    
    for (int i = 0; i < level; i++) {
        UIView *threadLine = [[UIView alloc]initForAutoLayout];
        threadLine.backgroundColor = [UIColor colorWithRed:0.988 green:0.400 blue:0.129 alpha:1.0 / (i + 1)];
        [self.threadLines addObject:threadLine];
        [self.contentView addSubview:threadLine];
//        self.lastThreadLine = threadLine;
        
        if (i == level - 1) {
            //This is the last threadline
            self.lastThreadLine = threadLine;
        }
    }
}

- (void)setupThreadView {
    
    //Testing
    self.originationLabel.backgroundColor = [UIColor blackColor];
    self.commentTextView.backgroundColor = [UIColor lightGrayColor];
    self.contentView.backgroundColor = [UIColor blueColor];


}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    [super configureWithViewModel:viewModel];
    self.viewModel = viewModel;
//    self.originationLabel.text = [NSString stringWithFormat:@"%ld",viewModel.treeLevel];
    self.originationLabel.attributedText = viewModel.origination;
    self.hasReplies = viewModel.repliesCount > 0;
    
    
    [self setupThreadLinesForLevel:viewModel.treeLevel];

}

- (void)updateConstraints {
    
    if (self.didUpdateConstraints == NO) {
        
        [self.threadLines enumerateObjectsUsingBlock:^(UIView *threadline, NSUInteger idx, BOOL *stop) {
            
            [threadline autoSetDimension:ALDimensionWidth toSize:2.0];

            
            if ([threadline isEqual:self.lastThreadLine]) {
                // Last threadlone
//                [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
                    //Pin every threadline except the last one the top.
                [threadline autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.originationLabel withOffset:2.0];
//                }];
            } else {
//                [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
                    [threadline autoPinEdgeToSuperviewEdge:ALEdgeTop];
//                }];
                
            }
            


            
            if (self.hasReplies == YES) {
//                [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
                    [threadline autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//                }];
                
            } else {
//                [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
//                    [threadline autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.commentTextView withOffset:-2.0];
//                }];
                
                [threadline autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2.0];
            }
        }];
        
        
        [self.threadLines enumerateObjectsUsingBlock:^(UIView *threadLine, NSUInteger idx, BOOL *stop) {
            // Pin 0 to the leading. Pin 1 to 0. Pin 2 to 1. Pin 3 to 2.
            // Pin view at idx to view at idx - 1 if idx == 1;
            //
            
            
            
            threadLine.tag = idx + 10;
            
            
            if (idx == 0) {
                [threadLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsCommentHorizontalInset];
            } else {
                
                [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
                         [threadLine autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:[self.contentView viewWithTag:idx + 9] withOffset:kCommentsCommentHorizontalInset];
                }];
   

            }
            
        }];
        
        
        [self.originationLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.lastThreadLine withOffset:kCommentsCommentsHorizontalThreadLineToTextInset];
        
//        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCommentsCommentVerticalInset];
        
        
        [UIView autoSetPriority:996 forConstraints:^{
            [self.originationLabel autoSetContentHuggingPriorityForAxis:ALAxisVertical];
            [self.originationLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
//            [self.originationLabel autoSetContentHuggingPriorityForAxis:ALAxisHorizontal];
//            [self.originationLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
        }];
        
        
        
        
        [self.originationLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.commentTextView withOffset:-kCommentsCommentVerticalInset relation:NSLayoutRelationEqual];
        
    
        

        [self.commentTextView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.originationLabel withOffset:0];

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
        
    CGFloat wrappingWidth = [UIScreen mainScreen].bounds.size.width - (2 * kCardViewHorizontalInset) - ((1 + self.threadLines.count) * kCommentsCommentHorizontalInset) - kCommentsCommentsHorizontalThreadLineToTextInset - (2 * self.threadLines.count) - 1;
    
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return CGRectGetHeight(rect);
    
}

//- (void)prepareForReuse {
//    [super prepareForReuse];
//
//    [self.lastThreadLine removeFromSuperview];
//    self.lastThreadLine = nil;
//}
@end
