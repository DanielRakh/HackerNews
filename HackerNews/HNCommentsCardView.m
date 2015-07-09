//
//  HNCommentsCardView.m
//  
//
//  Created by Daniel on 7/7/15.
//
//

#import "UIColor+HNColorPalette.h"
#import "HNCommentsCardView.h"

@implementation HNCommentsCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    
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



@end
