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
#import <ReactiveCocoa/ReactiveCocoa.h>



CGFloat const kRepliesVerticalInset = 10;
CGFloat const kRepliesHorizontalInset = 8;

@interface HNRepliesCell ()

//@property (nonatomic) UILabel *originationLabel;
//@property (nonatomic) HNThinLineButton *repliesButton;
//@property (nonatomic) UITextView *commentTextView;

@property (nonatomic) BOOL didUpdateConstraints;
@property (nonatomic) NSLayoutConstraint *textViewHeightConstraint;

@property (nonatomic) NSMutableArray *repliesButtonConstraints;
@property (nonatomic) NSLayoutConstraint *textViewToBottomConstraint;






@end


@implementation HNRepliesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initalizeViews];
    
    
    @weakify(self);
    
    [[[RACObserve(self, expanded) ignore:nil] skip:1] subscribeNext:^(NSNumber *x) {
        NSLog(@"%@",x);
        
        @strongify(self);
        self.repliesButton.hidden = x.boolValue;
        
        if (x.boolValue == YES) {
            [self.repliesButtonConstraints autoRemoveConstraints];
            [self.contentView addConstraint:self.textViewToBottomConstraint];
        } else {
            [self.contentView removeConstraint:self.textViewToBottomConstraint];
            [self.repliesButtonConstraints autoInstallConstraints];
        }
        
    }];
}

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    self.originationLabel.attributedText = viewModel.origination;
    self.commentTextView.attributedText = viewModel.text;
    [self.repliesButton  setTitle:viewModel.repliesCount forState:UIControlStateNormal];
}

- (void)initalizeViews {
    
    self.didUpdateConstraints = NO;
    
    _repliesButtonConstraints = [NSMutableArray array];
    
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
    
    CGFloat textViewWidth = self.contentView.frame.size.width - (kRepliesHorizontalInset * 2);
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    self.textViewHeightConstraint.constant = CGRectGetHeight(rect);
    
    
    [self updateConstraintsIfNeeded];
}


- (void)updateConstraints {
    
    if (self.didUpdateConstraints == NO) {
        // Origination Label Constraints
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kRepliesHorizontalInset];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kRepliesVerticalInset];
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.originationLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        
        [self.commentTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.originationLabel withOffset:kRepliesVerticalInset];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kRepliesHorizontalInset];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];
        
       NSLayoutConstraint *textViewTop = [self.commentTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop
                                   ofView:self.repliesButton withOffset:-kRepliesVerticalInset relation:NSLayoutRelationEqual];
        
        
        // Replies Button Constraints
        NSLayoutConstraint *leading = [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kRepliesHorizontalInset];
        
        NSLayoutConstraint *height = [self.repliesButton autoSetDimension:ALDimensionHeight toSize:30.0];
        

        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            
            NSLayoutConstraint *bottom = [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kRepliesVerticalInset];
            NSLayoutConstraint *trailing = [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kRepliesHorizontalInset];

            [self.repliesButtonConstraints addObject:bottom];
            [self.repliesButtonConstraints addObject:trailing];

            
            
        }];

        
        [self.repliesButtonConstraints addObjectsFromArray:@[leading,height, textViewTop]];
        
        
        self.didUpdateConstraints = YES;
    
    }

    CGFloat textViewWidth = self.contentView.bounds.size.width - (kRepliesHorizontalInset * 2);
    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    if (!self.textViewHeightConstraint) {
        self.textViewHeightConstraint = [self.commentTextView autoSetDimension:ALDimensionHeight toSize:CGRectGetHeight(rect)];
    } else {
        self.textViewHeightConstraint.constant = CGRectGetHeight(rect);
    }

    if (!self.textViewToBottomConstraint) {
        self.textViewToBottomConstraint = [NSLayoutConstraint constraintWithItem:self.commentTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    }
    

    [super updateConstraints];
    
}


//- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
//    UITextView *calculationView = [[UITextView alloc] init];
//    [calculationView setAttributedText:text];
//    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
//    return size.height;
//}
//


@end
