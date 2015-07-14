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


@end
