//
//  HNItemDataManager.m
//  HackerNews
//
//  Created by Daniel on 4/30/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNItemDataManager.h"
#import "HNNetworkService.h"
#import "HNItemStory.h"
#import "HNItemComment.h"
#import "HNCommentThread.h"


@implementation HNItemDataManager

+ (instancetype)sharedManager {
    static HNItemDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


#pragma mark -  Public
#pragma mark -


- (RACSignal *)threadsForStory:(HNItemStory *)story {
    return [[[[self rootCommentsForStory:story]

            flattenMap:^RACStream *(NSArray *rootComments) {
                return [self populateRepliesForComments:rootComments.rac_sequence];
            }]flattenMap:^RACStream *(RACSequence *populatedRootComments) {
                return [self rootThreadsForComments:populatedRootComments];
            }]flattenMap:^RACStream *(NSArray *rootThreads) {
                return [self populateRepliesForThreads:rootThreads.rac_sequence];
            }];
}


- (RACSignal *)testStory {
    
    return [[[HNNetworkService sharedManager]valueForItem:@9720772] map:^id(NSDictionary *dict) {
        
        HNItemStory *story = [HNItemStory new];
        story.idNum = dict[@"id"];
        story.deleted = dict[@"deleted"];
        story.by = dict[@"by"];
        story.time = dict[@"time"];
        story.text = dict[@"text"];
        story.dead = dict[@"dead"];
        story.url = dict[@"url"];
        story.score = dict[@"score"];
        story.title = dict[@"title"];
        story.descendantsCount = dict[@"descendants"];
        story.type = dict[@"type"];
        return story;
    }];
    
}

- (RACSignal *)topStories:(NSUInteger)count {
    
    return [[[HNNetworkService sharedManager]topStoryItemsWithCount:count] map:^id(NSDictionary *dict) {
        
        HNItemStory *story = [HNItemStory new];
        story.idNum = dict[@"id"];
        story.deleted = dict[@"deleted"];
        story.by = dict[@"by"];
        story.time = dict[@"time"];
        story.text = dict[@"text"];
        story.dead = dict[@"dead"];
        story.url = dict[@"url"];
        story.score = dict[@"score"];
        story.title = dict[@"title"];
        story.descendantsCount = dict[@"descendants"];
        story.type = dict[@"type"];
        return story;
    }];
}

// Return the Root Comments for a story
- (RACSignal *)rootCommentsForStory:(HNItemStory *)story {
    
    return [[[[HNNetworkService sharedManager]childForItem:story.idNum]
             map:^id(NSDictionary *dict) {
                 HNItemComment *comment = [HNItemComment new];
                 comment.idNum = dict[@"id"];
                 comment.kids = dict[@"kids"];
                 comment.deleted = dict[@"deleted"];
                 comment.by = dict[@"by"];
                 comment.parentIDNum = dict[@"parent"];
                 comment.text = dict[@"text"];
                 comment.time = dict[@"time"];
                 comment.type = dict[@"type"];
                 return comment;
             }]
            collect];
}


- (RACSignal *)commentForID:(NSNumber *)idNum {
    
    return [[[HNNetworkService sharedManager]valueForItem:idNum] map:^id(NSDictionary *dict) {
        HNItemComment *comment = [HNItemComment new];
        comment.idNum = dict[@"id"];
        comment.kids = dict[@"kids"];
        comment.deleted = dict[@"deleted"];
        comment.by = dict[@"by"];
        comment.parentIDNum = dict[@"parent"];
        comment.text = dict[@"text"];
        comment.time = dict[@"time"];
        comment.type = dict[@"type"];
        return comment;
    }];
    
}

- (RACSignal *)rootThreadsForComments:(RACSequence *)comments {
    
    return [[comments.signal flattenMap:^RACStream *(HNItemComment *comment) {
        return [self threadForComment:comment];
    }] collect];
}

- (RACSignal *)threadForComment:(HNItemComment *)comment {
    HNCommentThread *thread = [HNCommentThread threadWithTopComment:comment replies:nil];
    return [RACSignal return:thread];
}



// Return an HNCommentThread with children threads fully populated
//- (RACSignal *)threadForRootCommentID:(NSNumber *)commentID {
//    
//    return [[self commentForID:commentID]
//            flattenMap:^RACStream *(HNItemComment *rootComment) {
//                DLogNSObject(rootComment.idNum);
//
//                return [[self populateRepliesForRootComment:rootComment]
//                        flattenMap:^RACStream *(HNItemComment *comment) {
//                            DLogNSObject(comment.idNum);
//
//                            return [[self threadForComment:comment]
//                                    flattenMap:^RACStream *(HNCommentThread *thread) {
//                                        DLogNSObject(thread.headComment.idNum);
//                                        return [self populateThreadForRootThread:thread];
//                                    }];
//                        }];
//            }];
//}

#pragma mark -  Private Helpers
#pragma mark - 


- (RACSignal *)populateRepliesForComments:(RACSequence *)comments {
    
    return [[[[comments
            flattenMap:^RACStream *(HNItemComment *comment) {
                   if (comment.kids != nil) {
                       return [self repliesForRootComment:comment].sequence;
                   } else {
                       return [RACSignal return:comment].sequence;
                   }
               }] signal]
             flattenMap:^RACStream *(HNItemComment *reply) {
                 if (reply.kids != nil) {
                     return [RACSignal defer:^RACSignal *{
                         return [self populateRepliesForComments:reply.replies.rac_sequence];
                     }];
                 } else {
                     return [RACSignal empty];
                 }
             }] then:^RACSignal *{
                 return [RACSignal return:comments];
             }];
    
}

- (RACSignal *)populateRepliesForThreads:(RACSequence *)threads {
    
    return [[[[threads
        flattenMap:^RACStream *(HNCommentThread *thread) {
                if (thread.headComment.replies.count > 0) {
                    return [self repliesForRootThread:thread].sequence;
                } else {
                    return [RACSignal return:thread].sequence;
                }
            }] signal]
        flattenMap:^RACStream *(HNCommentThread *reply) {
            if (reply.headComment.replies.count > 0) {
                return [RACSignal defer:^RACSignal *{
                    return [self populateRepliesForThreads:reply.replies.rac_sequence];
                }];
            } else {
                return [RACSignal empty];
            }
    }] then:^RACSignal *{
        return [RACSignal return:threads];
    }];
}






- (RACSignal *)repliesForRootComment:(HNItemComment *)rootComment {
    
    return [[[[[rootComment.kids.rac_sequence.eagerSequence
            map:^id(id value) {
                return [[HNItemDataManager sharedManager]commentForID:value];
            }] signal] flatten]
            doNext:^(HNItemComment *reply) {
                 [rootComment.replies addObject:reply];
             }]
            then:^RACSignal *{
                return [RACSignal return:rootComment];
            }];
}


- (RACSignal *)repliesForRootThread:(HNCommentThread *)rootThread {
    return [[[[[rootThread.headComment.replies.rac_sequence.eagerSequence
            map:^id(id value) {
                    return [self threadForComment:value];
                }] signal] flatten]
            doNext:^(HNCommentThread *thread) {
                 [rootThread addReply:thread];
             }]
            then:^RACSignal *{
                return [RACSignal return:rootThread];
            }];
}




//- (RACSignal *)populateRepliesForRootComment:(HNItemComment *)comment {
//    
//    if (comment.kids.count > 0) {
//        return [[comment.kids.rac_sequence.signal flattenMap:^RACStream *(NSNumber *idNum) {
//            return [[[self commentForID:idNum]
//                     doNext:^(HNItemComment *child) {
//                         [comment.kids replaceObjectAtIndex:[comment.kids indexOfObject:idNum] withObject:child];
//                         //                     [comment.replies addObject:child];
//                     }] flattenMap:^RACStream *(HNItemComment *child) {
//                         if (child.kids.count > 0) {
//                             return [self populateRepliesForRootComment:child];
//                         } else {
//                             return [RACSignal empty];
//                         }
//                     }];
//        }] then:^RACSignal *{
//            return [RACSignal return:comment];
//        }];
//    } else {
//        return [RACSignal return:comment];
//    }
//
//}
//
//
//- (RACSignal *)populateThreadForRootThread:(HNCommentThread *)thread {
//    
//    if (thread.headComment.kids.count > 0) {
//        return [[thread.headComment.kids.rac_sequence.signal flattenMap:^RACStream *(HNItemComment *reply) {
//            return [[[self threadForComment:reply]
//                     doNext:^(HNCommentThread *replyThread) {
//                         [thread addReply:replyThread];
//                     }] flattenMap:^RACStream *(HNCommentThread *replyThread) {
//                         if (replyThread.headComment.kids.count > 0) {
//                             return [self populateThreadForRootThread:replyThread];
//                         } else {
//                             return [RACSignal empty];
//                         }
//                     }];
//        }] then:^RACSignal *{
//            return [RACSignal return:thread];
//        }];
//    } else {
//        return [RACSignal return:thread];
//    }
//
//}




@end
