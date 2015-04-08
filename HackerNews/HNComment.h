//
//  HNComment.h
//  HackerNews
//
//  Created by Daniel on 4/8/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HNItem.h"

@class HNComment, HNStory;

@interface HNComment : HNItem

@property (nonatomic, retain) NSNumber * parent_;
@property (nonatomic, retain) NSOrderedSet *kids;
@property (nonatomic, retain) HNStory *story;
@end

@interface HNComment (CoreDataGeneratedAccessors)

- (void)insertObject:(HNComment *)value inKidsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromKidsAtIndex:(NSUInteger)idx;
- (void)insertKids:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeKidsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInKidsAtIndex:(NSUInteger)idx withObject:(HNComment *)value;
- (void)replaceKidsAtIndexes:(NSIndexSet *)indexes withKids:(NSArray *)values;
- (void)addKidsObject:(HNComment *)value;
- (void)removeKidsObject:(HNComment *)value;
- (void)addKids:(NSOrderedSet *)values;
- (void)removeKids:(NSOrderedSet *)values;

@end
