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

@interface HNContainerController ()

@property (weak, nonatomic) IBOutlet UIView *browserContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *browserContainerTopConstraint;
@property (nonatomic) HNCommentsController *commentsController;

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
}

@end
