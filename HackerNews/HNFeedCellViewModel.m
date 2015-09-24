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
#import "HNItemStory.h"

@interface HNFeedCellViewModel ()

@property (nonatomic, readwrite) HNItemStory *story;

@end

@implementation HNFeedCellViewModel

- (instancetype)initWithStory:(HNItemStory *)story {
    self = [super init];
    if (self) {
        
        _story = story;
        _url = story.url;
        _title = story.title;
        _commentsCount = [HNUtilities stringForCommentsCount:story.descendantsCount];
        _info = [NSString stringWithFormat: @"%@ Points | %@ | %@", story.score.stringValue, story.by, [HNUtilities timeAgoFromTimestamp:story.time]];
    }
    
    return self;
}

- (HNCommentsViewModel *)commentsViewModel {
    HNCommentsViewModel *viewModel = [[HNCommentsViewModel alloc]initWithStory:self.story];
    return viewModel;
}





@end
