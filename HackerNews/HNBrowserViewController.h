//
//  HNBrowserController.h
//  HackerNews
//
//  Created by Daniel on 4/4/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNBrowserViewModel;

@interface HNBrowserViewController : UIViewController

@property (nonatomic) HNBrowserViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;

@end
