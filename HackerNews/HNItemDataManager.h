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

- (RACSignal *)topStories:(NSUInteger)count;
- (RACSignal *)rootCommentsForStory:(HNItemStory *)story;


@end
