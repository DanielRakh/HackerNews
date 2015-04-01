//
//  HNThinLineButton.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNThinLineButton.h"
#import "UIColor+HNColorPalette.h"

@implementation HNThinLineButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize {
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 4.0;
    self.layer.borderColor = [UIColor HNOrange].CGColor;
    self.layer.borderWidth = 0.5;
    self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10.0];
    [self setTitleColor:[UIColor HNOrange] forState:UIControlStateNormal];
    [self setTitle:@"10 Comments" forState:UIControlStateNormal];
    
}


@end
