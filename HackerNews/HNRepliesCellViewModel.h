//
//  HNRepliesCellViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/30/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "RVMViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"


@class HNItemComment;

@interface HNRepliesCellViewModel : RVMViewModel

@property (nonatomic, readonly) RACSignal *updatedContentSignal;

@property (nonatomic, readonly) NSAttributedString *origination;
@property (nonatomic, readonly) NSAttributedString *text;
@property (nonatomic, readonly) NSString *repliesCount;



- (instancetype)initWithReply:(HNItemComment *)reply;



@end
