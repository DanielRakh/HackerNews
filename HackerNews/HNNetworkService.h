//
//  HNNetworkService.h
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;


@interface HNNetworkService : NSObject

+ (id)sharedManager;

- (RACSignal *)topStoryItemsWithCount:(NSInteger)count;

- (RACSignal *)childForItem:(NSNumber *)itemId;

- (RACSignal *)kidsForItem:(NSNumber *)itemId;

- (RACSignal *)valueForItem:(NSNumber *)itemID;

@end