//
//  HNItemDataManager.h
//  HackerNews
//
//  Created by Daniel on 4/30/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class HNItemStory;

@interface HNItemDataManager : NSObject

+ (instancetype)sharedManager;

// Top stories for the front page
- (RACSignal *)topStories:(NSUInteger)count;
// Root comments for a specific story
- (RACSignal *)rootCommentForStory:(HNItemStory *)story;
// Reply thread for root comment.
- (RACSignal *)threadForRootCommentID:(NSNumber *)commentID;


@end
