//
//  HNStory.h
//  HackerNews
//
//  Created by Daniel on 4/8/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HNItem.h"

@class HNComment;

@interface HNStory : HNItem

@property (nonatomic, retain) NSString * title_;
@property (nonatomic, retain) NSString * url_;
@property (nonatomic, retain) NSNumber * score_;
@property (nonatomic, retain) NSNumber * descendants_;
@property (nonatomic, retain) NSOrderedSet *comments;
@end

@interface HNStory (CoreDataGeneratedAccessors)

- (void)insertObject:(HNComment *)value inCommentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommentsAtIndex:(NSUInteger)idx;
- (void)insertComments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommentsAtIndex:(NSUInteger)idx withObject:(HNComment *)value;
- (void)replaceCommentsAtIndexes:(NSIndexSet *)indexes withComments:(NSArray *)values;
- (void)addCommentsObject:(HNComment *)value;
- (void)removeCommentsObject:(HNComment *)value;
- (void)addComments:(NSOrderedSet *)values;
- (void)removeComments:(NSOrderedSet *)values;
@end
