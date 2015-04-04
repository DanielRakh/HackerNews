//
//  HNDataManager.h
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface HNDataManager : NSObject

@property (nonatomic, readonly) NSArray *posts;

- (RACSignal *)topPostsWithCount:(NSInteger)count;

@end
