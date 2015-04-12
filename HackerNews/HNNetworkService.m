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

- (RACSignal *)topItemsWithCount:(NSInteger)count {
    
    NSMutableArray *posts = [NSMutableArray arrayWithCapacity:count];
    
    Firebase *topStoriesRef = [self.fireBaseRef childByAppendingPath:@"topstories"];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[topStoriesRef queryLimitedToFirst:count]observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            [snapshot.children.allObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                Firebase *itemRef = [self.fireBaseRef childByAppendingPath:[NSString stringWithFormat:@"item/%@", ((FDataSnapshot *)obj).value]];
            
                [itemRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                    
                    [posts addObject:snapshot.value];
                    
                    if (posts.count == count) {
                        [subscriber sendNext:posts];
                        [subscriber sendCompleted];
                    }
                    
                }];
               
            }];
            
        } withCancelBlock:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return nil;
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
