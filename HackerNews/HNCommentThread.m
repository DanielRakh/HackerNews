//
//  HNCommentThread.m
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentThread.h"
#import "HNComment.h"

@interface HNCommentThread ()

@property (nonatomic, readwrite) HNComment *headComment;
@property (nonatomic, readwrite) NSArray *replies;

@end

@implementation HNCommentThread

- (instancetype)initWithHeadComment:(HNComment *)headComment replies:(NSArray *)replies {
    self = [super init];
    if (self) {
        _headComment = headComment;
        _replies = replies;
    }
    
    return self;
}

+ (HNCommentThread *)threadWithTopComment:(HNComment *)headComment replies:(NSArray *)replies {
    
    return [[self alloc]initWithHeadComment:headComment replies:replies];
}

- (void)addReply:(HNComment *)reply {

    NSMutableArray *mutableCopy = [self.replies mutableCopy];
    [mutableCopy addObject:reply];
    self.replies = [mutableCopy copy];
}


@end
