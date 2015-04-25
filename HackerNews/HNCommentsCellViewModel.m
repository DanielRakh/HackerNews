//
//  HNCommentsCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCellViewModel.h"
#import "HNUtilities.h"
#import "HNComment.h"
#import "HNUtilities.h"
#import "UIFont+HNFont.h"
#import "UIColor+HNColorPalette.h"


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
        _origination = [HNUtilities originationLabelForAuthor:comment.by_ time:comment.time_];
        _text = [HNUtilities proximaNovaStyledCommentStringForHTML:comment.text_];
        _repliesCount = [NSString stringWithFormat:@"%ld Replies", comment.kids_.count];
        
        [_repliesButtonCommand.executing subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }
    
    return self;
}



@end
