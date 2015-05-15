//
//  HNCommentsCellViewModel.h
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

@class HNItemComment, HNCommentThread, HNRepliesCellViewModel;

@interface HNCommentsCellViewModel : RVMViewModel

@property (nonatomic, readonly) NSArray *commentThreadArray;
@property (nonatomic, readonly) HNRepliesCellViewModel *repliesCellViewModel;


- (instancetype)initWithThread:(HNCommentThread *)commentThread;


- (HNRepliesCellViewModel *)repliesViewModelForRootComment:(HNItemComment *)rootComment;


@end
