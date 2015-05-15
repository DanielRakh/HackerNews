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


@interface HNCommentsCell : UITableViewCell

@property (nonatomic) HNCommentsCellViewModel *viewModel;
@property (nonatomic, readonly) RATreeView *treeView;


@end
