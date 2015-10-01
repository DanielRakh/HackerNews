//
//  HNCommentsRootCell.m
//  HackerNews
//
//  Created by Daniel on 10/1/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsRootCell.h"

@implementation HNCommentsRootCell

- (void)awakeFromNib {
    // Initialization code
    self.commentTextView.scrollEnabled = NO; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
