//
//  HNCommentsRootWithRepliesCell.h
//  HackerNews
//
//  Created by Daniel on 6/20/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNCommentsCommentCell.h"

@class HNThinLineButton;

@interface HNCommentsCommentWithRepliesCell : HNCommentsCommentCell

@property (nonatomic) HNThinLineButton *repliesButton;
//@property (nonatomic) NSLayoutConstraint *textViewHeightConstraint;
//@property (nonatomic, assign) BOOL didUpdateTextView;


@property (nonatomic, copy) void (^repliesButtonDidTapAction)(id sender);


- (CGFloat)heightForWrappedTextView:(UITextView *)textView;



@end
