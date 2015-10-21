//
//  HNContainerController.m
//  HackerNews
//
//  Created by Daniel on 10/3/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNContainerController.h"
#import "UIColor+HNColorPalette.h"
#import "HNCommentsController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIViewController+ScrollingNavbar.h"


@interface HNContainerController ()

@property (weak, nonatomic) IBOutlet UIView *browserContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *browserContainerTopConstraint;
@property (nonatomic) HNCommentsController *commentsController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsContainerTopConstraint;

@end

@implementation HNContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.commentsController = [[self.childViewControllers.rac_sequence filter:^BOOL(UIViewController *child) {
        return [child isKindOfClass:[HNCommentsController class]];
    }] head];
    
    
    [RACObserve(self, commentsController.tableView.contentOffset) subscribeNext:^(NSValue *offsetPoint) {
        CGFloat offset = 208 + offsetPoint.CGPointValue.y;
        self.browserContainerTopConstraint.constant = -offset;
    }];
    
    
//    [self setUseSuperview:YES];
//    [self followScrollView:self.commentsController.tableView usingTopConstraint:self.commentsContainerTopConstraint];

    
}

@end
