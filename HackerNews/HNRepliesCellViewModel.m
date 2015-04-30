//
//  HNRepliesCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/30/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNRepliesCellViewModel.h"
#import "HNItemComment.h"
#import "HNUtilities.h"

@interface HNRepliesCellViewModel ()

@property (nonatomic) HNItemComment *reply;

@property (nonatomic, readwrite) NSAttributedString *origination;
@property (nonatomic, readwrite) NSAttributedString *text;
@property (nonatomic, readwrite) RACSignal *updatedContentSignal;


@end

@implementation HNRepliesCellViewModel

- (instancetype)initWithReply:(HNItemComment *)reply {
    
    self = [super init];
    if (self) {
        _reply = reply;
        _origination = [HNUtilities originationLabelForAuthor:reply.by time:reply.time];
        _text = [HNUtilities proximaNovaStyledCommentStringForHTML:reply.text];
        _repliesCount = [NSString stringWithFormat:@"%ld Replies", reply.replies.count];
    }
    
    return self;
}



@end
