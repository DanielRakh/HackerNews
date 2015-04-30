//
//  HNCommentsCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCellViewModel.h"
#import "HNCommentThread.h"

@interface HNCommentsCellViewModel ()

@property (nonatomic) HNComment *comment;


//@property (nonatomic, readwrite) RACSignal *updatedContentSignal;


//@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation HNCommentsCellViewModel


- (instancetype)initWithComment:(HNComment *)comment {
    self = [super init];
    if (self) {

        _comment = comment;
        
//        @weakify(self)
//        [self.didBecomeActiveSignal subscribeNext:^(id x) {
//            @strongify(self);
//            [[_dataManager saveThreadForComment:_comment.id_] subscribeCompleted:^{
////                NSLog(@"COMPLETED");
//                _dataArray = [self threadForHeadComment:_comment];
//            }];
//    
//            //
//        }];
        
    }
    
    return self;
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
