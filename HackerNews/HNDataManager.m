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
    RACSignal *tst = [[[[[HNNetworkService sharedManager] topStoryItemsWithCount:count] collect] doNext:^(NSArray *items) {
        
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
    return [[[[[HNNetworkService sharedManager] topStoryItemsWithCount:count] collect] doNext:^(NSArray *items) {
        
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

// Get the replies for comment -> saves them to database -> returns an array of HNComment's.
- (RACSignal *)repliesForComment:(NSNumber *)idNum {

    return [[[[[[HNNetworkService sharedManager] kidsForItem:idNum]
            //An array of ID's for the kids of this comment.
            flattenMap:^RACStream *(NSArray *idNums) {
                // Let's iterate through those ID's
                return [idNums.rac_sequence.signal
                        flattenMap:^RACStream *(NSNumber *childID) {
                            // Let's return the a Dictionary of values for each ID
                            return [[HNNetworkService sharedManager] valueForItem:childID];
                        }];
            }] map:^id(NSDictionary *commentDict) {
                return [HNComment insert:^(HNComment *comment) {
                    comment.id_ = commentDict[@"id"];
                    comment.deleted_ = commentDict[@"deleted"];
                    comment.by_ = commentDict[@"by"];
                    comment.parent_ = commentDict[@"parent"];
                    comment.kids_ = commentDict[@"kids"];
                    comment.text_ = commentDict[@"text"];
                    comment.time_ = commentDict[@"time"];
                    comment.type_ = commentDict[@"type"];
//                    comment.rank_ = @([items indexOfObject:dict]);
                }];
            }] collect] saveContext];
}






- (RACSignal *)saveThreadForComment:(NSNumber *)idNum {
    
    return [[[[[[self repliesForComment:idNum]
               // Just got an array of HNComments (replies to the idNum comment)
               doNext:^(NSArray *comments) {
                   // Side effect where we fetch the parent comment and add these comments as "replies" in it's relationship
                   [[[[HNComment findOne] where:@"id_" equals:idNum] fetch]
                    subscribeNext:^(HNComment *parent) {
                        if (parent.replies.count != 0) { [parent removeReplies:parent.replies]; }
                        [parent addReplies:[NSOrderedSet orderedSetWithArray:comments]];
                    }];
               }] flattenMap:^RACStream *(NSArray *comments) {
                   // We flattenMap the array of comments to return each object in the array
                   return [comments.rac_sequence.signal
                           map:^id(id value) {
                               return value;
                           }];
                   // Each of those objects is an HNComment
               }] filter:^BOOL(HNComment *comment) {
                   // We filter out each comment that doesn't have any children.
                   return comment.kids_.count > 0;
               }] flattenMap:^RACStream *(HNComment *commentsWithKids) {
                   // For each comment with kids we make a recursive call with the ID of it's child
//                   @weakify(self);
                   return [commentsWithKids.kids_.rac_sequence.signal map:^id(NSNumber *childID) {
//                       @strongify(self);
                       return [self saveThreadForComment:childID];
                   }];
               }] collect];
}





// Fetch the parent comment
// Add them to "replies relationship" for parent comment.
// We need to check to see if there kids for each reply.
  // If there are kids we need to repeat the above process.


@end
