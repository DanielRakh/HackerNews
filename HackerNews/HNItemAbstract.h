//
//  HNRegularItem.h
//  HackerNews
//
//  Created by Daniel on 4/30/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNItemAbstract : NSObject

@property (nonatomic) NSNumber * idNum;
@property (nonatomic) NSNumber *rank;
@property (nonatomic) NSString * by;
@property (nonatomic) NSNumber * dead;
@property (nonatomic) NSNumber * deleted;
@property (nonatomic) NSString * text;
@property (nonatomic) NSNumber * time;
@property (nonatomic) NSString * type;

@end
