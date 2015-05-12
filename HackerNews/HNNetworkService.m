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

- (RACSignal *)topStoryItemsWithCount:(NSInteger)count {
    
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
    
#warning Add some error handling up in this bitch. 
    
}

- (RACSignal *)childForItem:(NSNumber *)itemId {
    
    Firebase *commentsRef = [self.fireBaseRef childByAppendingPath:[NSString stringWithFormat:@"item/%@/kids", itemId]];
    
    return [[[commentsRef rac_valueSignal]
             flattenMap:^RACStream *(FDataSnapshot *value) {
                 return [value.children.allObjects.rac_sequence.signal
                              flattenMap:^RACStream *(FDataSnapshot *item) {
                                  
                                  return [[self.fireBaseRef childByAppendingPath:[NSString stringWithFormat:@"item/%@", item.value]] rac_valueSignal];
                              }];
    }] map:^id(FDataSnapshot *snap) {
        return snap.value;
    }];
}

- (RACSignal *)kidsForItem:(NSNumber *)itemID {
    
    Firebase *kidsRef = [self.fireBaseRef childByAppendingPath:[NSString stringWithFormat:@"item/%@/kids", itemID]];
    
    return [[kidsRef.rac_valueSignal
            flattenMap:^RACStream *(FDataSnapshot *value) {
                return [value.children.allObjects.rac_sequence.signal
                        map:^id(FDataSnapshot *nestedValue) {
                            return nestedValue.value;
        }];
    }] collect];
}


- (RACSignal *)valueForItem:(NSNumber *)itemID {
    
    Firebase *itemRef = [self.fireBaseRef childByAppendingPath:[NSString stringWithFormat:@"item/%@",itemID]];
    
    return [itemRef.rac_valueSignal map:^id(FDataSnapshot *snapshot) {
        return snapshot.value;
    }];
    
}


@end
