//
//  HNCommentsCardView.m
//  
//
//  Created by Daniel on 7/7/15.
//
//

#import "UIColor+HNColorPalette.h"
#import "PureLayout.h"



// View
#import "HNCommentsCardView.h"
#import "RATreeView.h"

//View Model


@interface HNCommentsCardView ()

@property (nonatomic) RATreeView *treeView;
@property (nonatomic) BOOL didSetupConstraints;


@end


@implementation HNCommentsCardView


- (instancetype)initWithViewModel:(HNCommentsCellViewModel *)viewModel {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setup];
        [self bindViewModel];
    }
    return self;
}

- (void)setup {
    
    self.didSetupConstraints = NO;
    
    self.backgroundColor = [UIColor HNWhite];
    self.layer.cornerRadius = 2.0;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor =  [UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:0.2].CGColor;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius  = 4.0;
    self.layer.shadowOpacity = 0.05;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.masksToBounds = NO;
    
    
}

- (void)bindViewModel {
    
    
}

- (void)updateConstraints {
    if (self.didSetupConstraints == NO) {
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
