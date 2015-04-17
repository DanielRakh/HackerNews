//
//  HNDataManager.h
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNCoreDataStack.h"


@class RACSignal, HNItem;

@interface HNDataManager : NSObject


@property (nonatomic, strong, readonly) HNCoreDataStack *coreDataStack;

+ (id)sharedManager;

- (RACSignal *)topStoriesWithCount:(NSInteger)count;

- (RACSignal *)commentsForItem:(HNItem *)item;

- (RACSignal *)testCommentsForItem:(HNItem *)item;

- (RACSignal *)tstTopStoriesWithCount:(NSInteger)count;


@end
