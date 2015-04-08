//
//  HNDataManager.h
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNCoreDataStack.h"


@class RACSignal;
@class HNPost;

@interface HNDataManager : NSObject

@property (nonatomic, readonly) NSArray *posts;

@property (nonatomic, strong, readonly) HNCoreDataStack *coreDataStack;

+ (id)sharedManager;

- (RACSignal *)topPostsWithCount:(NSInteger)count;

//- (RACSignal *)topCommentsForPost:(HNPost *)

@end
