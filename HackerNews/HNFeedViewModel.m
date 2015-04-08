//
//  HNFeedViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HNFeedViewModel.h"
#import "HNPost.h"
#import "HNDataManager.h"
#import "HNFeedCellViewModel.h"
#import "HNBrowserViewModel.h"


@interface HNFeedViewModel ()

@property (weak, nonatomic) HNDataManager *dataManager;

@end

@implementation HNFeedViewModel

-(instancetype)init {
    self = [super init];
    if (self) {
        _dataManager = [HNDataManager sharedManager];
        RAC(self, posts) = [self fetchTopPosts];
    }
    return self;
}


- (RACSignal *)fetchTopPosts {
    
    return [[self.dataManager topPostsWithCount:30] map:^id(NSArray *posts) {
        return [[posts.rac_sequence map:^id(HNPost *post) {
            HNFeedCellViewModel *cellViewModel = [[HNFeedCellViewModel alloc]initWithPost:post];
            return cellViewModel;
        }] array];
    }];
}


- (HNBrowserViewModel *)browserViewModelForIndexPath:(NSIndexPath *)indexPath {
    HNPost *selectedPost =  self.dataManager.posts[indexPath.row];
    return [[HNBrowserViewModel alloc]initWithPost:selectedPost];
}

@end
