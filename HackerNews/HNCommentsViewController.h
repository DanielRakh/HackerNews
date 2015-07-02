//
//  HNCommentsViewController.h
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNCommentsViewModel;

@interface HNCommentsViewController : UIViewController

@property (nonatomic) HNCommentsViewModel *viewModel;

@end
