//
//  HNCommentsCell.m
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "PureLayout.h"
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"

//View
#import "HNCommentsCell.h"
#import "HNThinLineButton.h"

//View Model
#import "HNCommentsCellViewModel.h"


CGFloat const kCommentsVerticalInset = 10;
CGFloat const kCommentsHorizontalInset = 8;


@interface HNCommentsCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;


@property (nonatomic) UIView *cardView;
@property (nonatomic) UILabel *originationLabel;
@property (nonatomic) HNThinLineButton *repliesButton;
@property (nonatomic) UITextView *commentTextView;

@property (nonatomic) HNCommentsCellViewModel *viewModel;

@end

@implementation HNCommentsCell

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

- (void)configureWithViewModel:(HNCommentsCellViewModel *)viewModel {
    self.viewModel = viewModel;
    self.originationLabel.attributedText = viewModel.origination;
    self.commentTextView.attributedText = viewModel.text;
    [self.repliesButton setTitle:viewModel.repliesCount forState:UIControlStateNormal];
}

- (void)initalizeViews {
    
    self.didSetupConstraints = NO;
    // We are creating a rounded corner view to serve as the background
    // of the cell so we need to make the real cell background clear.
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // Set up Card View - rounded corner cell background
    self.cardView = [UIView newAutoLayoutView];
    self.cardView.backgroundColor = [UIColor HNWhite];
    self.cardView.layer.cornerRadius = 2.0;
    self.cardView.layer.borderWidth = 0.5;
    self.cardView.layer.borderColor =  [UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:0.2].CGColor;
    
    
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowRadius  = 4.0;
    self.cardView.layer.shadowOpacity = 0.05;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 1);
    self.cardView.layer.shouldRasterize = YES;
    self.cardView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.cardView.layer.masksToBounds = NO;
    
    [self.contentView addSubview:self.cardView];

    
    
    // Set up Origination Label
    self.originationLabel = [UILabel newAutoLayoutView];
    self.originationLabel.numberOfLines = 1;
    self.originationLabel.textColor = [UIColor lightGrayColor];
    self.originationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.originationLabel.font = [UIFont proximaNovaWithWeight:TypeWeightSemibold size:12.0];
    
    [self.cardView addSubview:self.originationLabel];

    
    self.commentTextView = [UITextView newAutoLayoutView];
    self.commentTextView.editable = NO;
    self.commentTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor HNOrange]};
    self.commentTextView.scrollEnabled = NO;
    self.commentTextView.selectable = YES;
    self.commentTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.commentTextView.scrollEnabled = NO;
    self.commentTextView.textContainer.lineFragmentPadding = 0;
    self.commentTextView.textContainerInset = UIEdgeInsetsZero;
    
    [self.cardView addSubview:self.commentTextView];
    
    
    //Set up Comments Button
    self.repliesButton = [HNThinLineButton newAutoLayoutView];
    self.repliesButton.titleLabel.font = [UIFont proximaNovaWithWeight:TypeWeightRegular size:12.0];
    [self.cardView addSubview:self.repliesButton];

    
    /*
    // Set up Score Label
    self.scoreLabel = [UILabel newAutoLayoutView];
    self.scoreLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.scoreLabel.numberOfLines = 1;
    self.scoreLabel.text = NSTextAlignmentLeft;
    self.scoreLabel.textColor = [UIColor HNOrange];
    self.scoreLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:10.0];
    
    [self.cardView addSubview:self.scoreLabel];
    */
}

-(void)updateConstraints {
    
    if (self.didSetupConstraints == NO) {
        
        // Card View Constraints
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
        [UIView autoSetPriority:750 forConstraints:^{
            [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
        }];
        
        // Origination Label Constraints
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCommentsVerticalInset];
    
        // Comment Text View Constraints
        [self.commentTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.originationLabel withOffset:kCommentsVerticalInset];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.commentTextView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];

        // Replies Button Constraints
        [self.repliesButton autoSetDimension:ALDimensionHeight toSize:30.0];
        [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
        [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.repliesButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
        [self.repliesButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.commentTextView withOffset:kCommentsVerticalInset relation:NSLayoutRelationEqual];

        self.didSetupConstraints = YES;
    }
    
    
    [super updateConstraints];
}

@end
