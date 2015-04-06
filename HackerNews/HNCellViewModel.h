//
//  HNCellViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNPost;
@class HNCommentsViewModel;

@interface HNCellViewModel : NSObject

@property (nonatomic, readonly) NSString *score;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *commentsCount;
@property (nonatomic, readonly) NSString *info;
@property (nonatomic, readonly) HNPost *post;

- (instancetype)initWithPost:(HNPost *)post;

- (HNCommentsViewModel *)commentsViewModel;

@end
