//
//  HNCommentsViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "ReactiveViewModel.h"

@class HNCommentsCellViewModel;

@interface HNCommentsViewModel : RVMViewModel

@property (nonatomic, readonly) RACSignal *updatedContentSignal;

-(NSInteger)numberOfSections;
-(NSInteger)numberOfItemsInSection:(NSInteger)section;

- (HNCommentsCellViewModel *)commentsCellViewModelForIndexPath:(NSIndexPath *)indexPath;

@end
