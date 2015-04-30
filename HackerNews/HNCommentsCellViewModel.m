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
#import "HNDataManager.h"
#import "ReactiveCoreData.h"
#import "HNCommentThread.h"

@interface HNCommentsCellViewModel ()

@property (nonatomic) HNComment *comment;
@property (weak, nonatomic) HNDataManager *dataManager;


@property (nonatomic, readwrite) NSAttributedString *origination;
@property (nonatomic, readwrite) NSAttributedString *text;
@property (nonatomic, readwrite) RACSignal *updatedContentSignal;


@property (nonatomic) NSMutableArray *dataArray;

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
        
        _dataArray = [NSMutableArray array];
        
        _dataManager = [HNDataManager sharedManager];
        
        self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"HNCommentsCellViewModel updatedContentSignal"];
        
        @weakify(self)
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [[_dataManager saveThreadForComment:_comment.id_] subscribeCompleted:^{
//                NSLog(@"COMPLETED");
                _dataArray = [self threadForHeadComment:_comment];
            }];
    
            //
        }];
        
    }
    
    return self;
}


- (NSMutableArray *)threadForHeadComment:(HNComment *)comment {
    
    NSMutableArray *replyArray = [NSMutableArray array];
    
    for (HNComment *reply in comment.replies) {
        
        HNCommentThread *thread = [HNCommentThread threadWithTopComment:reply
                                                               replies:reply.replies.count == 0 ? nil : [self threadForHeadComment:reply]];
        [replyArray addObject:thread];
    }
    
    return replyArray;
}

//- (RACSignal *)tstSignal {
//
//     topComments[1[r.r],2, 3[r], 4, 5, 6[r[r],r]]
//     We have the top comment.
//     Find all replies - find all where
//    
//     Take "replies" of HNComment
//     Grab all
//
//
//    HNComment *com = [[HNComment alloc]init]
//    com.repl
//    [HNComment findAll]where:<#(id)#> equals:<#(id)#>
//}



@end
