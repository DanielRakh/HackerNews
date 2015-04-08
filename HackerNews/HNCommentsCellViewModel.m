//
//  HNCommentsCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCellViewModel.h"

@implementation HNCommentsCellViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _origination = [[NSAttributedString alloc]initWithString: @"by danielrak | 5 hrs ago"];
    }
    return self;
}

@end
