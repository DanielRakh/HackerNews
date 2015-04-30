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


// Return the Top Stories in an [HNItemStory]
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


- (RACSignal *)rootCommentsForStory:(HNItemStory *)story {
    
    RACSignal *tst = [[[HNNetworkService sharedManager]childrenForItem:story.idNum] map:^id(NSDictionary *dict) {
        
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
    
    return tst;
}




@end
