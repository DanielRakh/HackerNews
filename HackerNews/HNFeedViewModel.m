//
//  HNFeedViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNFeedViewModel.h"
#import "HNPost.h"

@implementation HNFeedViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        _posts = [NSMutableArray array];
        
        for (int i = 0; i < 30; i++) {
            HNPost *post = [HNPost new];
            post.id = @11111;
            [self.posts addObject:post];
        }
       
    }
    return self;
}

@end
