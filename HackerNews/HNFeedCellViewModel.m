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
        _score = [NSString stringWithFormat:@"%@ Points", story.score.stringValue];
        _title = [HNUtilities proximaNovaStyleStringForTitle:story.title withURL:story.url];
        _commentsCount = [HNUtilities stringForCommentsCount:story.descendantsCount];
        _info = [NSString stringWithFormat: @"by %@ | %@", story.by, [HNUtilities timeAgoFromTimestamp:story.time]];
    }
    
    return self;
}

- (HNCommentsViewModel *)commentsViewModel {
    HNCommentsViewModel *viewModel = [[HNCommentsViewModel alloc]initWithStory:self.story];
    return viewModel;
}





@end
