//
//  HNItemStory.h
//  HackerNews
//
//  Created by Daniel on 4/30/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNItemAbstract.h"

@interface HNItemStory : HNItemAbstract

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *url;
@property (nonatomic) NSNumber *score;
@property (nonatomic) NSNumber *descendantsCount;
@property (nonatomic) NSArray *comments;


@end
