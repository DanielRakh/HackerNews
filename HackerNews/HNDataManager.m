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
    
    [self.coreDataStack clearAllDataForEntity:@"HNStory"];
    
    return [[[[HNNetworkService sharedManager] topItemsWithCount:count]
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
                 
             }] saveContext];
}


//- (RACSignal *)topCommentsForPost:(HNPost *)post {
//    
//    return [RACSignal empty];
//}


@end
