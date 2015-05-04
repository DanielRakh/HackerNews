//
//  HNCommentThread.h
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNItemComment;

@interface HNCommentThread : NSObject

@property (nonatomic, readonly) HNItemComment *headComment;
@property (nonatomic, readonly) NSArray *replies;

+ (HNCommentThread *)threadWithTopComment:(HNItemComment *)topComment replies:(NSArray *)replies;

- (instancetype)initWithHeadComment:(HNItemComment *)headComment replies:(NSArray *)replies;

- (void)addReply:(HNCommentThread *)reply;

@end
