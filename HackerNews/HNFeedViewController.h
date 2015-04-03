//
//  ViewController.h
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNFeedViewModel;

@interface HNFeedViewController : UIViewController

@property (nonatomic) HNFeedViewModel *viewModel;

@end

