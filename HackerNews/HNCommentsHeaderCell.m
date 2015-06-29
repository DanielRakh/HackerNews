//
//  HNCommentsHeaderCell.m
//  
//
//  Created by Daniel on 6/26/15.
//
//

#import "HNCommentsHeaderCell.h"
#import "PureLayout.h"
#import "UIFont+HNFont.h"
#import "UIColor+HNColorPalette.h"


@interface HNCommentsHeaderCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation HNCommentsHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
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
        [self.scoreLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0];
        
        // Title Label Constraints
        [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scoreLabel withOffset:10.0 relation:NSLayoutRelationEqual];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0];
        [self.titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.originationLabel withOffset:-10.0];

        // Origination Label Constraints
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.0];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.0];
        [self.originationLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
    
        
        self.didSetupConstraints = YES;
        
    }
    
    [super updateConstraints];
}


- (void)setup {
    
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

- (CGSize)preferredLayoutSizeFittingSize:(CGSize)targetSize {
    
    CGRect originalFrame = self.frame;
    CGFloat originalPreferredMaxLayoutWidth = self.titleLabel.preferredMaxLayoutWidth;
    
    CGRect frame = self.frame;
    frame.size = targetSize;
    self.frame = frame;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.bounds.size.width;

    
    CGSize computedSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    CGSize newSize = CGSizeMake(targetSize.width, computedSize.height);
    
    self.frame = originalFrame;
    self.titleLabel.preferredMaxLayoutWidth = originalPreferredMaxLayoutWidth;
    
    return newSize;
    
}

@end
