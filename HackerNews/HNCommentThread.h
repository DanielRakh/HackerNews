//
//  HNCommentThread.h
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNComment;

@interface HNCommentThread : NSObject

@property (nonatomic, readonly) HNComment *headComment;
@property (nonatomic, readonly) NSArray *replies;

+ (HNCommentThread *)threadWithTopComment:(HNComment *)topComment replies:(NSArray *)replies;

- (instancetype)initWithHeadComment:(HNComment *)headComment replies:(NSArray *)replies;

- (void)addReply:(HNCommentThread *)reply;

@end
