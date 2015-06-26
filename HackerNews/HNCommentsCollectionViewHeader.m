//
//  HNCommentsCollectionViewHeader.m
//  HackerNews
//
//  Created by Daniel on 6/25/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCollectionViewHeader.h"
#import "UIColor+HNColorPalette.h"

@implementation HNCommentsCollectionViewHeader

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


-(instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}



- (void)setup {
    
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
    
    
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 0;
    self.originationLabel.textColor = [UIColor HNLightGray];
    self.scoreLabel.textColor = [UIColor HNOrange];
    
}

@end
