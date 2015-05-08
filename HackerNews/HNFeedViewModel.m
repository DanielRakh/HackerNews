//
//  HNFeedViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

//View Model
#import "HNFeedViewModel.h"
#import "HNFeedCellViewModel.h"

//Model
#import "HNItemDataManager.h"


@interface HNFeedViewModel ()

@property (nonatomic, readwrite) NSArray *topStories;

@end

@implementation HNFeedViewModel

-(instancetype)init {
    self = [super init];
    if (self) {

        @weakify(self)
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [self requestTopPosts];
        }];
    }
    
    return self;
}

- (void)requestTopPosts {
    
    RAC(self, topStories)  = [[[[HNItemDataManager sharedManager]topStories:30]collect] logAll];
}

- (HNFeedCellViewModel *)feedCellViewModelForIndexPath:(NSIndexPath *)indexPath {
    HNFeedCellViewModel *viewModel = [[HNFeedCellViewModel alloc]initWithStory:[self storyForIndexPath:indexPath]];
    return viewModel;
}

//- (HNBrowserViewModel *)browserViewModelForIndexPath:(NSIndexPath *)indexPath {
////    HNPost *selectedPost =  self.dataManager.posts[indexPath.row];
////    return [[HNBrowserViewModel alloc]initWithPost:selectedPost];
//    return nil;
//}

#pragma mark - Public Methods


-(NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.topStories.count;
}

#pragma mark - Private Methods

- (HNItemStory *)storyForIndexPath:(NSIndexPath *)indexPath {
    
    return self.topStories[indexPath.row];
}



@end
