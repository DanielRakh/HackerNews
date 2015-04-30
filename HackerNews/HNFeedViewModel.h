//
//  HNFeedViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//


#import "ReactiveViewModel.h"

@class HNFeedCellViewModel;

@interface HNFeedViewModel : RVMViewModel

@property (nonatomic, readonly) NSArray *topStories;


-(NSInteger)numberOfItemsInSection:(NSInteger)section;

- (HNFeedCellViewModel *)feedCellViewModelForIndexPath:(NSIndexPath *)indexPath;

//- (HNBrowserViewModel *)browserViewModelForIndexPath:(NSIndexPath *)indexPath;

@end
