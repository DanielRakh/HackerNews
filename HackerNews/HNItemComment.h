//
//  HNItemComment.h
//  HackerNews
//
//  Created by Daniel on 4/30/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNItemAbstract.h"

@interface HNItemComment : HNItemAbstract

@property (nonatomic) NSNumber *parentIDNum;
@property (nonatomic) NSArray *kids;
@property (nonatomic) NSMutableArray *replies; 


@end
