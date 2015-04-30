//
//  HNCellViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNItemStory;
@class HNCommentsViewModel;

@interface HNFeedCellViewModel : NSObject

@property (nonatomic, readonly) NSString *score;
@property (nonatomic, readonly) NSAttributedString *title;
@property (nonatomic, readonly) NSString *commentsCount;
@property (nonatomic, readonly) NSString *info;

- (instancetype)initWithStory:(HNItemStory *)story;

- (HNCommentsViewModel *)commentsViewModel;

@end
