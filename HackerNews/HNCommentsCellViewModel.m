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

@interface HNCommentsCellViewModel ()

@property (nonatomic) HNItemComment *comment;
@property (nonatomic, readwrite) NSArray *commentThreads;



//@property (nonatomic, readwrite) RACSignal *updatedContentSignal;


//@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation HNCommentsCellViewModel


- (instancetype)initWithComment:(HNItemComment *)comment {
    self = [super init];
    if (self) {

        _comment = comment;
        
        @weakify(self)
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
//            RAC(self, commentThreads) = 
        }];
        
    }
    
    return self;
}

- (HNRepliesCellViewModel *)repliesViewModelForRootComment:(HNItemComment *)rootComment {
    HNRepliesCellViewModel *viewModel = [[HNRepliesCellViewModel alloc]initWithReply:rootComment];
    return viewModel;
}


//- (NSMutableArray *)threadForHeadComment:(HNComment *)comment {
//    
//    NSMutableArray *replyArray = [NSMutableArray array];
//    
//    for (HNComment *reply in comment.replies) {
//        
//        HNCommentThread *thread = [HNCommentThread threadWithTopComment:reply
//                                                               replies:reply.replies.count == 0 ? nil : [self threadForHeadComment:reply]];
//        [replyArray addObject:thread];
//    }
//    
//    return replyArray;
//}




@end
