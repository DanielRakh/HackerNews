//
//  HNNetworkService.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNNetworkService.h"
#import <Firebase/Firebase.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "FQuery+RACExtensions.h"

static NSString *FireBaseURLPath = @"https://hacker-news.firebaseio.com/v0";

@interface HNNetworkService ()

@property (nonatomic) Firebase *fireBaseRef;

@end

@implementation HNNetworkService

+ (id)sharedManager {
    static HNNetworkService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _fireBaseRef = [[Firebase alloc]initWithUrl:FireBaseURLPath];
    }
    return self;
}

- (RACSignal *)observeSingleEventValueWithRef:(Firebase *)ref withQueryLimit:(NSInteger)count {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[ref queryLimitedToFirst:count] observeSingleEventOfType:FEventTypeValue
                            withBlock:^(FDataSnapshot *snapshot) {
                                [subscriber sendNext:snapshot.children.allObjects.rac_sequence];
                                [subscriber sendCompleted];
                            }  withCancelBlock:^(NSError *error) {
                                [subscriber sendError:error];
                            }];
        return nil;
    }];
}

- (RACSignal *)observeSingleEventValueWithRef:(Firebase *)ref {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [ref observeSingleEventOfType:FEventTypeValue
                                                        withBlock:^(FDataSnapshot *snapshot) {
                                                            [subscriber sendNext:snapshot.value];
                                                            [subscriber sendCompleted];
                                                        }  withCancelBlock:^(NSError *error) {
                                                            [subscriber sendError:error];
                                                        }];
        return nil;
    }];
}


- (RACSignal *)topItemsWithCount:(NSInteger)count {
    
    Firebase *topStoriesRef = [self.fireBaseRef childByAppendingPath:@"topstories"];
    
    return [[[[topStoriesRef queryLimitedToFirst:30] rac_valueSignal]
                                   flattenMap:^RACStream *(FDataSnapshot *value) {
    
                                       return [value.children.allObjects.rac_sequence.signal
                                               flattenMap:^RACStream *(FDataSnapshot *item) {
                                                   
                                                   return [[self.fireBaseRef childByAppendingPath:[NSString stringWithFormat:@"item/%@", item.value]] rac_valueSignal];
                                               }];
                                       
                                   }] map:^id(FDataSnapshot *snap) {
                                       return snap.value;
                                   }];
}


- (RACSignal *)childrenForItem:(NSNumber *)itemId {
    
    Firebase *commentsRef = [self.fireBaseRef childByAppendingPath:[NSString stringWithFormat:@"item/%@/kids", itemId]];;
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [commentsRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
//            snapshot.children
        } withCancelBlock:^(NSError *error) {
            //
        }];
        
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
    
    
    
    
//    return [RACSignal empty];
}

@end
