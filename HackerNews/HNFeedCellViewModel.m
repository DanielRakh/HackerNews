//
//  HNCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNFeedCellViewModel.h"
//#import "HNPost.h"
#import "HNStory.h"
#import <DateTools/NSDate+DateTools.h>
#import "HNCommentsViewModel.h"

@interface HNFeedCellViewModel ()

//@property (nonatomic, readwrite) HNPost *post;

@end

@implementation HNFeedCellViewModel

- (instancetype)initWithStory:(HNStory *)story {
    self = [super init];
    if (self) {
//        _post = post;
        _score = [NSString stringWithFormat:@"%@ Points", story.score_.stringValue];
        _title = story.title_;
        _commentsCount = story.descendants_.stringValue;
        _info = [NSString stringWithFormat: @"by %@ | %@", story.by_, [self formattedStringForTime:story.time_]];
    }
    return self;
}


- (NSString *)formattedStringForTime:(NSNumber *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.doubleValue];
    NSString *timeString = date.timeAgoSinceNow;
    return timeString;
}

- (HNCommentsViewModel *)commentsViewModel {
//    HNCommentsViewModel *viewModel = [[HNCommentsViewModel alloc]initWithPost:self.post];
//    return viewModel;
    return nil;
}



@end
