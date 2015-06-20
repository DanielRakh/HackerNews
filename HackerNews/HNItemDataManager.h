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
@class HNItemComment;

@interface HNItemDataManager : NSObject

+ (instancetype)sharedManager;

// Top stories for the front page
- (RACSignal *)topStories:(NSUInteger)count;

// Comment threads for a specific story
- (RACSignal *)threadsForStory:(HNItemStory *)story;

#warning Comment out when not testing.
- (RACSignal *)testStory;




@end
