//
//  HNItemDataManager.h
//  HackerNews
//
//  Created by Daniel on 4/30/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface HNItemDataManager : NSObject

+ (instancetype)sharedManager;


- (RACSignal *)topStoriesArray:(NSUInteger)count;

@end
