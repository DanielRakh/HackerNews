//
//  HNCommentsViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "ReactiveViewModel.h"

@class HNCommentsCellViewModel, HNItemStory;

@interface HNCommentsViewModel : RVMViewModel


// This an array of the head HNCommentThreads
@property (nonatomic, readonly) NSArray *commentThreads;

// These are binded to the Header on the Table
@property (nonatomic, readonly) NSString *score;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *commentsCount;
@property (nonatomic, readonly) NSString *info;

- (instancetype)initWithStory:(HNItemStory *)story;

- (HNCommentsCellViewModel *)commentsCellViewModelForIndexPath:(NSIndexPath *)indexPath;

@end
