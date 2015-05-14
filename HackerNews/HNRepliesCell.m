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
}

- (void)initalizeViews {
    
    
    self.didUpdateConstraints = NO;
    
    self.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor darkGrayColor];
    
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
    
    CGFloat textViewWidth = self.commentTextView.frame.size.width;
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    self.textViewHeightConstraint.constant = CGRectGetHeight(rect);
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}


- (void)updateConstraints {
    
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
                CGFloat textViewWidth = self.commentTextView.frame.size.width;
                CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
                self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:CGRectGetHeight(rect)];
            }
            [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kRepliesVerticalInset];

        }];

    
     [super updateConstraints];
    
}

     
@end
