//
//  HNCommentsCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCellViewModel.h"
#import "HNCommentThread.h"
#import "HNRepliesCellViewModel.h"
#import "HNItemDataManager.h"
#import "HNItemComment.h"

@interface HNCommentsCellViewModel ()

@property (nonatomic, readwrite) NSArray *commentThreadArray;
//@property (nonatomic, readwrite) NSArray *commentThreads;
//@property (nonatomic, readwrite) RACSignal *updatedContentSignal;

@end

@implementation HNCommentsCellViewModel


- (instancetype)initWithThread:(HNCommentThread *)commentThread {
    self = [super init];
    if (self) {

        _commentThreadArray = @[commentThread];
        
//        @weakify(self);
//        [self.didBecomeActiveSignal subscribeNext:^(id x) {
//            @strongify(self);
//            RAC(self, commentThreads) = [[[HNItemDataManager sharedManager] threadForRootCommentID:_comment.idNum] collect];
//        }];
        
    }
    
    return self;
}

- (HNRepliesCellViewModel *)repliesViewModelForRootComment:(HNItemComment *)rootComment {
    HNRepliesCellViewModel *viewModel = [[HNRepliesCellViewModel alloc]initWithReply:rootComment];
    return viewModel;
}



@end
