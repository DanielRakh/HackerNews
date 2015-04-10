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


@interface HNNetworkService ()

//@property (nonatomic) Firebase *topStoriesRef;

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
    }
    return self;
}

- (RACSignal *)topItemsWithCount:(NSInteger)count {
    
    NSMutableArray *posts = [NSMutableArray arrayWithCapacity:count];
    
    Firebase *topStoriesRef = [[Firebase alloc]initWithUrl:@"https://hacker-news.firebaseio.com/v0/topstories"];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[topStoriesRef queryLimitedToFirst:count]observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            [snapshot.children.allObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                Firebase *itemRef = [[[Firebase alloc]initWithUrl:@"https://hacker-news.firebaseio.com/v0/item/"] childByAppendingPath:[NSString stringWithFormat:@"%@", ((FDataSnapshot *)obj).value]];
            
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
    
    
    
    
    return [RACSignal empty];
}

@end
