//
//  HNFeedTableViewCell.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNFeedTableViewCell.h"
#import "PureLayout.h"
#import "HNThinLineButton.h"
#import "UIColor+HNColorPalette.h"

CGFloat const kCardViewInset = 10;
CGFloat const kInnerViewInset = 8;


@interface HNFeedTableViewCell ()

@property (nonatomic) UIView *cardView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *infoLabel;
@property (nonatomic) HNThinLineButton *commentsButton;

@property (nonatomic, assign) BOOL didSetupConstraints;


@end

@implementation HNFeedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initalizeViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initalizeViews];
    }
    return self;
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
    self.cardView.layer.cornerRadius = 8.0;
    self.cardView.layer.borderWidth = 0.5;
    self.cardView.layer.borderColor =  [UIColor HNLightGray].CGColor;
    
    [self.contentView addSubview:self.cardView];
    
    
    // Set up Title Label
    self.titleLabel = [UILabel newAutoLayoutView];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.cardView addSubview:self.titleLabel];
    
    
    // Set up Info Label
    self.infoLabel = [UILabel newAutoLayoutView];
    self.infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.infoLabel.numberOfLines = 1;
    self.infoLabel.text = NSTextAlignmentLeft;
    self.infoLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10.0];
    
    [self.cardView addSubview:self.infoLabel];
    
    
    // Set up Comments Button
    self.commentsButton = [HNThinLineButton newAutoLayoutView];
    [self.cardView addSubview:self.commentsButton];

}

-(void)updateConstraints {
    
    if (self.didSetupConstraints == NO) {
       
        // Card View Constraints
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCardViewInset];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCardViewInset];
        [UIView autoSetPriority:750 forConstraints:^{
            [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCardViewInset];
        }];
        
        // Title Label Constraints
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCardViewInset];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCardViewInset];
        

        
        // Comments Button Constraints
        [self.commentsButton autoSetDimensionsToSize:CGSizeMake(84, 26)];
        [self.commentsButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCardViewInset];
         [self.commentsButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCardViewInset];
        [self.commentsButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:14.0 relation:NSLayoutRelationEqual];
        
        
        // Info Label Constraints
        
        [self.infoLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.titleLabel];
        [self.infoLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.commentsButton];
        
        
        self.didSetupConstraints = YES;
    }
    
    
    [super updateConstraints];
}



@end
