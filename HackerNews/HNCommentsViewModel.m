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
#import "HNCommentThread.h"

@interface HNCommentsViewModel ()

@property (nonatomic, readwrite) NSArray *commentCellViewModels;

@end

@implementation HNCommentsViewModel

-(instancetype)initWithStory:(HNItemStory *)story {
    self = [super init];
    if (self) {
        
        [self initalizeHeaderDataForStory:story];
        
        @weakify(self)
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            RAC(self, commentCellViewModels) = [[[[HNItemDataManager sharedManager] threadsForStory:story] flattenMap:^RACStream *(RACSequence *threads) {
                return [threads.signal map:^id(HNCommentThread *thread) {
                    return [[HNCommentsCellViewModel alloc]initWithThread:thread];
                }];
            }] collect];
            
            
//            
//            [[[[[HNItemDataManager sharedManager] rootCommentForStory:story]
//                                          flattenMap:^RACStream *(HNItemComment *rootComment) {
//                                              return [[HNItemDataManager sharedManager] threadForRootCommentID:rootComment.idNum];
//                                          }] map:^id(HNCommentThread *thread) {
//                                              return [[HNCommentsCellViewModel alloc]initWithThread:thread];
//                                          }] collect];
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


- (HNCommentsCellViewModel *)commentsCellViewModelForIndexPath:(NSIndexPath *)indexPath {
    
    HNCommentsCellViewModel *viewModel = [[HNCommentsCellViewModel alloc]initWithThread:[self threadForIndexPath:indexPath]];
    return viewModel;
}

#pragma mark - Public Methods


- (HNCommentThread *)threadForIndexPath:(NSIndexPath *)indexPath {

    return self.commentCellViewModels[indexPath.row];
}


@end
