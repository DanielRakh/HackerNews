//
//  HNCommentsRootCell.m
//  HackerNews
//
//  Created by Daniel on 10/1/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsRootCell.h"
#import "UIColor+HNColorPalette.h"

@implementation HNCommentsRootCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setupCommentTextView];
}

- (void)setupCommentTextView {
    self.commentTextView.backgroundColor = [UIColor lightGrayColor];
    self.commentTextView.clipsToBounds = NO;
    self.commentTextView.editable = NO;
    self.commentTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor HNOrange]};
    self.commentTextView.selectable = YES;
    self.commentTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.commentTextView.scrollEnabled = NO;
    self.commentTextView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    self.commentTextView.textContainer.lineFragmentPadding = 0;
    self.commentTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.commentTextView.textAlignment = NSTextAlignmentLeft;
    
}
@end
