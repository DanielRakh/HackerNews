//
//  HNPostTableViewCell.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNPostTableViewCell.h"
#import "UIColor+HNColorPalette.h"

@interface HNPostTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *cardView;

@end

@implementation HNPostTableViewCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // Set up Card View - rounded corner cell background
    self.cardView.backgroundColor = [UIColor HNWhite];
    self.cardView.layer.cornerRadius = 8.0;
    self.cardView.layer.borderWidth = 0.5;
    self.cardView.layer.borderColor =  [UIColor HNLightGray].CGColor;
    
    self.titleLabel.numberOfLines = 0;
}

@end
