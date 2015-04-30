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

@class HNComment;

@interface HNCommentsCellViewModel : RVMViewModel


//@property (nonatomic, readonly) RACSignal *updatedContentSignal;


- (instancetype)initWithComment:(HNComment *)comment;

@end
