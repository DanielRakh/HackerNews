//
//  HNCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCellViewModel.h"
#import "HNPost.h"
#import <DateTools/NSDate+DateTools.h>

@implementation HNCellViewModel

- (instancetype)initWithPost:(HNPost *)post {
    self = [super init];
    if (self) {
        _score = [NSString stringWithFormat:@"%@ Points", post.score.stringValue];
        _title = post.title;
        _commentsCount = post.descendants.stringValue;
        _info = [NSString stringWithFormat: @"by %@ | %@", post.by, [self formattedStringForTime:post.time]];
    }
    return self;
}


- (NSString *)formattedStringForTime:(NSNumber *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.doubleValue];
    NSString *timeString = date.timeAgoSinceNow;
    return timeString;
}


@end
