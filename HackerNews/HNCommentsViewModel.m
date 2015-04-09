//
//  HNCommentsViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsViewModel.h"
#import "HNPost.h"

@interface HNCommentsViewModel ()

@property (nonatomic) HNPost *post;

@end


@implementation HNCommentsViewModel

- (instancetype)initWithPost:(HNPost *)post {
    self = [super init];
    if (self) {
        _post = post;
    }
    return self;
}



@end
