//
//  HNCommentsHeaderCell.m
//  HackerNews
//
//  Created by Daniel on 9/29/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsHeaderCell.h"

@implementation HNCommentsHeaderCell

- (void)awakeFromNib {
    // Initialization code
    self.commentsButton.layer.cornerRadius = self.commentsButton.bounds.size.height / 2.0;
}

@end
