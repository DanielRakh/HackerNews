//
//  HNBrowserViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/4/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HNPost;


@interface HNBrowserViewModel : NSObject

@property (nonatomic, readonly) NSURL *url;

- (instancetype)initWithPost:(HNPost *)post;


@end
