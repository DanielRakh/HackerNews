//
//  HNRepliesCell.h
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNCommentsCommentCell.h"



@interface HNCommentsReplyWithRepliesCell : HNCommentsCommentCell

@property (nonatomic, copy) void (^repliesButtonDidTapAction)(id sender);





@end
