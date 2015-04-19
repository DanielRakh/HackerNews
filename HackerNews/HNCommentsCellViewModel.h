//
//  HNCommentsCellViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNComment;

@interface HNCommentsCellViewModel : NSObject

@property (nonatomic, readonly) NSAttributedString *origination;
@property (nonatomic, readonly) NSAttributedString *text;
@property (nonatomic, readonly) NSString *repliesCount;


- (instancetype)initWithComment:(HNComment *)comment;

@end
