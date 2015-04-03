//
//  HNDataManager.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNDataManager.h"
#import "HNNetworkService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HNPost.h"



@implementation HNDataManager


- (RACSignal *)topPostsWithCount:(NSInteger)count {
    
    
//    [[[HNNetworkService sharedManager] topItemsWithCount:count] subscribeNext:^(NSArray *items) {
//        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            if (![obj isKindOfClass:[NSNull class]]) {
//                HNPost *post = [HNPost new];
//                post.id = stories[idx]["id"];
//                
//            }
//        }];
//    } error:^(NSError *error) {
//        NSLog(@"There was an error: %@", error);
//    }];
    
//    return [[[HNNetworkService sharedManager] topItemsWithCount:count] map:^id(id value) {
//        NSLog(@"%@",value);
//        return [NSMutableArray array];
//    }];
//
    return [RACSignal empty];
    
}

@end
