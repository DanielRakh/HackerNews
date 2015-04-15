//
//  HNCommentsCellViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNComment;

@interface HNCommentsCellViewModel : NSObject

@property (nonatomic, readonly) NSAttributedString *origination;
@property (nonatomic, readonly) NSAttributedString *text;


- (instancetype)initWithComment:(HNComment *)comment;

@end
