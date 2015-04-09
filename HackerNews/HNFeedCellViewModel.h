//
//  HNCellViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNStory;
@class HNCommentsViewModel;

@interface HNFeedCellViewModel : NSObject

@property (nonatomic, readonly) NSString *score;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *commentsCount;
@property (nonatomic, readonly) NSString *info;

- (instancetype)initWithStory:(HNStory *)story;

- (HNCommentsViewModel *)commentsViewModel;

@end
