//
//  HNDataManager.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

@import CoreData;

#import "HNDataManager.h"
#import "HNNetworkService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ReactiveCoreData.h"
#import "HNPost.h"
#import "HNStory.h"


@interface HNDataManager ()

@property (nonatomic, strong, readwrite) HNCoreDataStack *coreDataStack;


@end

@implementation HNDataManager

+ (id)sharedManager {
    static HNDataManager *sharedMyManager = nil;
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
        _coreDataStack = [HNCoreDataStack new];
        [NSManagedObjectContext setMainContext:_coreDataStack.managedObjectContext];
    }
    return self;
}

- (RACSignal *)topPostsWithCount:(NSInteger)count {

    return [[[[[HNNetworkService sharedManager] topItemsWithCount:count]
             map:^id(NSArray *items) {
                 
                 return [[[items.rac_sequence filter:^BOOL(NSDictionary *dict) {
                     return [dict[@"type"] isEqualToString:@"story"];
                 }] map:^id(NSDictionary *dict) {
                     
                     return [HNStory insert:^(HNStory *story) {
                         story.id_ = dict[@"id"];
                         story.deleted_ = dict[@"deleted"];
                         story.by_ = dict[@"by"];
                         story.time_ = dict[@"time"];
                         story.text_ = dict[@"text"];
                         story.dead_ = dict[@"dead"];
                         story.url_ = dict[@"url"];
                         story.score_ = dict[@"score"];
                         story.title_ = dict[@"title"];
                         story.descendants_ = dict[@"descendants"];
                         
                     }];
                 }] array];
                 
                 
//                 return [[items.rac_sequence
//                          map:^id(NSDictionary *dict) {
//                              
//                              [HNStory insert:^(HNStory *story) {
//                                  story.id_ = dict[@"id"];
//                                  
//                                  
//                              }];
//
//                              HNPost *post = [HNPost new];
//                              post.id = dict[@"id"];
//                              post.deleted = dict[@"deleted"];
//                              post.type = dict[@"type"];
//                              post.by = dict[@"by"];
//                              post.time = dict[@"time"];
//                              post.text = dict[@"text"];
//                              post.dead = dict[@"dead"];
//                              post.parent = dict[@"parent"];
//                              post.kids = dict[@"kids"];
//                              post.url = dict[@"url"];
//                              post.score = dict[@"score"];
//                              post.title = dict[@"title"];
//                              post.parts = dict[@"parts"];
//                              post.descendants = dict[@"descendants"];
//                              return post;
//                              
//                          }] array];
                 
             }] saveContext] doNext:^(id x) {
                 _posts = [NSArray arrayWithArray:x];
             }];
    
}


- (RACSignal *)topCommentsForPost:(HNPost *)post {
    
    return [RACSignal empty];
}


@end
