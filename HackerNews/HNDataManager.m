//
//  HNDataManager.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//


#import "HNDataManager.h"
#import "HNNetworkService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HNPost.h"

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
    }
    return self;
}

- (RACSignal *)topPostsWithCount:(NSInteger)count {

    return [[[[HNNetworkService sharedManager] topItemsWithCount:count]
             map:^id(NSArray *items) {
                 
                 return [[items.rac_sequence
                          map:^id(NSDictionary *dict) {

                              HNPost *post = [HNPost new];
                              post.id = dict[@"id"];
                              post.deleted = dict[@"deleted"];
                              post.type = dict[@"type"];
                              post.by = dict[@"by"];
                              post.time = dict[@"time"];
                              post.text = dict[@"text"];
                              post.dead = dict[@"dead"];
                              post.parent = dict[@"parent"];
                              post.kids = dict[@"kids"];
                              post.url = dict[@"url"];
                              post.score = dict[@"score"];
                              post.title = dict[@"title"];
                              post.parts = dict[@"parts"];
                              post.descendants = dict[@"descendants"];
                              return post;
                              
                          }] array];
             }] doNext:^(id x) {
                 _posts = [NSArray arrayWithArray:x];
             }];
    
}


- (RACSignal *)topCommentsForPost:(HNPost *)post {
    
    return [RACSignal empty];
}


@end
