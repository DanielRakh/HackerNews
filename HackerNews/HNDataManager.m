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
#import "HNCommentThread.h"



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


- (RACSignal *)tstTopStoriesWithCount:(NSInteger)count {
    
    //Clear any existing data.
    [self.coreDataStack clearAllDataForEntity:@"HNStory"];
    
    // Pull top stories data from network and collect into an array
    RACSignal *tst = [[[[[HNNetworkService sharedManager] topItemsWithCount:count] collect] doNext:^(NSArray *items) {
        
        [RACSignal concat:[[items.rac_sequence
                            filter:^BOOL(NSDictionary *dict) {
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
                            }]];
    }] saveContext];
    
    
    //Map the array from an array of Dictionaries to an array of HNStorie

    return tst;
}


- (RACSignal *)topStoriesWithCount:(NSInteger)count {
    
    //Clear any existing data.
    [self.coreDataStack clearAllDataForEntity:@"HNStory"];
    
    // Pull top stories data from network and collect into an array
    return [[[[[HNNetworkService sharedManager] topItemsWithCount:count] collect] doNext:^(NSArray *items) {
        
        [RACSignal concat:[[items.rac_sequence
                            filter:^BOOL(NSDictionary *dict) {
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
                            }]];
    }] saveContext];
    
}

- (RACSignal *)commentsForItem:(HNItem *)item {
    
    //Pull comments data for item from network and collect into an array
    RACSignal *tst = [[[[[[HNNetworkService sharedManager] childrenForItem:item.id_] collect]
              map:^id(NSArray *items) {
                  // Map the array from an Array of Dictionaries to an array of HNComments
                  return [[items.rac_sequence
                           map:^id(NSDictionary *dict) {
                               // Create an NSManagedObject for HNComment
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
                  // Fetch the corresponding Story from CD
                  [[[[HNStory findOne] where:@"id_" equals:item.id_] fetch]
                   // Form a relationship between the Story -> Comments
                   subscribeNext:^(HNStory *story) {
                       if (story.comments.count != 0) {
                           [story removeComments:story.comments];
                       }
                       [story addComments:[NSOrderedSet orderedSetWithArray:comments]];
                   }];
                  // Save the context
              }] saveContext];

    return tst;

}

- (RACSignal *)testCommentsForItem:(NSNumber *)item {
    //Pull comments data for item from network and collect into an array
    RACSignal *tst = [[[[[[HNNetworkService sharedManager] childrenForItem:item] collect]
                        map:^id(NSArray *items) {
                            // Map the array from an Array of Dictionaries to an array of HNComments
                            return [[items.rac_sequence
                                     map:^id(NSDictionary *dict) {
                                         // Create an NSManagedObject for HNComment
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
                            // Fetch the corresponding Story from CD
                            [[[[HNStory findOne] where:@"id_" equals:item] fetch]
                             // Form a relationship between the Story -> Comments
                             subscribeNext:^(HNStory *story) {
                                 if (story.comments.count != 0) {
                                     [story removeComments:story.comments];
                                 }
                                 [story addComments:[NSOrderedSet orderedSetWithArray:comments]];
                             }];
                            // Save the context
                        }] saveContext];
    
    return tst;
}


#pragma mark - Comments Management

// Get the replies for comment - retunrs a signal of a Dictionary. 
- (RACSignal *)repliesForComment:(NSNumber *)idNum {

    return [[[HNNetworkService sharedManager] kidsForItem:idNum]
            //An array of ID's for the kids of this comment.
            flattenMap:^RACStream *(NSArray *idNums) {
                // Let's iterate through those ID's
                return [idNums.rac_sequence.signal
                        flattenMap:^RACStream *(NSNumber *childID) {
                            // Let's return the a Dictionary of values for each ID
                            return [[HNNetworkService sharedManager] valueForItem:childID];
                        }];
            }];
}

// Model them into HNComments






// Fetch the parent comment
// Add them to "replies relationship" for parent comment.
// We need to check to see if there kids for each reply.
  // If there are kids we need to repeat the above process.


@end
