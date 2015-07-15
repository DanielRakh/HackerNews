//
//  HNCommentsReplyCell.h
//  HackerNews
//
//  Created by Daniel on 6/20/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNCommentsCommentCell.h"

@interface HNCommentsCommentReplyCell : HNCommentsCommentCell

//@property (nonatomic) NSLayoutConstraint *leadingThreadlineConstraint;
@property (nonatomic) NSInteger treeLevel;
@property (nonatomic, assign) BOOL hasReplies;

// 4 scenarios:
// 1 -  Single Reply - threadline ends at the bottom of the commentTextView ALWAYS/
// 2 -  Middle Reply - threadline
// 3 - Last Reply - threadline ends at the bottom of the commentTextView Always//

//Thats the same as single. Whats the common property? If cell has no child...

// 1: If cell has no child/reply the threadline ends at the bottom of the textview.
// 2: If cell has child reply the threadline ends at the bottom of the textview.


- (void)setupThreadLinesForLevel:(NSInteger)level; 

@end
