//
//  HNComment.h
//  
//
//  Created by Daniel on 4/23/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HNItem.h"

@class HNComment, HNStory;

@interface HNComment : HNItem

@property (nonatomic, retain) NSNumber * parent_;
@property (nonatomic, retain) NSOrderedSet *replies;
@property (nonatomic, retain) HNStory *story;
@property (nonatomic, retain) HNComment *reply;
@end

@interface HNComment (CoreDataGeneratedAccessors)

- (void)insertObject:(HNComment *)value inRepliesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRepliesAtIndex:(NSUInteger)idx;
- (void)insertReplies:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRepliesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRepliesAtIndex:(NSUInteger)idx withObject:(HNComment *)value;
- (void)replaceRepliesAtIndexes:(NSIndexSet *)indexes withReplies:(NSArray *)values;
- (void)addRepliesObject:(HNComment *)value;
- (void)removeRepliesObject:(HNComment *)value;
- (void)addReplies:(NSOrderedSet *)values;
- (void)removeReplies:(NSOrderedSet *)values;
@end
