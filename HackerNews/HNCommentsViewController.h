//
//  HNCommentsViewController.h
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNCommentsViewModel;
@class RZCellSizeManager;

@interface HNCommentsViewController : UIViewController

@property (nonatomic) HNCommentsViewModel *viewModel;
@property (nonatomic) RZCellSizeManager *cellSizeManager;


@end
