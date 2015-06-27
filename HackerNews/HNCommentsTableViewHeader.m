//
//  HNCommentTableViewHeader.m
//  HackerNews
//
//  Created by Daniel on 4/22/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsTableViewHeader.h"
#import "PureLayout.h"
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"


@interface HNCommentsTableViewHeader ()

@property (nonatomic, assign) BOOL didSetupConstraints;


@end

@implementation HNCommentsTableViewHeader

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initalizeView];
    }
    return self;
}

- (void)initalizeView {
    
    self.didSetupConstraints = NO;
    
    // We are creating a rounded corner view to serve as the background
    // of the cell so we need to make the real cell background clear.
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = NO;
    
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
    
    // Set up Score Label
    self.scoreLabel = [UILabel newAutoLayoutView];
    self.scoreLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.scoreLabel.numberOfLines = 1;
    self.scoreLabel.text = NSTextAlignmentLeft;
    self.scoreLabel.textColor = [UIColor HNOrange];
    self.scoreLabel.font = [UIFont proximaNovaWithWeight:TypeWeightSemibold size:14.0];
    
    [self.cardView addSubview:self.scoreLabel];
    
    // Set up Title Label
    self.titleLabel = [UILabel newAutoLayoutView];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont proximaNovaWithWeight:TypeWeightSemibold size:18.0];
    
    [self.cardView addSubview:self.titleLabel];
    
    // Set up Info Label
    self.originationLabel = [UILabel newAutoLayoutView];
    self.originationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.originationLabel.numberOfLines = 1;
    self.originationLabel.text = NSTextAlignmentLeft;
    self.originationLabel.textColor = [UIColor lightGrayColor];
    self.originationLabel.font = [UIFont proximaNovaWithWeight:TypeWeightRegular size:12.0];
    
    [self.cardView addSubview:self.originationLabel];
    
}

- (void)updateConstraints {
    
    if (self.didSetupConstraints == NO) {
        // Card View Constraints
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0];
        [UIView autoSetPriority:750 forConstraints:^{
            [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
        }];
        
        // Score Label Constraints
        [self.scoreLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
        [self.scoreLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0];
        
        // Title Label Constraints
        [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scoreLabel withOffset:10.0 relation:NSLayoutRelationEqual];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0];
        
        // Origination Label Constraints
        [self.originationLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.titleLabel];
        [self.originationLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:10.0 relation:NSLayoutRelationEqual];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
        
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}
































@end
