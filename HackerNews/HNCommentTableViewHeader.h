//
//  HNCommentTableViewHeader.h
//  HackerNews
//
//  Created by Daniel on 4/22/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNCommentTableViewHeader : UITableViewHeaderFooterView


@property (nonatomic) UIView *cardView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) UILabel *originationLabel;


@end
