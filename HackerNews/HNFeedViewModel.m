//
//  HNFeedViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNFeedViewModel.h"
#import "HNPost.h"
#import "HNDataManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HNCellViewModel.h"


@interface HNFeedViewModel ()

@property (nonatomic) HNDataManager *dataManager;

@end

@implementation HNFeedViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        _dataManager = [HNDataManager new];
        RAC(self, posts) = [self fetchTopPosts];
    }
    return self;
}


- (RACSignal *)fetchTopPosts {
    
    return [[self.dataManager topPostsWithCount:30] map:^id(NSArray *posts) {
        return [[posts.rac_sequence map:^id(HNPost *post) {
            HNCellViewModel *cellViewModel = [HNCellViewModel new];
            cellViewModel.title = post.title;
            cellViewModel.commentsCount = @"100";
            cellViewModel.info = @"by danielrak | 12 hrs ago";
            cellViewModel.score = @"500 pts";
            return cellViewModel;
        }] array];
    }];
}

@end
