//
//  HNCommentsCell.h
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"

@class HNCommentsCellViewModel;
@class RATreeView;


@interface HNCommentsContainerCell : UITableViewCell

@property (nonatomic) HNCommentsCellViewModel *viewModel;
@property (nonatomic) RATreeView *treeView;

@property (nonatomic) NSLayoutConstraint *treeViewHeightConstraint;


@property (nonatomic, assign) BOOL expandChild;




- (void)keepCellExpanded;

@end
