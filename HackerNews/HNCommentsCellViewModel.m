//
//  HNCommentsCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCellViewModel.h"
#import "HNComment.h"
#import "Utils.h"


@interface HNCommentsCellViewModel ()

@property (nonatomic) HNComment *comment;

@property (nonatomic, readwrite) NSAttributedString *origination;
@property (nonatomic, readwrite) NSAttributedString *text;

@end

@implementation HNCommentsCellViewModel


- (instancetype)initWithComment:(HNComment *)comment {
    self = [super init];
    if (self) {

        _comment = comment;
        _origination = [[NSAttributedString alloc]initWithString: @"by danielrak | 5 hrs ago"];
        _text = [Utils convertHTMLToAttributedString:comment.text_];

    }
    
    return self;
}

@end
