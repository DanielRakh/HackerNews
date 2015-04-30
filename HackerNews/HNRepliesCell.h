//
//  HNRepliesCell.h
//  HackerNews
//
//  Created by Daniel on 4/25/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNRepliesCellViewModel;

@interface HNRepliesCell : UITableViewCell

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel;

@end
