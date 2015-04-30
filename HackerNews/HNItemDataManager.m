//
//  HNItemDataManager.m
//  HackerNews
//
//  Created by Daniel on 4/30/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNItemDataManager.h"
#import "HNNetworkService.h"


@implementation HNItemDataManager

+ (instancetype)sharedManager {
    static HNItemDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


// Return the Top Stories in an [HNItemStory]

- (RACSignal *)topStoriesArray:(NSUInteger)count {
    
    RACSignal *storiesSignal = [[HNNetworkService sharedManager]topStoryItemsWithCount:count];
    return storiesSignal;
}






@end
