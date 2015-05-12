//
//  HNCommentsCell.h
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNCommentsCellViewModel;

@interface HNCommentsCell : UITableViewCell



- (void)configureWithViewModel:(HNCommentsCellViewModel *)viewModel;

@end
