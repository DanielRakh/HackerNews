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

@interface HNDataManager : NSObject


@property (nonatomic, strong, readonly) HNCoreDataStack *coreDataStack;

+ (id)sharedManager;

- (RACSignal *)topPostsWithCount:(NSInteger)count;

//- (RACSignal *)topCommentsForPost:(HNPost *)post;


@end
