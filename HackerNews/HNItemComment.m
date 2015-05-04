//
//  HNItemComment.m
//  HackerNews
//
//  Created by Daniel on 4/30/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNItemComment.h"

@implementation HNItemComment

- (id)init {
    self = [super init];
    if (self) {
        _replies = [NSMutableArray array];
    }
    return self;
}

@end
