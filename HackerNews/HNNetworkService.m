//
//  HNNetworkService.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNNetworkService.h"
#import <Firebase/Firebase.h>


@interface HNNetworkService ()

@property (nonatomic) Firebase *topStoriesRef;

@end

@implementation HNNetworkService

-(instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}




@end
