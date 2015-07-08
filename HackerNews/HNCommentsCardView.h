//
//  HNCommentsCardView.h
//  
//
//  Created by Daniel on 7/7/15.
//
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"

@class HNCommentsCellViewModel;

@interface HNCommentsCardView : UIView

@property (nonatomic) RATreeView *treeView;


- (instancetype)initWithViewModel:(HNCommentsCellViewModel *)viewModel;

@end
