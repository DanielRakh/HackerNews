//
//  HNCommentsCell.m
//  
//
//  Created by Daniel on 7/9/15.
//
//

#import "HNCommentsCommentCell.h"
#import "HNConstants.h"


//View Model
#import "HNRepliesCellViewModel.h"


@interface HNCommentsCommentCell ()

@end

@implementation HNCommentsCommentCell

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

- (void)initalizeViews {
    
    self.didUpdateConstraints = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // Set up Origination Label
    self.originationLabel = [UILabel newAutoLayoutView];
    self.originationLabel.numberOfLines = 1;
    self.originationLabel.textColor = [UIColor lightGrayColor];
    self.originationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.originationLabel.font = [UIFont proximaNovaWithWeight:TypeWeightSemibold size:12.0];
    self.originationLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.originationLabel];
    
    self.commentTextView = [UITextView newAutoLayoutView];
    self.commentTextView.backgroundColor = [UIColor clearColor];
    self.commentTextView.clipsToBounds = NO;
    self.commentTextView.editable = NO;
    self.commentTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor HNOrange]};
    self.commentTextView.selectable = YES;
    self.commentTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.commentTextView.scrollEnabled = NO;
    self.commentTextView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    self.commentTextView.textContainer.lineFragmentPadding = 0;
    self.commentTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.commentTextView.text = nil;
    self.commentTextView.font = nil;
    self.commentTextView.textColor = nil;
    self.commentTextView.textAlignment = NSTextAlignmentLeft;
    
    
    [self.contentView addSubview:self.commentTextView];
    
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    self.originationLabel.attributedText = viewModel.origination;
    self.commentTextView.attributedText = viewModel.text;

}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}



- (void)updateConstraints {
    
    if (self.didUpdateConstraints == NO) {
        
        [self.originationLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kCommentsCommentVerticalInset, kCommentsCommentHorizontalInset, 0, kCommentsCommentHorizontalInset) excludingEdge:ALEdgeBottom];
        
        [UIView autoSetPriority:996 forConstraints:^{
            [self.originationLabel autoSetContentHuggingPriorityForAxis:ALAxisVertical];
            [self.originationLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.originationLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.commentTextView withOffset:-kCommentsCommentVerticalInset relation:NSLayoutRelationEqual];
        }];
        
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsCommentHorizontalInset];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsCommentHorizontalInset];
        [UIView autoSetPriority:998 forConstraints:^{
            [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsCommentVerticalInset];
        }];
        
        [UIView autoSetPriority:749 forConstraints:^{
            self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:ceilf([self heightForWrappedTextView:self.commentTextView])];
        }];
        
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


@end
