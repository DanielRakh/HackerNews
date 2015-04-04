//
//  HNCellViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNPost;

@interface HNCellViewModel : NSObject

@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *commentsCount;
@property (nonatomic, strong) NSString *info;

- (instancetype)initWithPost:(HNPost *)post;

@end
