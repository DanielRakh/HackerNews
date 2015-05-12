//
//  HNRepliesCell.m
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNRepliesCell.h"
#import "PureLayout.h"
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"
#import "HNThinLineButton.h"
#import "HNRepliesCellViewModel.h"



CGFloat const kRepliesVerticalInset = 10;
CGFloat const kRepliesHorizontalInset = 8;

@interface HNRepliesCell ()

//@property (nonatomic) UILabel *originationLabel;
//@property (nonatomic) HNThinLineButton *repliesButton;
//@property (nonatomic) UITextView *commentTextView;

@property (nonatomic) BOOL didUpdateConstraints;
@property (nonatomic) NSLayoutConstraint *textViewHeightConstraint;


@end


@implementation HNRepliesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initalizeViews];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initalizeViews];
        
    }
    return self;
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    self.originationLabel.attributedText = viewModel.origination;
    self.commentTextView.attributedText = viewModel.text;
    [self.repliesButton  setTitle:viewModel.repliesCount forState:UIControlStateNormal];
    

    
    
//    float textViewWidth  = self.commentTextView.frame.size.width;
//    [self layoutIfNeeded];
//    self.commentTextView.contentSize = [self.commentTextView sizeThatFits:CGSizeMake(textViewWidth, FLT_MAX)];
//    [self.commentTextView sizeToFit];
//    [self.commentTextView layoutIfNeeded];
//    [self.commentTextView setNeedsUpdateConstraints];
//    [self.commentTextView updateConstraintsIfNeeded];
    
}

- (void)initalizeViews {
    
    
    self.didUpdateConstraints = NO;
    
    self.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor blueColor];
    
    // Set up Origination Label
    self.originationLabel = [UILabel newAutoLayoutView];
    self.originationLabel.numberOfLines = 1;
    self.originationLabel.textColor = [UIColor lightGrayColor];
    self.originationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.originationLabel.font = [UIFont proximaNovaWithWeight:TypeWeightSemibold size:12.0];
    self.originationLabel.backgroundColor = [UIColor magentaColor];
    
    [self.contentView addSubview:self.originationLabel];
    
    
    self.commentTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    self.commentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.commentTextView.backgroundColor = [UIColor orangeColor];
    self.commentTextView.editable = NO;
    self.commentTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor HNOrange]};
    self.commentTextView.selectable = YES;
    self.commentTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.commentTextView.scrollEnabled = NO;
    self.commentTextView.textContainer.lineFragmentPadding = 0;
    self.commentTextView.textContainerInset = UIEdgeInsetsZero;
//
    
    [self.contentView addSubview:self.commentTextView];
    
    
    //Set up Comments Button
    self.repliesButton = [HNThinLineButton newAutoLayoutView];
    self.repliesButton.titleLabel.font = [UIFont proximaNovaWithWeight:TypeWeightRegular size:12.0];
    [self.contentView addSubview:self.repliesButton];
    
}

//
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
//    self.textViewHeightConstraint.constant = [self textViewHeightForAttributedText:self.commentTextView.attributedText andWidth:self.contentView.bounds.size.width];
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
//    [self.contentView setNeedsLayout];
//    [self.contentView layoutIfNeeded];
    
//}


//    [self layoutIfNeeded];
//    [super layoutSubviews];
////
CGFloat textViewWidth = self.commentTextView.frame.size.width;
CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
self.textViewHeightConstraint.constant = CGRectGetHeight(rect);
[self setNeedsUpdateConstraints];
[self updateConstraintsIfNeeded];
}


- (void)updateConstraints {
    
//    if (self.didUpdateConstraints == NO) {
        // Origination Label Constraints
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kRepliesHorizontalInset];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kRepliesVerticalInset];
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.originationLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        
        [self.commentTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.originationLabel withOffset:kRepliesVerticalInset];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kRepliesHorizontalInset];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];
        [self.commentTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop
                                   ofView:self.repliesButton withOffset:-kRepliesVerticalInset relation:NSLayoutRelationEqual];
        
        
        
        
        // Replies Button Constraints
        [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];
        [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kRepliesHorizontalInset];
        [self.repliesButton autoSetDimension:ALDimensionHeight toSize:30.0];

    
    
    
        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            if (self.textViewHeightConstraint) {
                CGFloat height = [self textViewHeightForAttributedText:self.commentTextView.attributedText andWidth:self.contentView.bounds.size.width];
                self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:height];
            }
            [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kRepliesVerticalInset];

        }];
        
        self.didUpdateConstraints = YES;
//    }
    
     [super updateConstraints];
    
}





- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}
     
     
@end
