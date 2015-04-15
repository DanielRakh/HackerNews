//
//  HNCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//


#import <DateTools/NSDate+DateTools.h>

//View Model
#import "HNCommentsViewModel.h"
#import "HNFeedCellViewModel.h"

// Model
#import "HNStory.h"

@interface HNFeedCellViewModel ()

@property (nonatomic, readwrite) HNStory *story;

@end

@implementation HNFeedCellViewModel

- (instancetype)initWithStory:(HNStory *)story {
    self = [super init];
    if (self) {
        _story = story;
        _score = [NSString stringWithFormat:@"%@ Points", story.score_.stringValue];
        _title = story.title_;
        _commentsCount = story.descendants_.stringValue;
        _info = [NSString stringWithFormat: @"by %@ | %@", story.by_, [self formattedStringForTime:story.time_]];
    }
    
    return self;
}

- (HNCommentsViewModel *)commentsViewModel {
    HNCommentsViewModel *viewModel = [[HNCommentsViewModel alloc]initWithStory:self.story];
    return viewModel;
}


#pragma mark - Helper Methods

- (NSString *)formattedStringForTime:(NSNumber *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.doubleValue];
    NSString *timeString = date.timeAgoSinceNow;
    return timeString;
}

@end
