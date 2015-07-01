//
//  HNCommentsReplyTestCell.m
//  
//
//  Created by Daniel on 6/28/15.
//
//

#import "HNCommentsReplyTestCell.h"
#import "PureLayout.h"


@interface HNCommentsReplyTestCell () <UITextViewDelegate>

@property (nonatomic) BOOL didUpdateConstraints;

@end

@implementation HNCommentsReplyTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    [self initalizeViews];
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    self.commentTextView.attributedText = viewModel.text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat textViewWidth = self.contentView.bounds.size.width - (8 * 2);
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    self.textViewHeightConstraint.constant = CGRectGetHeight(rect) + 1;
}


- (void)initalizeViews {
    
    self.didUpdateConstraints = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.234 alpha:1.000];
    
    self.commentTextView = [[UITextView alloc]initWithFrame:CGRectZero textContainer:nil];
    self.commentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.commentTextView.backgroundColor = [UIColor lightGrayColor];
    self.commentTextView.editable = NO;
    self.commentTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor]};
    self.commentTextView.selectable = YES;
    self.commentTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.commentTextView.scrollEnabled = NO;
    self.commentTextView.textContainer.lineFragmentPadding = 0;
    self.commentTextView.textContainerInset = UIEdgeInsetsMake(0, 1, 0, 0);
//    self.commentTextView.layoutManager.allowsNonContiguousLayout = NO;
    [self.contentView addSubview:self.commentTextView];
    
}

- (void)updateConstraints {
    
    if (self.didUpdateConstraints == NO) {

        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0];
//        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0 relation:NSLayoutRelationLessThanOrEqual];
        
//        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
//            [self.commentTextView autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
//            [self.commentTextView autoSetContentCompressionResistancePriorityForAxis:ALAxisHorizontal];
//
//
//        }];
////
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
//            [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0];
//            [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0];
            [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0 relation:NSLayoutRelationEqual];
//
        }];

        
//        
        [UIView autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{

        }];

//        CGFloat textViewWidth = self.contentView.bounds.size.width - (8 * 2);
//        CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//
//        if (!self.textViewHeightConstraint) {
//            self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:CGRectGetHeight(rect) + 1];
//        } else {
//            self.textViewHeightConstraint.constant = CGRectGetHeight(rect) + 1;
//        }
////
        self.didUpdateConstraints = YES;
    }

    [super updateConstraints];
}


- (CGFloat)preferredLayoutSizeFittingHeight:(CGFloat)height {
    
//    CGRect originalFrame = self.frame;
//    
//    CGRect frame = self.frame;
//    frame.size.height = height;
//    self.frame = frame;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    CGFloat computedHeight = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
//    self.frame = originalFrame;
    
    return computedHeight;
    
}

@end
