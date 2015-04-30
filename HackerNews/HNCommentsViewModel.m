//
//  HNCommentsViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HNUtilities.h"

// View Model
#import "HNCommentsViewModel.h"
#import "HNCommentsCellViewModel.h"

// Model
#import "HNItemDataManager.h"
#import "HNItemStory.h"
#import "HNItemComment.h"

@interface HNCommentsViewModel ()

@property (nonatomic, readwrite) NSArray *rootComments;

@end

@implementation HNCommentsViewModel

-(instancetype)initWithStory:(HNItemStory *)story {
    self = [super init];
    if (self) {
        
        [self initalizeHeaderDataForStory:story];
        
        @weakify(self)
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [self requestTopCommentsForItem:story];
        }];
    }
    
    return self;
}


- (void)initalizeHeaderDataForStory:(HNItemStory *)story {
    
    _score = [NSString stringWithFormat:@"%@ Points", story.score];
    _title = story.title;
    _commentsCount = [HNUtilities stringForCommentsCount:story.descendantsCount];
    _info = [NSString stringWithFormat: @"by %@ | %@", story.by, [HNUtilities timeAgoFromTimestamp:story.time]];
    
}


- (void)requestTopCommentsForItem:(HNItemStory *)item {
    
    RAC(self, rootComments) = [[[HNItemDataManager sharedManager] rootCommentsForStory:item]collect];
}

- (HNCommentsCellViewModel *)commentsCellViewModelForIndexPath:(NSIndexPath *)indexPath {
    
    HNCommentsCellViewModel *viewModel = [[HNCommentsCellViewModel alloc]initWithComment:[self commentForIndexPath:indexPath]];
    return viewModel;
}

#pragma mark - Public Methods

-(NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.rootComments.count;
}

- (HNItemComment *)commentForIndexPath:(NSIndexPath *)indexPath {

    return self.rootComments[indexPath.row];
}


@end
