//
//  HNCommentsViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNPost;

@interface HNCommentsViewModel : NSObject


- (instancetype)initWithPost:(HNPost *)post;

@end
