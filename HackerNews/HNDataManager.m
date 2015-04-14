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
#import "HNComment.h"


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



- (RACSignal *)topStoriesWithCount:(NSInteger)count {


    //Fetch storty for ID
//   [[[[HNStory findOne] where:@"id_" equals:@(9374927)] fetch] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    } completed:^{
//        NSLog(@"COMPLETE");
//    }];
//
//    return nil;
    
    
 
    
    //Grab comments for ID
    RACSignal *tst = [[[[[[HNNetworkService sharedManager] childrenForItem:@(9374927)] collect] map:^id(NSArray *items) {
        return [[items.rac_sequence map:^id(NSDictionary *dict) {
            return [HNComment insert:^(HNComment *comment) {
                comment.id_ = dict[@"id"];
                comment.deleted_ = dict[@"deleted"];
                comment.by_ = dict[@"by"];
                comment.parent_ = dict[@"parent"];
                comment.kids_ = dict[@"kids"];
                comment.text_ = dict[@"text"];
                comment.time_ = dict[@"time"];
                comment.type_ = dict[@"type"];
                comment.rank_ = @([items indexOfObject:dict]);
            }];
        }] array];
    }] doNext:^(NSArray *comments) {
        [[[[HNStory findOne] where:@"id_" equals:@(9374927)] fetch]
         subscribeNext:^(HNStory *story) {
            [story addComments:[NSOrderedSet orderedSetWithArray:comments]];
        } completed:^{
            //
        }];
    }] saveContext];
    //Create HNComment Items
    
    
    [tst subscribeNext:^(id x) {
        NSLog(@"%@", x);
    } completed:^{
        NSLog(@"Completed!");
    }];
    
    
  /*
    //Clear any existing data.
    [self.coreDataStack clearAllDataForEntity:@"HNStory"];

    return [[[[[HNNetworkService sharedManager] topItemsWithCount:count] collect]
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
                         story.kids_ = dict[@"kids"];
                         story.type_ = dict[@"type"];
                         story.rank_ = @([items indexOfObject:dict]);
                     }];
                 }] array];
                 
             }] saveContext];
    
    */
    
    return nil;
}

- (RACSignal *)commentsForItem:(HNItem *)item {
    
    //0. Clear all data for specific item:
    
    
    //1. Take the kids of the item
    
    return [[HNNetworkService sharedManager] childrenForItem:item.id_];
    
    //2. Hit network to pull those items.
    //3. This is the top of the tree nodes.
    
    return nil;
}

//- (RACSignal *)topCommentsForPost:(HNPost *)post {
//    
//    return [RACSignal empty];
//}


@end
