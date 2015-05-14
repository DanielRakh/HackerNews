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

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}


#pragma mark -  Public
#pragma mark -


- (RACSignal *)testStory {
    
    return [[[HNNetworkService sharedManager]valueForItem:@9542034] map:^id(NSDictionary *dict) {
        
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
        comment.deleted = dict[@"deleted"];
        comment.by = dict[@"by"];
        comment.parentIDNum = dict[@"parent"];
        comment.text = dict[@"text"];
        comment.time = dict[@"time"];
        comment.type = dict[@"type"];        
        return comment;
        
    }];
}

// Return an HNCommentThread with children threads fully populated
- (RACSignal *)threadForRootCommentID:(NSNumber *)commentID {
    
    return [[self commentForID:commentID]
            flattenMap:^RACStream *(HNItemComment *rootComment) {
                
                return [[self populateRepliesForRootComment:rootComment]
                        flattenMap:^RACStream *(HNItemComment *comment) {
                            
                            return [[self threadForComment:comment]
                                    flattenMap:^RACStream *(HNCommentThread *thread) {
                                        
                                        return [self populateThreadForRootThread:thread];
                                    }];
                        }];
            }];
}


#pragma mark -  Private Helpers
#pragma mark - 

- (RACSignal *)populateRepliesForRootComment:(HNItemComment *)comment {
    
    return [[comment.kids.rac_sequence.signal flattenMap:^RACStream *(id value) {
        return [[[self commentForID:value]
                 doNext:^(HNItemComment *child) {
                     [comment.replies addObject:child];
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
    
}

- (RACSignal *)populateThreadForRootThread:(HNCommentThread *)thread {
    
    return [[thread.headComment.replies.rac_sequence.signal flattenMap:^RACStream *(HNItemComment *reply) {
        return [[[self threadForComment:reply]
                 doNext:^(HNCommentThread *replyThread) {
                     [thread addReply:replyThread];
                 }] flattenMap:^RACStream *(HNCommentThread *replyThread) {
                     if (replyThread.headComment.replies.count > 0) {
                         return [self populateThreadForRootThread:replyThread];
                     } else {
                         return [RACSignal empty];
                     }
                 }];
    }] then:^RACSignal *{
        return [RACSignal return:thread];
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

- (RACSignal *)threadForComment:(HNItemComment *)comment {
    HNCommentThread *thread = [HNCommentThread threadWithTopComment:comment replies:nil];
    return [RACSignal return:thread];
}


@end
