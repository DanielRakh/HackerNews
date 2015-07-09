//
//  HNRepliesCell.h
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNCommentsCell.h"


@class HNRepliesCellViewModel;

@interface HNCommentsReplyWithRepliesCell : HNCommentsCell

@property (nonatomic) HNRepliesCellViewModel *viewModel;
@property (nonatomic, copy) void (^repliesButtonDidTapAction)(id sender);

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel;




@end
