//
//  HNCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//


#import "HNUtilities.h"

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
        _title = [HNUtilities proximaNovaStyleStringForTitle:story.title_ withURL:story.url_];
        _commentsCount = [HNUtilities stringForCommentsCount:story.descendants_];
        _info = [NSString stringWithFormat: @"by %@ | %@", story.by_, [HNUtilities timeAgoFromTimestamp:story.time_]];
    }
    
    return self;
}

- (HNCommentsViewModel *)commentsViewModel {
    HNCommentsViewModel *viewModel = [[HNCommentsViewModel alloc]initWithStory:self.story];
    return viewModel;
}





@end
