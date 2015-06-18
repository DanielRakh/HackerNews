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
- (RACSignal *)rootCommentForStory:(HNItemStory *)story {

    return [[[HNNetworkService sharedManager]childForItem:story.idNum] map:^id(NSDictionary *dict) {
        
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




- (RACSignal *)populateRepliesForComment:(HNItemComment *)comment {
    
    //What do I really want to do?
    // I want to take a comment.
    // Iterate through it kids
    // Take each ID and make that into a comment..add it to the parent comment array.
    // Check to see if new comment has any kids...and repeat.

    return [RACSignal empty];
    
}


-(RACSignal *)testThreadForRootCommentID:(NSNumber *)commentID {
    
    RACSignal *commentSignal = [self commentForID:commentID];
    
    
    
    
    RACSignal *mappedComments = [commentSignal map:^id(HNItemComment *rootComment) {
        
        // If rootComment has kids lets iterate through through the kids property
        
        HNItemComment *comment = rootComment;
        
        while (comment.kids.count > 0) {
            
            for (NSNumber *idNum in comment.kids) {
                
                RACSignal *replySignal = [self commentForID:idNum];
                [replySignal subscribeNext:^(HNItemComment *x) {
                    [comment.replies addObject:x];
                    
                }];
            }
            
        }
        // Let's create an HNItemComment object for each of them.
        // Let's check to see if the item created has kids.
        // If it has kids lets follow those above steps ^ and return.
        
        return rootComment;

    }];
    
    
    return [RACSignal empty];
}


// Return an HNCommentThread with children threads fully populated
- (RACSignal *)threadForRootCommentID:(NSNumber *)commentID {
    
    return [[self commentForID:commentID]
            flattenMap:^RACStream *(HNItemComment *rootComment) {
                DLogNSObject(rootComment.idNum);

                return [[self populateRepliesForRootComment:rootComment]
                        flattenMap:^RACStream *(HNItemComment *comment) {
                            DLogNSObject(comment.idNum);

                            return [[self threadForComment:comment]
                                    flattenMap:^RACStream *(HNCommentThread *thread) {
                                        DLogNSObject(thread.headComment.idNum);
                                        return [self populateThreadForRootThread:thread];
                                    }];
                        }];
            }];
}

#pragma mark -  Private Helpers
#pragma mark - 

- (RACSignal *)populateRepliesForRootComment:(HNItemComment *)comment {
    
    if (comment.kids.count > 0) {
        return [[comment.kids.rac_sequence.signal flattenMap:^RACStream *(NSNumber *idNum) {
            return [[[self commentForID:idNum]
                     doNext:^(HNItemComment *child) {
                         [comment.kids replaceObjectAtIndex:[comment.kids indexOfObject:idNum] withObject:child];
                         //                     [comment.replies addObject:child];
                     }] flattenMap:^RACStream *(HNItemComment *child) {
                         if (child.kids.count > 0) {
                             return [self populateRepliesForRootComment:child];
                         } else {
                             return [RACSignal empty];
                         }
                     }];
        }] then:^RACSignal *{
            return [RACSignal return:comment];
        }];
    } else {
        return [RACSignal return:comment];
    }

}


- (RACSignal *)populateThreadForRootThread:(HNCommentThread *)thread {
    
    if (thread.headComment.kids.count > 0) {
        return [[thread.headComment.kids.rac_sequence.signal flattenMap:^RACStream *(HNItemComment *reply) {
            return [[[self threadForComment:reply]
                     doNext:^(HNCommentThread *replyThread) {
                         [thread addReply:replyThread];
                     }] flattenMap:^RACStream *(HNCommentThread *replyThread) {
                         if (replyThread.headComment.kids.count > 0) {
                             return [self populateThreadForRootThread:replyThread];
                         } else {
                             return [RACSignal empty];
                         }
                     }];
        }] then:^RACSignal *{
            return [RACSignal return:thread];
        }];
    } else {
        return [RACSignal return:thread];
    }

}


- (RACSignal *)threadForComment:(HNItemComment *)comment {
    HNCommentThread *thread = [HNCommentThread threadWithTopComment:comment replies:nil];
    return [RACSignal return:thread];
}


@end
