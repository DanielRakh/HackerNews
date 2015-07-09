//
//  HNCommentsHeaderCardView.m
//  
//
//  Created by Daniel on 7/9/15.
//
//

#import "HNCommentsHeaderCardView.h"
#import "PureLayout.h"
#import "UIFont+HNFont.h"
#import "UIColor+HNColorPalette.h"

@interface HNCommentsHeaderCardView ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation HNCommentsHeaderCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.didSetupConstraints = NO;
    
    // Set up Score Label
    self.scoreLabel = [UILabel newAutoLayoutView];
    self.scoreLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.scoreLabel.numberOfLines = 1;
    self.scoreLabel.text = NSTextAlignmentLeft;
    self.scoreLabel.textColor = [UIColor HNOrange];
    self.scoreLabel.font = [UIFont proximaNovaWithWeight:TypeWeightSemibold size:14.0];
    
    [self addSubview:self.scoreLabel];
    
    // Set up Title Label
    self.titleLabel = [UILabel newAutoLayoutView];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont proximaNovaWithWeight:TypeWeightSemibold size:18.0];
    
    [self addSubview:self.titleLabel];
    
    // Set up Info Label
    self.originationLabel = [UILabel newAutoLayoutView];
    self.originationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.originationLabel.numberOfLines = 1;
    self.originationLabel.text = NSTextAlignmentLeft;
    self.originationLabel.textColor = [UIColor lightGrayColor];
    self.originationLabel.font = [UIFont proximaNovaWithWeight:TypeWeightRegular size:12.0];
    
    [self addSubview:self.originationLabel];
    
}

- (void)updateConstraints {
    
    if (self.didSetupConstraints == NO) {

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
