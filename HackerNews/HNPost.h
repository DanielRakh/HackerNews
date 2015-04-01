//
//  HNPost.h
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNPost : NSObject

@property (nonatomic) NSNumber *id;
@property (nonatomic) BOOL deleted;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *by;
@property (nonatomic) NSNumber *time;
@property (nonatomic) NSString *text;
@property (nonatomic) BOOL dead;


@property (nonatomic) NSNumber *parent;
@property (nonatomic) NSArray *kids;
@property (nonatomic) NSString *url;
@property (nonatomic) NSNumber *score;
@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *parts;
@property (nonatomic) NSNumber *descendants;

@end
