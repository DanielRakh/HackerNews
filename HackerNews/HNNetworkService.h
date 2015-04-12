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

- (RACSignal *)topItemsWithCount:(NSInteger)count;

- (RACSignal *)childrenForItem:(NSNumber *)itemId;

@end