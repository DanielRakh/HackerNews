//
//  HNCommentThread.m
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentThread.h"
#import "HNItemComment.h"

@interface HNCommentThread ()

@property (nonatomic, readwrite) HNItemComment *headComment;
@property (nonatomic, readwrite) NSArray *replies;

@end

@implementation HNCommentThread

- (instancetype)initWithHeadComment:(HNItemComment *)headComment replies:(NSArray *)replies {
    self = [super init];
    if (self) {
        _headComment = headComment;
        _replies = replies;
    }
    
    return self;
}

+ (HNCommentThread *)threadWithTopComment:(HNItemComment *)headComment replies:(NSArray *)replies {
    
    return [[self alloc]initWithHeadComment:headComment replies:replies];
}

- (void)addReply:(HNCommentThread *)reply {

    if (self.replies == nil) {
        self.replies = [NSArray array];
    }
    NSMutableArray *mutableCopy = [self.replies mutableCopy];
    [mutableCopy addObject:reply];
    self.replies = [mutableCopy copy];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.headComment];
}

@end
