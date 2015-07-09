//
//  HNCommentsThreadCardView.h
//  
//
//  Created by Daniel on 7/9/15.
//
//

#import "HNCommentsCardView.h"
#import "RATreeView.h"


@class HNCommentsCellViewModel;

@interface HNCommentsThreadCardView : HNCommentsCardView


@property (nonatomic) RATreeView *treeView;

- (instancetype)initWithViewModel:(HNCommentsCellViewModel *)viewModel;



@end
